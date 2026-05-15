-- TP3 - Exercice 4 : Maintenance Cassandra
-- Use Case : SmartGrid DZ

USE smartgrid;


-- ─────────────────────────────────────────────────────────────
-- 4.1 TWCS pour séries temporelles
-- ─────────────────────────────────────────────────────────────

ALTER TABLE mesures_par_capteur

WITH compaction = {

  'class': 'TimeWindowCompactionStrategy',

  'compaction_window_unit': 'DAYS',

  'compaction_window_size': '1'
};



-- ─────────────────────────────────────────────────────────────
-- 4.2 Vérification stratégie
-- ─────────────────────────────────────────────────────────────

DESCRIBE TABLE mesures_par_capteur;



-- ─────────────────────────────────────────────────────────────
-- 4.3 Vérification TTL
-- ─────────────────────────────────────────────────────────────

SELECT TTL(tension_v)

FROM mesures_par_capteur

WHERE capteur_id = 11111111-1111-1111-1111-111111111111

AND date_jour = '2026-05-06'

LIMIT 5;

