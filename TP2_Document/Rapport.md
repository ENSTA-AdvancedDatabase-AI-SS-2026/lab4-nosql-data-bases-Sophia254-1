# TP2 — MongoDB : Plateforme de Gestion de Dossiers Médicaux

## Étudiante
BELOUAHAR Sophia

---

# Introduction

Dans ce TP, nous avons utilisé MongoDB afin de modéliser une plateforme de gestion de dossiers médicaux appelée HealthCare DZ.

L’objectif principal était de remplacer une architecture relationnelle complexe par une base documentaire plus flexible et plus adaptée aux données médicales.

Les dossiers médicaux contiennent :
- informations personnelles
- consultations
- médicaments
- analyses
- antécédents médicaux

MongoDB permet de gérer facilement ce type de données imbriquées grâce aux documents BSON.

---

# Exercice 1 — Modélisation et Insertion

## Choix de modélisation

Deux approches existent dans MongoDB :
- embedding
- referencing

Dans ce TP :
- les consultations ont été embarquées dans le document patient
- les analyses ont été stockées dans une collection séparée

---

## Pourquoi utiliser l’embedding ?

Les consultations sont fréquemment consultées avec le patient.

Avantages :
- une seule lecture MongoDB
- accès rapide au dossier médical
- moins de jointures

Inconvénient :
- document plus volumineux

---

## Pourquoi utiliser le referencing ?

Les analyses médicales peuvent devenir très nombreuses.

Avantages :
- documents plus légers
- meilleure scalabilité
- possibilité d’archivage

---

## Validation du schéma

Un validator `$jsonSchema` a été utilisé pour :
- vérifier les types
- rendre certains champs obligatoires
- éviter les erreurs de données

Champs obligatoires :
- cin
- nom
- prenom
- dateNaissance
- sexe

---

# Exercice 2 — Requêtes MongoDB

Plusieurs requêtes ont été réalisées.

---

## Patients diabétiques de plus de 50 ans

Cette requête combine :
- filtre sur la wilaya
- filtre sur les antécédents
- filtre sur la date de naissance

---

## Patients allergiques à la pénicilline

La requête utilise :
- recherche dans un tableau
- vérification du nombre minimal de consultations

---

## Projection

Une projection a été utilisée afin d’afficher uniquement :
- nom
- prénom
- dernière consultation

Cela réduit les données transférées.

---

## Recherche textuelle

Un index textuel a été créé sur :

```javascript
consultations.diagnostic
```

Cela permet :
- une recherche rapide
- une recherche médicale flexible

---

# Exercice 3 — Agrégation

Les pipelines d’agrégation ont permis de générer des statistiques médicales.

---

## Distribution des diagnostics

Le pipeline utilise :
- `$unwind`
- `$group`
- `$sort`

Objectif :
- connaître les diagnostics les plus fréquents par wilaya

---

## Médicaments les plus prescrits

Les tableaux de médicaments ont été déroulés avec `$unwind`.

Ensuite :
- regroupement par spécialité
- calcul des médicaments les plus utilisés

---

## Évolution mensuelle

Les consultations ont été regroupées :
- par année
- par mois

Cela permet :
- la génération de dashboards
- l’analyse statistique

---

## Patients à risque

Critères :
- diabète
- hypertension
- âge supérieur à 60 ans

Des champs calculés ont été ajoutés :
- âge
- nombre de consultations

---

## Rapport médecins

Le pipeline calcule :
- nombre total de consultations
- patients uniques
- taux de ré-consultation

---

# Exercice 4 — Index et Optimisation

Des index ont été créés afin d’améliorer les performances.

---

## Index composé

```javascript
{
  "adresse.wilaya": 1,
  antecedents: 1
}
```

Utilisé pour :
- les recherches médicales
- les filtres par région

---

## Index textuel

```javascript
{
  "consultations.diagnostic": "text"
}
```

Permet :
- recherche full-text

---

## Index TTL

Un index TTL a été utilisé afin d’archiver automatiquement les analyses anciennes.

Durée :
- 5 ans

---

# Résultats explain()

| Cas | Docs examinés | Temps |
|---|---|---|
| Sans index | élevé | plus lent |
| Avec index | faible | plus rapide |

Les index réduisent fortement les scans de documents.

---

# Exercice 5 — $lookup

Le `$lookup` permet de joindre :
- patients
- analyses

Cela permet :
- d’obtenir le dossier complet
- de produire des statistiques croisées

---

# Requête la Plus Complexe

La requête la plus complexe est le rapport des médecins.

Étapes :
1. dérouler les consultations
2. grouper par médecin
3. compter les consultations
4. calculer les patients uniques
5. calculer le taux de ré-consultation
6. trier les résultats

---

# Conclusion

MongoDB est particulièrement adapté aux données médicales grâce :
- à la flexibilité des documents
- aux pipelines d’agrégation
- aux index
- au modèle documentaire

L’approche NoSQL simplifie fortement la gestion des dossiers médicaux complexes.