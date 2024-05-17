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
SELECT COUNT(*) AS NumeroOrdini, SUM(importo) AS ImportoTotale, AVG(importo) AS ImportoMedio, COUNT(DISTINCT codp) AS PizzeDiverse
FROM ordine

/*11. Trovare, per ogni cliente che abbia ordinato almeno una pizza, il numero
totale, l'importo totale e medio dei suoi ordini ed infine il numero di pizze
diverse ordinate*/
SELECT telc, COUNT(*) AS NumeroOrdini, SUM(importo) AS ImportoTotale, AVG(importo) AS ImportoMedio, COUNT(DISTINCT codp) AS PizzeDiverse
FROM ordine
GROUP BY telc

/*12. Trovare il nome delle pizze appartenenti ad ordini del 2021 il cui importo
risulti essere inferiore al prezzo per la quantità ordinata*/
SELECT P.nome, O.importo AS ImportoPagato, P.prezzo * O.qta AS ImportoDaPagare
FROM ordine O NATURAL JOIN pizza P
WHERE DATE_PART('year', O.data) = 2021
AND O.importo < P.prezzo * O.qta

/*13. Trovare il codice delle pizze con almeno 3 ingredienti restituendo anche il
numero di ingredienti effettivi*/
SELECT codp, COUNT(*) AS NumeroIngredienti
FROM ingrediente
GROUP BY codp
HAVING COUNT(*) >= 3

/*14. Trovare il codice delle pizze con il maggior numero di ingredienti
restituendo anche il numero di ingredienti effettivi*/
SELECT codp, COUNT(*) AS NumeroIngredienti
FROM ingrediente
GROUP BY codp
HAVING COUNT(*) >= ALL (
	SELECT COUNT(*)
	FROM ingrediente
	GROUP BY codp
)

/*15. Restituire in una singola colonna, cognome e nome dei clienti che hanno
ordinato il minor numero di pizze margherita (ma almeno una)*/
DROP VIEW PizzeMargheritaOrdinate; --Per poter rieseguire la Query

CREATE VIEW PizzeMargheritaOrdinate(telc, num)
AS SELECT *
	  FROM ordine
	  WHERE codp = (
	  	SELECT codp
		FROM pizza
		WHERE nome = 'margherita');

SELECT CONCAT(C.nomec, ' ', C.cognomec) AS NomeCompleto
FROM PizzeMargheritaOrdinate NATURAL JOIN cliente C
GROUP BY C.nomec, C.cognomec
HAVING COUNT(*) <= ALL
	(SELECT COUNT(*)
	FROM PizzeMargheritaOrdinate
	GROUP BY telc)

/*16. Trovare i clienti che hanno ordinato (almeno una volta) la pizza
capricciosa oppure ai quattro formaggi*/
SELECT DISTINCT nomec, cognomec
FROM ordine NATURAL JOIN cliente
WHERE codp IN (
	SELECT codp
	FROM pizza
	WHERE nome IN ('capricciosa', 'quattro formaggi'))

/*17. Trovare i clienti che hanno ordinato (almeno una volta) la pizza
capricciosa oppure ai quattro formaggi usando gli operatori insiemistici*/
(SELECT telc
FROM ordine NATURAL JOIN pizza
WHERE nome = 'capricciosa')
UNION 
(SELECT telc
FROM ordine NATURAL JOIN pizza
WHERE nome = 'quattro formaggi')

/*18. Trovare le pizze che contengono sia mozzarella sia olive usando gli
operatori insiemistici*/
SELECT codp, nome
FROM pizza NATURAL JOIN ingrediente
WHERE ingrediente = 'mozzarella'
INTERSECT 
SELECT codp, nome
FROM pizza NATURAL JOIN ingrediente
WHERE ingrediente = 'olive'

/*19. Trovare le pizze che contengono sia mozzarella sia olive usando
l'operatore IN*/
SELECT codp, nome
FROM pizza NATURAL JOIN ingrediente
WHERE ingrediente = 'mozzarella'
AND codp IN (
	SELECT codp
	FROM ingrediente
	WHERE ingrediente = 'olive')

/*20. Trovare le pizze che contengono sia mozzarella sia olive usando
l'operatore EXISTS*/
SELECT codp, nome
FROM pizza P1 NATURAL JOIN ingrediente
WHERE ingrediente = 'mozzarella'
AND EXISTS (
	SELECT codp
	FROM  ingrediente
	WHERE ingrediente = 'olive'
	AND P1.codp = codp)

/*21. Determinare il numero di telefono ed i cognome dei clienti che hanno
fatto solo ordini superiori ai 7 euro*/
SELECT telc, cognomec
FROM cliente
WHERE telc <> ALL (
	SELECT telc
	FROM ordine
	WHERE importo <= 7)

/*22. Determinare i numeri di telefono ed i nominativi dei clienti che hanno
fatto solo ordini superiori ai 7 euro usando NOT EXISTS*/
SELECT telc, cognomec
FROM cliente C
WHERE NOT EXISTS (
	SELECT telc
	FROM ordine
	WHERE importo <= 7
	AND C.telc = telc)

/*23. Determinare i numeri di telefono ed i nominativi dei clienti che hanno
fatto solo ordini superiori ai 7 euro usando NOT IN*/
SELECT telc, cognomec
FROM cliente C
WHERE telc NOT IN (
	SELECT telc
	FROM ordine
	WHERE importo <= 7)

/*24. Determinare quali pizze sono state ordinate da tutti i clienti*/
SELECT codp, COUNT(DISTINCT telc)
FROM ordine
GROUP BY codp
HAVING COUNT(DISTINCT telc) = (
	SELECT COUNT(*)
	FROM cliente)
