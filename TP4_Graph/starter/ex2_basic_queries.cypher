// TP4 - Exercice 2 : Requêtes de Base


// ─────────────────────────────────────────────
// 2.1 Trouver les amis d'Ahmed
// ─────────────────────────────────────────────

MATCH

(a:Etudiant {prenom:"Ahmed"})
-[:CONNAIT]-
(ami:Etudiant)

RETURN

ami.prenom,
ami.nom,
ami.universite;



// ─────────────────────────────────────────────
// 2.2 Amis d'amis
// ─────────────────────────────────────────────

MATCH

(a:Etudiant {prenom:"Ahmed"})
-[:CONNAIT*2]-
(suggestion:Etudiant)

WHERE

NOT (a)-[:CONNAIT]-(suggestion)

AND a <> suggestion

RETURN DISTINCT

suggestion.prenom,
suggestion.universite;



// ─────────────────────────────────────────────
// 2.3 Même cours que Fatima
// ─────────────────────────────────────────────

MATCH

(f:Etudiant {prenom:"Fatima"})
-[:SUIT]->
(c:Cours)
<-
[:SUIT]-
(e:Etudiant)

WHERE

NOT (f)-[:CONNAIT]-(e)

AND e <> f

RETURN

e.prenom,
c.intitule;



// ─────────────────────────────────────────────
// 2.4 Clubs populaires
// ─────────────────────────────────────────────

MATCH

(e:Etudiant)
-[:MEMBRE_DE]->
(cl:Club)

RETURN

cl.nom,
COUNT(e) AS nb_membres

ORDER BY nb_membres DESC;



// ─────────────────────────────────────────────
// 2.5 Profil complet étudiant
// ─────────────────────────────────────────────

MATCH (e:Etudiant {prenom:"Ahmed"})

OPTIONAL MATCH

(e)-[:CONNAIT]-(ami)

OPTIONAL MATCH

(e)-[:SUIT]->(cours)

OPTIONAL MATCH

(e)-[:MAITRISE]->(comp)

OPTIONAL MATCH

(e)-[:MEMBRE_DE]->(club)

RETURN

e.prenom,

COLLECT(DISTINCT ami.prenom) AS amis,

COLLECT(DISTINCT cours.intitule) AS cours,

COLLECT(DISTINCT comp.nom) AS competences,

COLLECT(DISTINCT club.nom) AS clubs;