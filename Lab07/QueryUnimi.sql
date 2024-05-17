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

/* Interrogazioni Base */

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












