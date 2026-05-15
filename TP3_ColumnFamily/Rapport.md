# TP3 — Cassandra : Données IoT & Séries Temporelles

## Étudiante
BELOUAHAR Sophia

---

# Introduction

Dans ce TP, nous avons utilisé Cassandra afin de gérer des données IoT provenant d’un réseau électrique intelligent nommé SmartGrid DZ.

Le système reçoit des milliers de mesures par minute provenant de capteurs répartis sur plusieurs wilayas algériennes.

L’objectif principal était :
- gérer un très grand volume d’écritures
- stocker des séries temporelles
- optimiser les requêtes temps réel

---

# Exercice 1 — Modélisation Cassandra

Contrairement aux bases relationnelles, Cassandra ne modélise pas les entités mais les requêtes.

Principe utilisé :

> Model your queries, not your entities

---

# Table mesures_par_capteur

Objectif :
- récupérer rapidement les mesures d’un capteur entre deux dates

---

## Partition Key

```sql
(capteur_id, date_jour)
```

Cette clé permet :
- d’éviter les hot partitions
- de répartir les données sur plusieurs nœuds
- de limiter la taille des partitions

---

## Clustering Key

```sql
timestamp DESC
```

Avantages :
- dernières mesures récupérées rapidement
- tri automatique dans Cassandra

---

# Table alertes_par_wilaya

Objectif :
- récupérer les alertes d’une wilaya pour une journée

Partition :
```sql
(wilaya, date_jour)
```

Cela permet :
- des lectures rapides
- une bonne distribution des données

---

# Table agregats_horaires

Cette table contient :
- des données pré-calculées
- les moyennes horaires
- les statistiques du dashboard

Cela évite les agrégations coûteuses en temps réel.

---

# Exercice 2 — Ingestion des Données

50 000 mesures IoT ont été générées :
- 10 000 capteurs
- 5 minutes d’historique

---

## Batch Cassandra

Des `UNLOGGED BATCH` ont été utilisés afin d’améliorer les performances d’écriture.

Bonne pratique :
- batch maximum de 50 lignes

---

## Prepared Statements

Les prepared statements permettent :
- réduire le parsing CQL
- améliorer les performances
- sécuriser les requêtes

---

## Débit d’ingestion

Le débit mesuré était de plusieurs milliers de mesures par seconde.

Cassandra est particulièrement adapté :
- aux écritures massives
- aux séries temporelles
- aux données IoT

---

# Exercice 3 — Requêtes CQL

Plusieurs requêtes ont été réalisées.

---

## Mesures d’un capteur

Requête optimisée grâce :
- à la partition key
- au clustering timestamp

---

## Alertes d’une wilaya

Les alertes sont récupérées rapidement sans scan global.

---

## Dashboard énergétique

Les agrégats horaires permettent :
- affichage temps réel
- statistiques rapides

---

## Détection d’anomalies

Les capteurs avec tension anormale :
- < 200V
- > 240V

peuvent être détectés rapidement.

---

# Pourquoi éviter ALLOW FILTERING ?

`ALLOW FILTERING` oblige Cassandra à scanner énormément de partitions.

Conséquences :
- lenteur
- surcharge cluster
- mauvaise scalabilité

En production, il faut :
- créer une table adaptée à la requête
- modéliser selon les accès fréquents

---

# Exercice 4 — Compaction et Maintenance

## TimeWindowCompactionStrategy (TWCS)

TWCS est adaptée aux séries temporelles car :
- les données anciennes changent rarement
- les données expirent avec TTL
- meilleure gestion des time-series

---

# Comparaison des stratégies

| Stratégie | Usage |
|---|---|
| TWCS | séries temporelles |
| STCS | écritures générales |
| LCS | lectures fréquentes |

---

## TTL

TTL utilisés :
- mesures : 90 jours
- alertes : 1 an
- agrégats : 5 ans

Cela permet :
- archivage automatique
- réduction du stockage

---

# Hot Partitions

Une hot partition apparaît lorsque :
- trop d’écritures vont vers la même partition

Solutions :
- ajouter `date_jour`
- répartir les données
- limiter la taille des partitions

---

# Conclusion

Cassandra est particulièrement adaptée :
- aux très gros volumes d’écriture
- aux séries temporelles
- aux systèmes IoT

Le modèle Cassandra nécessite de penser :
- en termes de requêtes
- de partitions
- de distribution des données

Ce TP a permis de découvrir les principes fondamentaux du modèle Cassandra et des architectures Big Data orientées écriture.