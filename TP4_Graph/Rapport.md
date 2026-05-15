# TP4 — Neo4j : Réseau Social Universitaire

## Étudiante
BELOUAHAR Sophia

---

# Introduction

Dans ce TP, nous avons utilisé Neo4j afin de modéliser un réseau social universitaire nommé UniConnect DZ.

Le but était de représenter :
- des étudiants
- des cours
- des clubs
- des compétences
- des relations sociales

Contrairement aux bases relationnelles, Neo4j permet de représenter naturellement les relations entre entités grâce à un graphe de propriétés.

---

# Modélisation du Graphe

Le graphe contient plusieurs types de nœuds :

- Etudiant
- Cours
- Club
- Competence
- Entreprise

Chaque nœud possède des propriétés.

Exemple :

```cypher
(:Etudiant {
  prenom: "Ahmed",
  universite: "USTHB"
})
```

---

# Relations du Graphe

Les principales relations utilisées sont :

| Relation | Description |
|---|---|
| CONNAIT | relation sociale |
| SUIT | étudiant suit un cours |
| MEMBRE_DE | appartenance à un club |
| MAITRISE | compétence maîtrisée |
| A_STAGE_CHEZ | stage en entreprise |
| REQUIERT | compétence requise |

---

# Schéma du Graphe

Le graphe est organisé de la manière suivante :

```text
(Etudiant)-[:CONNAIT]->(Etudiant)

(Etudiant)-[:SUIT]->(Cours)

(Etudiant)-[:MAITRISE]->(Competence)

(Etudiant)-[:MEMBRE_DE]->(Club)

(Etudiant)-[:A_STAGE_CHEZ]->(Entreprise)

(Cours)-[:REQUIERT]->(Competence)
```

Une capture Neo4j Browser a été réalisée pour visualiser le réseau.

---

# Exercice 1 — Création du Graphe

Nous avons :
- créé les contraintes d’unicité
- créé les étudiants
- créé les compétences
- créé les cours
- créé les relations

Le graphe contient :
- plusieurs universités algériennes
- des étudiants connectés entre eux
- des compétences et cours partagés

Le graphe est connexe :
- aucun étudiant n’est isolé

---

# Exercice 2 — Requêtes Cypher

Plusieurs requêtes de base ont été réalisées.

---

## Amis directs

Requête :

```cypher
MATCH (a:Etudiant {prenom:"Ahmed"})-[:CONNAIT]-(ami)
RETURN ami
```

Cette requête récupère :
- les connexions directes d’Ahmed

---

## Amis d’amis

Neo4j permet de parcourir facilement plusieurs niveaux de relations.

Exemple :

```cypher
[:CONNAIT*2]
```

Cela permet :
- recommandations de contacts
- découverte de réseau

---

## Clubs populaires

Les clubs les plus populaires sont obtenus avec :
- COUNT()
- GROUP BY implicite

---

# Exercice 3 — Algorithmes de Graphe

Neo4j permet d’utiliser des algorithmes avancés grâce au plugin GDS.

---

# Plus Court Chemin

L’algorithme shortestPath() permet de trouver :
- le chemin minimal entre deux étudiants

Exemple :
- Ahmed → Fatima → Yasmine

Cela est très compliqué à faire avec SQL.

---

# Centralité

L’algorithme Degree Centrality permet de trouver :
- les étudiants les plus connectés

Ces étudiants jouent souvent le rôle :
- de hubs sociaux
- de connecteurs

---

# Détection de Communautés

L’algorithme Louvain a permis de détecter plusieurs communautés.

Les communautés détectées correspondent souvent :
- à la même université
- à la même filière
- aux mêmes centres d’intérêt

Exemple :
- communauté IA USTHB
- communauté cybersécurité USTO
- communauté GL UMBB

---

# Recommandation de Contacts

Un score de recommandation a été calculé selon :
- amis en commun
- cours en commun
- même filière

Formule :

```text
score =
(nb_amis_communs × 3)
+ (nb_cours_communs × 2)
+ bonus même filière
```

Cela permet :
- suggérer des contacts pertinents

---

# Exercice 4 — Requêtes Avancées

Des requêtes avancées ont été implémentées :

- recherche de tuteurs
- réseau alumni
- détection de ponts
- analyse temporelle
- similarité Jaccard

---

# Similarité Jaccard

Le coefficient de Jaccard permet de mesurer la similarité entre étudiants selon :
- compétences
- cours
- clubs

Plus le score est élevé :
- plus les profils sont proches

---

# Comparaison SQL vs Cypher

## Exemple : Amis d’amis

### SQL

En SQL, cette requête nécessite :
- plusieurs JOIN
- requêtes complexes
- faible lisibilité

Exemple simplifié :

```sql
SELECT ...
FROM etudiants e1
JOIN connait k1 ON ...
JOIN etudiants e2 ON ...
JOIN connait k2 ON ...
```

---

### Cypher

En Cypher :

```cypher
MATCH (a)-[:CONNAIT*2]-(b)
RETURN b
```

La requête est :
- plus courte
- plus lisible
- plus naturelle

---

# Avantages de Neo4j

Neo4j est particulièrement adapté :
- aux réseaux sociaux
- aux recommandations
- aux graphes complexes
- aux parcours de relations

Les traversées de graphe sont beaucoup plus efficaces qu’en SQL.

---

# Conclusion

Ce TP nous a permis de découvrir :
- la modélisation orientée graphe
- le langage Cypher
- les algorithmes de graphes
- les différences entre SQL et Neo4j

Neo4j simplifie fortement les requêtes relationnelles complexes et offre de très bonnes performances pour les réseaux sociaux et les systèmes connectés.