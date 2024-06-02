let quiz = [
  {
    "question": "Le basi di dati sono condivise e per questo",
    "options": [
      "Permettono di ridurre ridondanze e inconsistenze",
      "Danno maggiori garanzie sulla sicurezza dei dati",
      "Rendono inutile la gestione della privatezza e delle autorizzazioni",
      "Favoriscono l’efficienza dei programmi che le usano"
    ],
    "correct": [
      0
    ]
  },
  {
    "question": "Quali affermazioni sono vere?",
    "options": [
      "L’indipendenza dei dati permette di scrivere programmi senza conoscere le strutture fisiche dei dati",
      "L’indipendenza dei dati permette di formulare interrogazioni senza conoscere le strutture fisiche",
      "L’indipendenza dei dati permette di modificare le strutture fisiche dei dati senza dover modificare i programmi che accedono alla base dei dati",
      "L’indipendenza dei dati permette di scrivere programmi conoscendo solo lo schema concettuale della Base di Dati"
    ],
    "correct": [
      0,
      2
    ]
  },
  {
    "question": "Quali affermazioni sono vere?",
    "options": [
      "La distinzione tra DDL e DML corrisponde alla distinzione tra schema e istanza",
      "Le istruzioni DDL permettono di specificare la struttura della base di dati ma non di modificarla",
      "Le istruzioni DML permettono di interrogare una base di dati ma non di modificarla",
      "SQL include istruzioni DDL e DML",
      "Le istruzioni DML permettono di interrogare la base di dati e di modificarla",
      "Non esistono linguaggi che includono sia istruzioni DDL che DML"
    ],
    "correct": [
      0,
      3,
      4
    ]
  },
  {
    "question": "Quale delle seguenti informazioni sono vere?",
    "options": [
      "Il DDL opera su schemi e il DML su istanze",
      "Il DML opera su schemi e il DDL su istanze",
      "Il DDL permette di creare la struttura del DB ma non di modificarla",
      "Il DML permette di interrogare un DB ma non di modificare i dati"
    ],
    "correct": [
      0
    ]
  },
  {
    "question": "Quali affermazioni sono vere?",
    "options": [
      "Il fatto che le basi di dati siano condivise rende necessaria la gestione della privatezza e delle autorizzazioni",
      "Il fatto che le basi di dati siano condivise favorisce l’efficienza dei programmi che le usano",
      "Il fatto che le basi di dati siano condivise permette di ridurre le ridondanze e inconsistenze",
      "Il fatto che le basi di dati siano persistenti favorisce l’efficienza dei programmi che le usano",
      "Il fatto che le basi di dati siano persistenti garantisce l’affidabilità"
    ],
    "correct": [
      0,
      2,
      3
    ]
  },
  {
    "question": "Quali sono le principali differenze tra un DBMS e un File System?",
    "options": [
      "I FS prevedono forme più rudimentali di condivisione: “tutto o niente”",
      "I FS permettono di gestire molti più dati dei DBMS",
      "I DBMS estendono le funzionalità dei file System, fornendo più servizi ed in maniera integrata",
      "I FS permettono di gestire la concorrenza meglio dei DBMS"
    ],
    "correct": [
      0,
      2
    ]
  },
  {
    "question": "Quale linguaggio si usa per definire lo schema e inserire i dati in un Data Base relazionale?",
    "options": [
      "SQL è lo standard sia per definire lo schema che per inserire i dati",
      "Si usa un qualsiasi linguaggio di programmazione per lo schema e SQL per i dati",
      "Si usa un linguaggio specifico del DBMS per lo schema e SQL per i dati",
      "Si usa SQL per lo schema e un linguaggio specifico del DBMS per i dati"
    ],
    "correct": [
      0
    ]
  },
  {
    "question": "Cosa NON si può fare se è garantita l’indipendenza fisica dei dati?",
    "options": [
      "Scrivere programmi senza conoscere lo schema fisico",
      "Modificare lo schema fisico senza modificare i programmi",
      "Formulare interrogazioni senza conoscere lo schema fisico",
      "Scrivere programmi conoscendo solo lo schema concettuale"
    ],
    "correct": [
      3
    ]
  },
  {
    "question": "Chi esegue solitamente il codice nel quale sono immerse le query in un accesso a DBMS via web?",
    "options": [
      "Il browser web",
      "Il modulo principale del server web",
      "Un motore di scripting integrato o richiamato dal web server",
      "Il DBMS"
    ],
    "correct": [
      2
    ]
  },
  {
    "question": "Un web server eroga una web app che accede a un DBMS. Cosa restituisce solitamente il browser?",
    "options": [
      "Oggetti java",
      "Json, html, script",
      "SQL",
      "Binario"
    ],
    "correct": [
      1
    ]
  },
  {
    "question": "Quali tra queste affermazioni è vera?",
    "options": [
      "I DBMS funzionano tutti solo in modalità client – server",
      "JDBC permette di interfacciarsi a un DBMS da ogni linguaggio",
      "Le mobile app hanno possibilità di interrogare un DBMS locale sullo smartphone",
      "Tutti i linguaggi usano le stesse interfacce a DBMS"
    ],
    "correct": [
      2
    ]
  },
  {
    "question": "Qual è l’architettura più comune per l’accesso a un DBMS?",
    "options": [
      "Client – server con query in linguaggio di programmazione",
      "Client – server con query da terminale",
      "Peer – to – peer con query in linguaggio di programmazione",
      "Stand – alone"
    ],
    "correct": [
      0
    ]
  },
  {
    "question": "Il modello relazionale è basato su",
    "options": [
      "Valori",
      "Liste",
      "Puntatori",
      "Grafi"
    ],
    "correct": [
      0
    ]
  },
  {
    "question": "Quale valore si inserisce per un attributo di una tupla se non lo conosciamo?",
    "options": [
      "Nessuno",
      "Il simbolo speciale “NULL”",
      "Un valore non utilizzato del dominio dell’attributo",
      "Il valore “0”"
    ],
    "correct": [
      1
    ]
  },
  {
    "question": "Sono ammessi valori nulli per gli attributi di una chiave?",
    "options": [
      "No, per nessun tipo di chiave",
      "No, se è una chiave primaria",
      "Si, ma solo per la chiave primaria",
      "Si per tutti i tipi di chiave"
    ],
    "correct": [
      1
    ]
  },
  {
    "question": "Quali tra queste è una relazione avendo D1(1, 7, 9) e D2(a, c)",
    "options": [
      "{(7, c), (1, c)}",
      "{(a, 7), (1, c)}",
      "{(7, c), (7, c)}",
      "{(1, b), (9, c)}"
    ],
    "correct": [
      0
    ]
  },
  {
    "question": "Quale affermazione è vera?",
    "options": [
      "La relazione matematica ha struttura posizionale",
      "La relazione matematica ha struttura non posizionale",
      "La relazione può contenere due tuple uguali",
      "L’ordine delle tuple in una relazione è importante (NO perché sono un insieme)"
    ],
    "correct": [
      0
    ]
  },
  {
    "question": "Che cardinalità avrà la partecipazione ad un’associazione usata per identificare un’entità?",
    "options": [
      "[0, 1]",
      "[1, 1]",
      "Qualsiasi",
      "[1, 1] oppure [1, N]"
    ],
    "correct": [
      1
    ]
  },
  {
    "question": "Se non indichiamo nulla quale cardinalità ha un attributo?",
    "options": [
      "[0, 1]",
      "[1, 1]",
      "[0, N]",
      "[1, N]"
    ],
    "correct": [
      1
    ]
  },
  {
    "question": "È possibile che una generalizzazione sia parziale e anche sovrapposta?",
    "options": [
      "Sì",
      "No, se è parziale è sicuramente esclusiva",
      "Sì, tutte le parziali sono necessariamente sovrapposte",
      "No, se è sovrapposta è sicuramente totale"
    ],
    "correct": [0]
  },
  {
    "question": "Una occorrenza di un’associazione ternaria è:",
    "options": [
      "Le associazioni non hanno occorrenze",
      "Una tripla di occorrenze di entità, una per entità coinvolta",
      "Un valore che rappresenta una particolare associazione",
      "Una coppia di occorrenze per ciascuna coppia di entità"
    ],
    "correct": [1]
  },
  {
    "question": "Come si distingue una associazione binaria uno – a – molti",
    "options": [
      "Ha 1 e N come cardinalità massime per le due entità",
      "Ha 1 e N come cardinalità minime per le due entità",
      "Ha 1 come minimo e N come massimo in entrambe le cardinalità",
      "Associa una entità con al più 1 occorrenza con una con tante"
    ],
    "correct": [0]
  },
  {
    "question": "È sempre possibile eliminare una generalizzazione parziale?",
    "options": [
      "Sì, ma non accorpando entità genitore nelle figlie",
      "No, solo se totale",
      "Sì, ma solo se sovrapposta",
      "Sì, accorpando entità genitore nelle figlie"
    ],
    "correct": [0]
  },
  {
    "question": "Quando può essere opportuno partizionare un’entità?",
    "options": [
      "Quando le operazioni accedono a diversi gruppi di attributi",
      "Quando ha molti attributi",
      "Quando è associata a troppe altre entità",
      "Quando ha più di un identificatore"
    ],
    "correct": [0]
  },
  {
    "question": "Cosa è opportuno fare in uno schema ER se scopriamo che una associazione è ridondante?",
    "options": [
      "Va sempre eliminata se di tipo [1, 1]",
      "Va eliminata",
      "Va tenuta se conviene in base alle operazioni frequenti",
      "Sempre meglio tenerla"
    ],
    "correct": [2]
  },
  {
    "question": "Come si traduce un’associazione [1, 1] con una partecipazione opzionale ([0, 1])?",
    "options": [
      "L’associazione viene fusa con entrambe le entità",
      "L’associazione viene fusa con l’entità partecipazione [1, 1]",
      "Si traduce con una sua corrispondente relazione",
      "L’associazione viene fusa con l’entità partecipazione [0, 1]"
    ],
    "correct": [1]
  },
  {
    "question": "Come si traduce da ER a relazione un attributo multi valore?",
    "options": [
      "Si traduce come un normale attributo",
      "Va prima eliminato trasformandolo in attributi separati",
      "Si traduce con una relazione",
      "Va prima eliminato trasformandolo in entità"
    ],
    "correct": [3]
  },
  {
    "question": "Quante tuple può avere il risultato di R1 JOIN_Cond R2? Scegli un'alternativa:",
    "options": [
      "Tra 0 e Max(|R1|, |R2|)",
      "Tra 0 e |R1| x |R2|",
      "Esattamente |R1| x |R2|",
      "Esattamente Max(|R1|, |R2|)"
    ],
    "correct": [1]
  },
  {
    "question": "Quante tuple può avere il risultato di PROJ_C(R) se C è una chiave? Scegli un'alternativa:",
    "options": [
      "Le stesse di R",
      "Un numero minore o uguale a quelle di R",
      "Un numero maggiore o uguale a quelle di R",
      "Dipende dalle specifiche tuple"
    ],
    "correct": [0]
  },
  {
    "question": "È possibile usare solo SEL e PROJ per confrontare valori tra tuple della stessa tabella?",
    "options": [
      "No, ma possiamo farlo usando anche UNION",
      "No, e non si può fare con nessun operatore",
      "No, ma possiamo farlo usando anche JOIN e REN",
      "Sì, componendo opportunamente i due operatori"
    ],
    "correct": [2]
  },
  {
    "question": "Che cosa è un equi-join?",
    "options": [
      "E' sinonimo di 'join esterno completo'",
      "E' sinonimo di 'join naturale'",
      "Un JOIN in cui la condizione utilizza solo operatore '='",
      "Un JOIN in cui la condizione utilizza operatori di confronto"
    ],
    "correct": [2]
  },
  {
    "question": "Abbiamo due relazioni con schemi diversi. Quali operatori insiemistici possiamo applicare?",
    "options": [
      "Solo l'intersezione",
      "Tutti",
      "Nessuno, a meno di non rinominare gli attributi",
      "Solo la differenza"
    ],
    "correct": [2]
  },
  {
    "question": "E' possibile utilizzare quantificatori di variabili nella formula di una espressione del calcolo relazionale su tuple?",
    "options": [
      "Sì, ma solo il quantificatore universale (FORALL)",
      "No",
      "Sì, ma solo il quantificatore esistenziale (EXISTS)",
      "Sì, sia quantificatori esistenziali (EXISTS) che universali (FORALL)"
    ],
    "correct": [3]
  },
  {
    "question": "E' possibile con algebra, calcolo o Datalog fare una interrogazione che calcoli la chiusura transitiva?",
    "options": [
      "Sì, ma solo con calcolo senza restrizioni e con Datalog",
      "Sì, ma solo con Datalog",
      "Sì, con tutti questi linguaggi",
      "No, non hanno abbastanza potere espressivo"
    ],
    "correct": [1]
  },
  {
    "question": "Che cosa restituisce in output l'espressione del calcolo su tuple che inizia così { i.(Nome,Età) | Impiegati(i) ... }",
    "options": [
      "Due valori per Eta' e Nome",
      "Una relazione con lo stesso schema di impiegati",
      "Una relazione con due degli attributi della relazione Impiegati",
      "Due relazioni di cui una è Impiegati e l'altra ha i soli attributi nome ed età"
    ],
    "correct": [2]
  },
  {
    "question": "In CREATE TABLE come indico che la coppia di attributi (A1 A2) è chiave primaria?",
    "options": [
      "Aggiungendo PRIMARY KEY(A1,A2)",
      "Aggiungendo PRIMARY KEY alla dichiarazione di A1 e di A2",
      "Aggiungendo UNIQUE alla dichiarazione di A1 e di A2",
      "Aggiungendo UNIQUE(A1,A2)"
    ],
    "correct": [0]
  },
  {
    "question": "Vengono eliminati i duplicati nell'esecuzione di una SELECT in SQL?",
    "options": [
      "Sì, tranne quando viene specificato SELECT DISTINCT",
      "Sì, sempre",
      "No, mai",
      "Solo se viene specificato SELECT DISTINCT"
    ],
    "correct": [3]
  },
  {
    "question": "Quale di queste query corrisponde all'espressione algebrica PROJ_(A1,A4)(R1 JOIN_(A1=A2) R2)?",
    "options": [
      "SELECT A1, A4 FROM R1 JOIN R2 ON A1=A2",
      "SELECT * FROM R1, R2 WHERE A1=A2 GROUP BY A1,A4",
      "SELECT A1, A4 FROM R1 NATURAL JOIN R2",
      "SELECT * FROM R1 JOIN R2 ON A1=A2 WHERE A1=A4"
    ],
    "correct": [0]
  },
  {
    "question": "Quante colonne ha la tabella risultante da SELECT * FROM R1, R2 WHERE A1=A2 se R1 ne ha 3 e R2 ne ha 4?",
    "options": [
      "12",
      "7",
      "4",
      "2"
    ],
    "correct": [1]
  },
  {
    "question": "Data la tabella R(A1,A2), genera errore la seguente query? SELECT A1, SUM(A2) FROM R WHERE A1<20",
    "options": [
      "Sì, a meno che non si aggiunga GROUP BY A1",
      "No",
      "Sì, a meno che non si aggiunga GROUP BY A2",
      "No, se A1 è una chiave"
    ],
    "correct": [0]
  },
  {
    "question": "Che relazione c'è tra le forme normali BCNF e 3NF?",
    "options": [
      "Per ottenere la 3NF è necessario prima decomporre in BCNF",
      "Sono due forme normali non confrontabili",
      "Ogni relazione in 3NF soddisfa anche BCNF",
      "Ogni relazione in BCNF soddisfa anche 3NF"
    ],
    "correct": [3]
  },
  {
    "question": "Date le dipendenze funzionali AB-->C e Z-->VW definite su r, quando possiamo dire che r è in BCNF?",
    "options": [
      "Quando sia C che VW sono superchiavi di r",
      "Quando sia AB che Z sono superchiavi di r",
      "Quando C, V e W appartengono a chiavi di r",
      "Quando AB oppure Z sono superchiavi di r"
    ],
    "correct": [1]
  },
  {
    "question": "E' corretta la decomposizione di R(ABCD) nelle due relazioni in 3NF R1(AB) e R2(BCD) se A-->C è tra le dipendenze funzionali?",
    "options": [
      "No, perché la decomposizione ha perdita",
      "Sì, visto che le due relazioni sono in 3NF",
      "No, perchè la FD citata non è conservata",
      "Si, perchè quella FD non si applica a R1 e R2"
    ],
    "correct": [2]
  },
  {
    "question": "Per ogni coppia di tuple t1 e t2 con t1[VW]=t2[VW] osserviamo t1[AB]=t2[AB]. Cosa possiamo dire?",
    "options": [
      "In quella relazione valgono le dipendenze funzionali VW --> AB e AB --> VW",
      "In quella relazione vale la dipendenza funzionale AB --> VW",
      "In quella relazione VW è una chiave",
      "In quella relazione vale la dipendenza funzionale VW --> AB"
    ],
    "correct": [3]
  },
  {
    "question": "Quali svantaggi ha un DB non normalizzato?",
    "options": [
      "Le operazioni di JOIN potrebbero creare dati scorretti",
      "Soltanto maggiore inefficienza",
      "Impedisce alcuni tipi di interrogazioni",
      "Presenta ridondanza nei dati e anomalie di aggiornamento"
    ],
    "correct": [3]
  }
]