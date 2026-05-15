# TP1 — Redis : Système de Cache E-commerce

## Étudiante
BELOUAHAR Sophia

---

# Introduction

Dans ce TP, nous avons utilisé Redis afin d'améliorer les performances d'une plateforme e-commerce appelée ShopFast.

Le problème principal était la lenteur du chargement des pages produits à cause des accès fréquents à PostgreSQL.  
L'objectif était donc d'utiliser Redis comme système de cache afin de réduire les temps de réponse et améliorer la gestion des données temporaires comme les sessions et les paniers.

---

# Exercice 1 — Structures de données Redis

## 1. Stockage des produits avec Hash

Les produits ont été stockés avec des Hash Redis.

Exemple de clé :

```bash
product:1
```

Chaque produit contient plusieurs champs :

- name
- price
- category
- stock

Le Hash est adapté car il permet de stocker plusieurs informations liées au même objet dans une seule clé Redis.

Commande utilisée :

```bash
HSET
```

---

## 2. Gestion du panier

Le panier utilisateur est aussi stocké sous forme de Hash.

Exemple :

```bash
cart:user42
```

Le champ représente l'identifiant du produit et la valeur représente la quantité.

Commande utilisée :

```bash
HINCRBY
```

Cela permet d'incrémenter directement la quantité d’un produit déjà présent dans le panier.

---

## 3. Historique de navigation

L’historique des produits consultés est stocké avec une List Redis.

Exemple :

```bash
history:user42
```

Les produits sont ajoutés avec :

```bash
LPUSH
```

Puis la liste est limitée aux 10 derniers produits avec :

```bash
LTRIM
```

---

## 4. Produits par catégorie

Les catégories utilisent des Sets Redis.

Exemple :

```bash
category:phones
```

Avantages des Sets :
- pas de doublons
- opérations rapides
- possibilité d’intersection entre catégories

Commande utilisée :

```bash
SINTER
```

---

# Exercice 2 — Gestion des sessions utilisateur

Les sessions utilisateur ont été implémentées avec Redis String et un TTL de 30 minutes.

Chaque session possède une clé :

```bash
session:{session_id}
```

La valeur stockée correspond au user_id.

Commandes utilisées :
- SET
- GET
- EXPIRE
- DELETE

Le TTL permet la suppression automatique des sessions expirées.

Une sliding expiration a aussi été ajoutée :  
à chaque accès à la session, le TTL est renouvelé automatiquement.

Cela évite qu’un utilisateur actif perde sa session.

---

# Exercice 3 — Pattern Cache-Aside avec TTL

Le pattern Cache-Aside a été implémenté afin de réduire les accès à la base PostgreSQL.

Fonctionnement :

1. chercher le produit dans Redis
2. si le produit existe → CACHE HIT
3. sinon → récupérer depuis PostgreSQL simulée
4. sauvegarder dans Redis avec TTL
5. retourner le produit

---

## Résultats observés

| Situation | Temps moyen |
|---|---|
| Cache MISS | ~2000 ms |
| Cache HIT | < 10 ms |

Le gain de performance est très important.

Le cache permet d’éviter les accès répétés à la base de données.

---

## Invalidation du cache

Après une modification des données, le cache doit être supprimé afin d’éviter les données obsolètes.

Commande utilisée :

```bash
DELETE
```

---

# Exercice 4 — Classement des ventes

Les meilleures ventes ont été gérées avec les Sorted Sets Redis.

Clé utilisée :

```bash
leaderboard:sales
```

Chaque produit possède un score correspondant au nombre total de ventes.

Commande utilisée :

```bash
ZINCRBY
```

---

## Fonctionnalités réalisées

- top produits les plus vendus
- récupération du rang d’un produit
- classement temps réel
- tri automatique par score

---

## Exemple

| Produit | Ventes |
|---|---|
| Produit 3 | 150 |
| Produit 8 | 132 |
| Produit 1 | 119 |

---

# Exercice 5 — Pipeline et Transactions

## 1. Pipeline

Le pipeline permet d’envoyer plusieurs commandes Redis en une seule requête réseau.

Cela améliore les performances lors de l’insertion de plusieurs produits.

Exemple :
- insertion de plusieurs produits en batch
- réduction des allers-retours réseau

Commande utilisée :

```bash
pipeline()
```

---

## 2. Transactions Redis

Une transaction atomique a été utilisée pour le traitement des commandes.

Étapes :
1. vérifier le stock disponible
2. décrémenter le stock
3. supprimer le produit du panier

Les commandes WATCH, MULTI et EXEC permettent d’éviter les conflits lors des accès concurrents.

---

# Comparaison de performance

| Opération | Sans Redis | Avec Redis |
|---|---|---|
| Chargement produit | ~2 sec | < 10 ms |
| Session utilisateur | accès DB | accès mémoire |
| Classement ventes | recalcul SQL | temps réel |

Redis améliore fortement la rapidité de l’application.

---

# Réponses aux questions

## 1. Que se passe-t-il si Redis redémarre ?

Redis stocke principalement les données en mémoire.

Si aucune persistance n’est activée :
- les données du cache seront perdues
- les sessions seront supprimées
- les classements seront réinitialisés

Pour éviter cela, Redis propose :
- RDB snapshots
- AOF persistence

---

## 2. Comment gérer la cohérence cache/DB en cas d’accès concurrent ?

Plusieurs solutions existent :
- invalider le cache après mise à jour
- utiliser des transactions Redis
- utiliser des verrous distribués
- définir des TTL adaptés

Cela permet d’éviter les incohérences entre le cache et la base de données.

---

## 3. Quand un TTL trop court devient-il problématique ?

Un TTL trop court provoque :
- beaucoup de cache miss
- surcharge de PostgreSQL
- augmentation du temps de réponse
- diminution des performances

Le choix du TTL dépend donc du type de données et de la fréquence des mises à jour.

---

# Conclusion

Ce TP a permis de découvrir les principales structures Redis et leur utilisation dans une application e-commerce.

Redis permet :
- d’améliorer fortement les performances
- de réduire la charge de PostgreSQL
- de gérer efficacement les sessions
- de construire des classements en temps réel

L’utilisation du cache est donc très importante dans les applications à fort trafic.