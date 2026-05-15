# TP5 — Performance & Optimisation NoSQL

## Étudiante
BELOUAHAR Sophia

---

# Introduction

Dans ce TP, nous avons réalisé un benchmark comparatif entre plusieurs bases de données NoSQL :

- Redis
- MongoDB
- Cassandra
- Neo4j

L’objectif était d’évaluer :
- les performances d’écriture
- les performances de lecture
- le comportement sous charge
- les cas d’utilisation adaptés à chaque technologie

Chaque SGBD NoSQL possède une architecture différente et répond à des besoins spécifiques.

---

# Exercice 1 — Benchmark Écriture

100 000 enregistrements ont été simulés dans chaque base afin de mesurer :
- le débit d’écriture
- les latences P50 / P95 / P99
- l’utilisation mémoire et CPU

---

# Redis

Redis a obtenu les meilleures performances globales.

Grâce au stockage mémoire :
- les écritures sont extrêmement rapides
- la latence reste très faible

L’utilisation des pipelines a permis :
- d’envoyer plusieurs commandes simultanément
- de réduire les allers-retours réseau

---

## Observations Redis

| Critère | Résultat |
|---|---|
| Débit écriture | Excellent |
| Latence P50 | Très faible |
| Latence P95 | Très faible |
| Utilisation RAM | Élevée |
| Utilisation CPU | Faible |

---

# MongoDB

MongoDB offre :
- de bonnes performances
- une bonne stabilité
- des insertions bulk efficaces

Les insertions avec `insert_many()` améliorent fortement le débit.

---

## Observations MongoDB

| Critère | Résultat |
|---|---|
| Débit écriture | Très bon |
| Latence P50 | Faible |
| Latence P95 | Moyenne |
| Utilisation RAM | Moyenne |
| Utilisation CPU | Moyenne |

---

# Cassandra

Cassandra est particulièrement adaptée :
- aux très gros volumes
- aux écritures distribuées
- aux données IoT

Les `UNLOGGED BATCH` permettent :
- d’augmenter fortement le débit

---

## Observations Cassandra

| Critère | Résultat |
|---|---|
| Débit écriture | Excellent |
| Latence P50 | Faible |
| Latence P95 | Faible |
| Utilisation disque | Élevée |
| Scalabilité | Très élevée |

---

# Neo4j

Neo4j est moins rapide en écriture car :
- les relations doivent être maintenues
- les traversées de graphe coûtent plus cher

Les écritures deviennent plus lourdes lorsque :
- le nombre de relations augmente

---

## Observations Neo4j

| Critère | Résultat |
|---|---|
| Débit écriture | Moyen |
| Latence P50 | Moyenne |
| Latence P95 | Élevée |
| Utilisation RAM | Importante |

---

# Exercice 2 — Benchmark Lecture

Trois types de lectures ont été testés :

- Point lookup
- Range query
- Complex query

---

# Point Lookup

Le point lookup consiste à récupérer :
- une donnée à partir d’une clé connue

---

## Redis

Redis est la technologie la plus rapide :
- accès direct clé-valeur
- données en mémoire

Temps de réponse quasi instantané.

---

## MongoDB

MongoDB reste très performant grâce :
- aux index
- au moteur BSON

---

## Cassandra

Les performances sont bonnes uniquement si :
- la partition key est bien utilisée

Sinon les lectures deviennent coûteuses.

---

## Neo4j

Neo4j n’est pas optimisé pour :
- les recherches simples

Mais reste très performant pour :
- les relations complexes

---

# Range Query

Les requêtes sur plages temporelles ont montré :

## Cassandra
Très efficace pour :
- séries temporelles
- partitions ordonnées

---

## MongoDB
Très bon support :
- des index
- des filtres temporels

---

# Requêtes Complexes

Neo4j est largement supérieur pour :
- les graphes
- les chemins
- les recommandations

Cypher est plus lisible que SQL pour :
- les traversées complexes

MongoDB reste efficace pour :
- les pipelines d’agrégation

---

# Impact de l’Indexation

Les index améliorent fortement :
- la vitesse de lecture
- les temps de réponse
- la latence

Sans index :
- scans complets
- temps beaucoup plus élevés

Avec index :
- accès directs
- réduction importante du coût des requêtes

---

# Exercice 3 — Test de Charge Concurrente

50 clients simultanés ont été simulés.

Chaque client effectue :
- des lectures
- des écritures

---

# Résultats Sous Charge

## Redis

Très bonnes performances mais :
- limité par la RAM
- architecture principalement mono-thread

---

## MongoDB

Bon équilibre général :
- stable sous charge
- bon comportement mixte lecture/écriture

---

## Cassandra

Très forte scalabilité horizontale.

Excellente résistance :
- aux gros volumes
- aux fortes charges

---

## Neo4j

Très bon pour :
- les traversées complexes

Mais moins adapté :
- aux écritures massives simultanées

---

# Goulots d’Étranglement

| Technologie | Goulot principal |
|---|---|
| Redis | Mémoire RAM |
| MongoDB | Index lourds |
| Cassandra | Mauvaise partition |
| Neo4j | Traversées complexes |

---

# Tableau Comparatif Final

| Critère | Redis | MongoDB | Cassandra | Neo4j |
|---|---|---|---|---|
| Débit écriture | Excellent | Très bon | Excellent | Moyen |
| Débit lecture | Excellent | Très bon | Bon | Bon |
| Requêtes complexes | Limité | Bon | Moyen | Excellent |
| Scalabilité | Bonne | Bonne | Excellente | Moyenne |
| Use case idéal | Cache | Documents | IoT / Logs | Graphe |

---

# Analyse Générale

## Redis

Idéal pour :
- cache
- sessions
- données temps réel

Très faible latence.

---

## MongoDB

Très polyvalent :
- APIs
- applications web
- documents JSON

Bon compromis général.

---

## Cassandra

Excellent pour :
- IoT
- logs
- big data
- séries temporelles

Très forte scalabilité.

---

## Neo4j

Le meilleur choix pour :
- réseaux sociaux
- recommandations
- moteurs relationnels
- chemins complexes

---

# Conclusion

Ce benchmark montre qu’aucune base NoSQL n’est meilleure dans tous les cas.

Le choix dépend principalement :
- du type de données
- des requêtes
- du volume
- des besoins de scalabilité

Résumé :
- Redis domine pour la vitesse
- Cassandra domine pour la scalabilité
- MongoDB est le plus polyvalent
- Neo4j domine pour les graphes et relations complexes