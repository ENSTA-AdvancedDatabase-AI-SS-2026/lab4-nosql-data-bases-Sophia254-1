// TP4 - Exercice 4 : Requêtes Avancées


// ─────────────────────────────────────────────
// 4.1 Trouver un tuteur
// ─────────────────────────────────────────────

MATCH

(e:Etudiant)
-[:MAITRISE]->
(c:Competence {nom:"Python"})

MATCH

(e)-[s:SUIT]->
(cours:Cours)

WHERE

cours.code = "INFO401"

AND s.note > 14

AND e.annee >= 4

RETURN

e.prenom,
e.universite,
s.note

ORDER BY s.note DESC;



// ─────────────────────────────────────────────
// 4.2 Réseau alumni Sonatrach
// ─────────────────────────────────────────────

MATCH

(a:Etudiant {prenom:"Ahmed"})
-[:CONNAIT*1..3]-
(alumni:Etudiant)
-[:A_STAGE_CHEZ]->
(ent:Entreprise {nom:"Sonatrach"})

RETURN DISTINCT

alumni.prenom,
alumni.universite,
ent.nom;



// ─────────────────────────────────────────────
// 4.3 Détection de ponts
// ─────────────────────────────────────────────

MATCH

(e:Etudiant)-[:CONNAIT]-(autres)

WITH

e,
COUNT(autres) AS connexions

WHERE connexions >= 3

RETURN

e.prenom,
connexions

ORDER BY connexions DESC;



// ─────────────────────────────────────────────
// 4.4 Analyse temporelle
// ─────────────────────────────────────────────

MATCH ()-[r:CONNAIT]->()

RETURN

r.depuis AS annee,

COUNT(r) AS nouvelles_connexions

ORDER BY annee;



// ─────────────────────────────────────────────
// 4.5 Similarité Jaccard
// ─────────────────────────────────────────────

MATCH

(a:Etudiant {prenom:"Ahmed"})
-[:MAITRISE|SUIT|MEMBRE_DE]->
(x)

MATCH

(other:Etudiant)
-[:MAITRISE|SUIT|MEMBRE_DE]->
(x)

WHERE other <> a

WITH

other,

COUNT(DISTINCT x) AS intersection



MATCH

(a:Etudiant {prenom:"Ahmed"})
-[:MAITRISE|SUIT|MEMBRE_DE]->
(y)

WITH

other,
intersection,
COUNT(DISTINCT y) AS totalAhmed


MATCH

(other)-[:MAITRISE|SUIT|MEMBRE_DE]->
(z)

WITH

other,
intersection,
totalAhmed,
COUNT(DISTINCT z) AS totalOther


WITH

other,

toFloat(intersection) /
(totalAhmed + totalOther - intersection)

AS score_jaccard


RETURN

other.prenom,
ROUND(score_jaccard * 100) / 100 AS similarite

ORDER BY similarite DESC

LIMIT 5;