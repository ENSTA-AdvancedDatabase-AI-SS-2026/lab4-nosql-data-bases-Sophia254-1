-- TP3 - Exercice 3 : Requêtes Cassandra
-- Use Case : SmartGrid DZ

USE smartgrid;


-- ─────────────────────────────────────────────────────────────
-- 3.1 Mesures d'un capteur sur les dernières 6 heures
-- ─────────────────────────────────────────────────────────────

SELECT *

FROM mesures_par_capteur

WHERE capteur_id = 11111111-1111-1111-1111-111111111111

AND date_jour = '2026-05-06'

AND timestamp >= '2026-05-06 12:00:00';



-- ─────────────────────────────────────────────────────────────
-- 3.2 Dernière mesure d'un capteur
-- ─────────────────────────────────────────────────────────────

SELECT *

FROM mesures_par_capteur

WHERE capteur_id = 11111111-1111-1111-1111-111111111111

AND date_jour = '2026-05-06'

LIMIT 1;



-- ─────────────────────────────────────────────────────────────
-- 3.3 Alertes dans la wilaya Alger
-- ─────────────────────────────────────────────────────────────

SELECT *

FROM alertes_par_wilaya

WHERE wilaya = 'Alger'

AND date_jour = '2026-05-06';



-- ─────────────────────────────────────────────────────────────
-- Compter les alertes
-- ─────────────────────────────────────────────────────────────

SELECT COUNT(*)

FROM alertes_par_wilaya

WHERE wilaya = 'Alger'

AND date_jour = '2026-05-06';



-- ─────────────────────────────────────────────────────────────
-- 3.4 Consommation moyenne horaire
-- ─────────────────────────────────────────────────────────────

SELECT *

FROM agregats_horaires

WHERE wilaya = 'Alger';



-- ─────────────────────────────────────────────────────────────
-- 3.5 Détection anomalie tension
-- ─────────────────────────────────────────────────────────────

SELECT *

FROM mesures_par_capteur

WHERE capteur_id = 11111111-1111-1111-1111-111111111111

AND date_jour = '2026-05-06'

AND timestamp >= '2026-05-06 18:00:00';



-- ─────────────────────────────────────────────────────────────
-- 3.6 Top capteurs actifs
-- ─────────────────────────────────────────────────────────────

SELECT capteur_id,

COUNT(*)

FROM mesures_par_capteur

WHERE date_jour = '2026-05-06'

GROUP BY capteur_id;



-- ─────────────────────────────────────────────────────────────
-- 3.7 Exemple ALLOW FILTERING
-- ─────────────────────────────────────────────────────────────

-- Requête mauvaise pratique

SELECT *

FROM mesures_par_capteur

WHERE tension_v > 240

ALLOW FILTERING;
