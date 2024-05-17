/* Interrogazioni Base */

/*1. la matricola dello studente "Mario Rossi", iscritto nell'anno accademico
1999/2000*/
SELECT matricola
FROM studenti
WHERE nome = 'Mario' AND cognome = 'Rossi'
AND iscrizione = '1999/2000'

/*2. i nominativi degli studenti dell'univ. di Milano, non residenti a Milano*/
SELECT cognome, nome
FROM studenti
WHERE residenza <> 'Milano'

/*3. l'elenco alfabetico dei corsi di laurea, ordinati per facoltà, attivati presso
l'Univ. di Milano prima dell'A.A. 1996/1997 (escluso) e dopo l'A.A.
1999/2000 (escluso)*/
SELECT *
FROM corsidilaurea
WHERE attivazione > '1996/1997'
	AND attivazione < '1999/2000'
ORDER BY facolta

/*4. la matricola e i nominativi degli studenti iscritti prima dell'A.A.
2000/2001 che non sono ancora in tesi (non hanno assegnato nessun
relatore)*/
SELECT matricola, nome, cognome
FROM studenti
WHERE iscrizione < '2000/2001'
AND relatore IS NULL

/*5. la matricola degli studenti che hanno registrato dei voti dal 2 febbraio del
1999*/
SELECT DISTINCT studente
FROM esami
WHERE data > '1999/02/02'

/*6. i corsi attivi il cui nome non cominci per "L"*/
SELECT *
FROM corsi
WHERE attivato AND denominazione NOT LIKE 'L%'

/*7. gli identicativi dei professori dell'Univ. di Milano il cui nome contenga la
stringa "te", che abbiano uno stipendio compreso tra i 12500 e i 16000
euro l'anno*/
SELECT id
FROM professori
WHERE nome LIKE '%te%'
AND stipendio >= 12500 AND stipendio <= 16000

/*8. la matricola e i nominativi, in ordine di matricola inverso, degli studenti
che risiedono a Milano, La Spezia e Savona o il cui cognome non è
"Serra", "Melogno" o "Giunchi"*/
SELECT matricola, nome, cognome
FROM studenti
WHERE residenza IN ('Milano', 'La Spezia', 'Savona')
OR cognome NOT IN ('Serra', 'Melogno', 'Giunchi')
ORDER BY matricola DESC

/*9. l'elenco dei corsi di laurea, ordinati per facoltà, attivati tra l'a.a.
1994/1995 e l'a.a. 1999/2000*/
SELECT *
FROM corsidilaurea
WHERE attivazione >= '1994/1995'
AND attivazione <= '1999/2000'
ORDER BY facolta

/* Interrogazioni con Join */

/*1. la matricola degli studenti laureatisi in informatica prima del novembre
1999*/
SELECT matricola
FROM studenti S JOIN corsidilaurea C ON S.corsodilaurea = C.id
WHERE denominazione = 'Informatica'
AND laurea < '1999/11/01'

/*2. l'elenco dei nominativi dei professori, con, per ognuno, i corsi di cui sono
titolari, in ordine decrescente di identicativo di corso*/
SELECT P.id, P.cognome, P.nome, C.id, C.denominazione
FROM professori P JOIN corsi C ON C.professore = P.id
ORDER BY C.id

/*3. l'elenco alfabetico dei corsi attivi, con i nominativi dei professori titolari,
ordinati per corso di laurea*/
SELECT P.id, P.cognome, P.nome, C.id, C.denominazione
FROM professori P JOIN corsi C ON C.professore = P.id
ORDER BY C.id

/*4. l'elenco in ordine alfabetico dei nominativi degli studenti, con, per
ognuno, il cognome del relatore associato*/
SELECT S.matricola, S.cognome, S.nome, P.cognome
FROM studenti S JOIN professori P ON S.relatore = P.id

/*5. l'elenco dei corsi attivi presso il corso di laurea di informatica, il cui nome
abbia, come terza lettera, la lettera "s"*/
SELECT *
FROM corsi C JOIN corsidilaurea CL on C.corsodilaurea = CL.id
WHERE CL.denominazione = 'Informatica'
AND C.denominazione LIKE '__s%'

/*6. la matricola degli studenti di matematica che hanno registrato voti
suffcienti per l'esame di "Informatica Generale" svoltosi il 15 febbraio
2002*/
SELECT S.matricola
FROM esami E join studenti S on E.studente = S.matricola
WHERE E.corso IN (
	SELECT id
	FROM corsi
	WHERE denominazione = 'Informatica Generale')
AND E.data = '2002/02/15'
AND voto >= 18

/*7. l'elenco alfabetico, senza duplicati e in ordine decrescente, degli studenti
che hanno presentato il piano di studi per il quinto anno del corso di
laurea di informatica nell'a.a. 2001/2002 e sono in tesi (hanno assegnato
un relatore)*/
SELECT DISTINCT S.cognome, S.nome
FROM pianidistudio PS JOIN studenti S on PS.studente = S.matricola
WHERE PS.anno = 5
AND PS.annoaccademico = '2001/2002'
AND S.relatore IS NOT NULL
ORDER BY S.cognome DESC, S.nome DESC

/* Interrogazioni con Outer Join */

/*1. l'elenco alfabetico dei corsi, con eventuale nominativo del professore
titolare*/
SELECT C.id, C.denominazione, P.cognome, P.nome
FROM corsi C LEFT JOIN professori P ON C.professore = P.id
ORDER BY denominazione

/*2. l'elenco dei cognomi, in ordine di codice identifcativo, dei professori con
l'indicazione del cognome, del nome e della matricola degli studenti di cui
sono relatori, laddove seguano degli studenti per la tesi*/
SELECT P.cognome, S.matricola, S.nome, S.cognome
FROM professori P LEFT JOIN studenti S ON P.id = S.relatore
ORDER BY P.id

/*3. l'elenco alfabetico degli studenti iscritti a matematica, con l'eventuale
relatore che li segue per la tesi*/
SELECT S.cognome, S.nome, P.cognome
FROM studenti S LEFT JOIN professori P ON s.relatore = P.id
WHERE S.corsodilaurea = (
	SELECT id
	FROM corsidilaurea
	WHERE denominazione = 'Matematica')

/*4. l'elenco, in ordine alfabetico, dei professori con l'indicazione della
matricola degli studenti di cui sono relatori, laddove seguano degli
studenti per la tesi, raggruppati per professore*/
SELECT P.cognome, P.nome, S.matricola
FROM professori P LEFT JOIN studenti S ON P.id = S.relatore
ORDER BY P.cognome, P.nome

/* Interrogazioni con Funzioni di Gruppo */

/*1. lo stipendio massimo, minimo e medio dei professori dell'Univ. di Milano*/
SELECT MAX(stipendio), MIN(stipendio), AVG(stipendio)
FROM professori

/*2. la media dei voti registrati presso il corso di laurea di informatica*/
SELECT AVG(E.voto)
FROM esami E JOIN corsi C ON E.corso = C.id JOIN corsidilaurea CL ON C.corsodilaurea = CL.id
WHERE CL.denominazione = 'Informatica'

/*3. il voto massimo registrato in ogni corso di laurea*/
SELECT CL.denominazione, MAX(E.voto)
FROM esami E JOIN corsi C ON E.corso = C.id RIGHT JOIN corsidilaurea CL ON C.corsodilaurea = CL.id
GROUP BY Cl.id
ORDER BY MAX(E.voto)
	
/*4. i nominativi, in ordine alfabetico, dei professori titolari di più di due corsi
attivi, con l'indicazione di quanti corsi tengono*/
SELECT P.cognome, P.nome, COUNT(C.professore)
FROM corsi C JOIN professori P ON C.professore = P.id
GROUP BY P.cognome, P.nome
HAVING COUNT(C.professore) > 2
ORDER BY P.cognome, P.nome
	
/*5. i nomi dei corsi di informatica per i quali sono stati registrati meno di 5
esami a partire dal 4 gennaio 2002*/
SELECT C.denominazione, COUNT(E.corso)
FROM corsi C LEFT JOIN esami E ON C.id = E.corso
WHERE C.denominazione LIKE '%Informatica%'
GROUP BY C.denominazione
HAVING COUNT(E.corso) < 5

/* Interrogazioni con Colonne Virtuali */

/*1. restituire, per ogni corso di laurea, il nome del corso di laurea e il numero
di iscritti*/
SELECT CL.denominazione, COUNT(DISTINCT S.matricola) AS StudentiIscritti
FROM corsidilaurea CL LEFT JOIN studenti S ON S.corsodilaurea = CL.id
GROUP BY CL.denominazione
ORDER BY StudentiIscritti DESC

/*2. per ogni studente, restituire nome, cognome ed età (utilizzare a tal ne le
funzioni age() e extract() di PostgreSQL)*/
SELECT nome, cognome, age(datanascita)
FROM studenti

/*3. restituire nome e cognome (in un'unica colonna) degli studenti iscritti a
partire dall'anno 1999/2000, ordinati in base al cognome e preceduti dal
titolo 'Dott.' (es. 'Dott. Anna Maddalena')*/
SELECT CONCAT('Dott. ', nome, ' ', cognome) AS NomeCompleto
FROM studenti
WHERE iscrizione >= '1999/2000'
ORDER BY cognome

/*4. per ogni studente, restituire la sua matricola e la media dei voti ottenuti
negli esami che ha passato (dare alla colonna con la media il nome
'mediaMatematica')*/
SELECT S.matricola, AVG(E.voto) AS mediaMatematica
FROM studenti S JOIN esami E ON S.matricola = E.studente
WHERE E.voto >= 18
GROUP BY S.matricola

/*5. per ogni studente che ha sostenuto almeno 3 esami, restituire la sua
matricola e la media dei voti ottenuti negli esami che ha passato
scartando il voto più alto e quello più basso (dare alla colonna con la
media il nome 'mediaPesata')*/
SELECT S.matricola, COUNT(E.Studente), AVG(E.voto)
FROM studenti S JOIN esami E ON S.matricola = E.studente
WHERE E.voto >= 18 
AND E.voto <> (SELECT MAX(E2.voto) FROM esami E2 WHERE E2.studente = E.studente)
AND E.voto <> (SELECT MIN(E2.voto) FROM esami E2 WHERE E2.studente = E.studente)
GROUP BY S.matricola
HAVING COUNT(E.studente) >= 3 

/*6. determinare la votazione media riportata per ogni corso attivo*/
SELECT C.id, AVG(E.voto)
FROM corsi C JOIN esami E ON C.id = E.corso
WHERE C.attivato
GROUP BY C.id

/*7. determinare la matricola e la media dei voti registrati degli studenti di
informatica che hanno registrato almeno due voti nel mese di giugno 2000*/
SELECT S.matricola, AVG(E.voto)
FROM studenti S JOIN esami E ON S.matricola = E.studente
WHERE E.data >= '2000/06/01' AND E.data <= '2000/06/30'
GROUP BY S.matricola
HAVING COUNT(E.studente) >= 2

/* Interrogazioni con Sottointerrogazioni */

/*1. l'elenco dei professori che non sono titolari di corsi attivi*/
SELECT *
FROM professori 
WHERE id NOT IN (
	SELECT professore
	FROM corsi
	WHERE attivato)

/*2. selezionare i corsi il cui esame è stato sostenuto da un numero di studenti
maggiore di quello che ha sostenuto il corso di 'basi di dati'*/
SELECT C.id, C.denominazione, COUNT(DISTINCT E.studente)
FROM corsi C JOIN esami E ON C.id = E.corso
GROUP BY C.id
HAVING COUNT(DISTINCT E.studente) > (
	SELECT COUNT(DISTINCT E.studente)
	FROM corsi C JOIN esami E ON C.id = E.corso
	WHERE C.denominazione = 'Basi Di Dati 1'
	GROUP BY C.id
)

/*3. selezionare i professori che hanno un omonimo tra gli studenti
dell'Università di Milano o sono stati studenti dell'Università di Milano
(cioè usare il cognome e nome del professore per fare questa
interrogazione)*/
SELECT cognome, nome
FROM professori
INTERSECT 
SELECT cognome, nome
FROM studenti

/*4. l'elenco alfabetico, senza duplicati e in ordine decrescente, degli studenti
che hanno presentato il piano di studi per il quinto anno del corso di
laurea di informatica nell'A.A. '2001/2002' e sono in tesi (hanno
assegnato un relatore) con professori che sono titolari di corsi attivi,
presso il corso di laurea di Matematica*/
SELECT *
FROM studenti S JOIN pianidistudio PS ON S.matricola = PS.studente
WHERE PS.annoaccademico = '2001/2002' AND PS.anno = 5
AND S.relatore IN (
	SELECT professore
	FROM corsi C JOIN corsidilaurea CL ON C.corsodilaurea = CL.id
	WHERE CL.denominazione = 'Matematica'
	AND C.attivato)
ORDER BY S.cognome DESC, S.nome DESC





