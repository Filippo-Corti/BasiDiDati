-- CREATE USER paziente WITH LOGIN PASSWORD 'dbpaziente';
-- GRANT CONNECT ON DATABASE ospedali TO paziente;
-- GRANT USAGE ON SCHEMA public TO paziente;
-- GRANT SELECT ON TABLE public.Paziente TO paziente;
-- GRANT SELECT ON TABLE public.Esame TO paziente;
-- GRANT SELECT ON TABLE public.EsameSpecialistico TO paziente;
-- GRANT SELECT ON TABLE public.Prenotazione TO paziente;
-- GRANT SELECT ON TABLE public.Ricovero TO paziente;

/*
Il paziente può:
- Visualizzare Paziente
- Visualizzare Esame
- Visualizzare Esame Specialistico
- Visualizzare Prenotazione
- Visualizzare Ricovero

REVOKE ALL PRIVILEGES ON DATABASE ospedali FROM paziente;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM paziente;
REVOKE ALL PRIVILEGES ON TABLE public.Paziente FROM paziente;
REVOKE ALL PRIVILEGES ON TABLE public.Esame FROM paziente;
REVOKE ALL PRIVILEGES ON TABLE public.EsameSpecialistico FROM paziente;
REVOKE ALL PRIVILEGES ON TABLE public.Prenotazione FROM paziente;
REVOKE ALL PRIVILEGES ON TABLE public.Ricovero FROM paziente;
*/

