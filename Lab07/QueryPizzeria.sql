/*1. Trovare i prezzi ed i nomi delle pizze che costano meno di 6 euro*/
SELECT nome, prezzo
FROM pizza
WHERE prezzo < 6

/*2. Trovare gli ingredienti delle pizze*/
SELECT * 
FROM ingrediente

/*3. Trovare il cognome, nome e telefono dei clienti che abitano in via dei
Girasoli ordinati per cognome e nome*/
SELECT cognomec, nomec, telc
FROM cliente
WHERE via = 'via dei Girasoli'

/*4. Trovare il numero di telefono dei clienti che hanno eettuato un ordine di
almeno 5 pizze nell'ultima settimana, spendendo tra i 20 e i 50 euro*/
SELECT telc, SUM(qta) AS NumeroPizze, SUM(importo) AS SpesaTotale
FROM ordine
WHERE data > NOW() - INTERVAL '7 DAYS'
GROUP BY telc
HAVING SUM(qta) >= 5 
	AND SUM(importo) >= 20
	AND SUM(importo) <= 50

/*5. Trovare il nome delle pizze ordinate in data 4 settembre 2009*/
SELECT P.nome, O.data
FROM ordine O NATURAL JOIN pizza P
WHERE O.data = '2009/09/04'

/*6. Trovare i nominativi dei clienti che hanno ordinato almeno una pizza che
contenga le olive di ogni genere (olive verdi, olive nere, pasta di olive
ecc.), insieme alla data e all'importo dell'ordine; presentare il risultato
ordinato in modo decrescente rispetto all'importo e, a parità di importo,
in modo crescente per cognome e nome*/
SELECT C.telc, C.nomec, C.cognomec, O.data, O.importo
FROM ordine O NATURAL JOIN (
		SELECT codp
		FROM ingrediente
		WHERE ingrediente LIKE '%olive%')
	NATURAL JOIN cliente C
ORDER BY O.importo DESC, C.cognomec ASC, C.nomec ASC

/*7. Trovare i clienti "vicini di casa"; due clienti si dicono vicini se abitano nella
stessa via e la differenza dei loro numeri civici è minore di 5*/
SELECT DISTINCT C1.nomec, C1.cognomec, C2.nomec, C2.cognomec
FROM cliente C1, cliente C2
WHERE C1.telc > C2.telc -- Così risolvo duplicazioni
	AND C1.via = C2.via
	AND ABS(C1.nCiv - C2.nCiv) < 5

/*8. Restituire i dati degli ordini per i quali si è applicato uno sconto (cioè gli
ordini per cui l'importo è inferiore al prezzo che si sarebbe dovuto
pagare); riportare anche lo sconto effettuato*/
SELECT O.telc, O.data, O.qta * P.prezzo AS Importo, O.importo AS ImportoScontato, O.qta * P.prezzo - O.importo AS Sconto
FROM ordine O NATURAL JOIN pizza P
WHERE O.qta * P.prezzo > O.importo

/*9. Produrre l'elenco, in ordine alfabetico, dei clienti; per quelli che hanno
eettuato almeno un ordine, riportare nell'elenco le informazioni relative
all'importo e alla data degli ordini effettuati inoltre gli ordini dello stesso
cliente devono essere ordinati dalla data più recente*/
SELECT C.nomec, C.cognomec, C.telc, O.importo, O.data
FROM cliente C LEFT JOIN ordine O ON C.telc = O.telc
ORDER BY C.cognomec , C.nomec, O.data DESC

/*10. Trovare il numero totale, l'importo totale e medio degli ordini dei clienti
ed inne il numero di pizze diverse ordinate*/
SELECT telc, COUNT(*) AS NumeroOrdini, SUM(importo) AS ImportoTotale, AVG(importo) AS ImportoMedio, COUNT(DISTINCT codp) AS PizzeDiverse
FROM ordine
GROUP BY telc








