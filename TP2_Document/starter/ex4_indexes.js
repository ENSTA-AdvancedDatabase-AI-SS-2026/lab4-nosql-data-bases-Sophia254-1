/**
 * TP2 - Exercice 4 : Index et Optimisation
 * Use Case : HealthCare DZ
 */

use("medical_db");


// ─── 4.1 : Création des index ────────────────────────────────────────────────

print("=== Création des index ===");


// Index composé : wilaya + antécédents
// utilisé pour les recherches fréquentes de patients

db.patients.createIndex({

  "adresse.wilaya": 1,

  antecedents: 1
});


// Index sur les dates des consultations
// utile pour les statistiques mensuelles

db.patients.createIndex({

  "consultations.date": 1
});


// Index textuel pour les recherches sur diagnostics

db.patients.createIndex({

  "consultations.diagnostic": "text"
});


// Index sur patient_id dans analyses
// optimise les jointures $lookup

db.analyses.createIndex({

  patient_id: 1
});

print("✅ Index créés");



// ──────────────────────────────────────────────────────────────────────────────
// 4.2 : Explain executionStats
// ──────────────────────────────────────────────────────────────────────────────

const requeteTest = {

  "adresse.wilaya": "Alger",

  antecedents: "Diabète type 2"
};

print("\n=== Résultats explain() ===");

const explainResult = db.patients.find(requeteTest)
.explain("executionStats");


printjson({

  nReturned:
    explainResult.executionStats.nReturned,

  totalDocsExamined:
    explainResult.executionStats.totalDocsExamined,

  executionTimeMillis:
    explainResult.executionStats.executionTimeMillis
});



// ──────────────────────────────────────────────────────────────────────────────
// 4.3 : Index composé
// ──────────────────────────────────────────────────────────────────────────────

print("\n=== Index composé ===");

db.patients.createIndex({

  "adresse.wilaya": 1,

  antecedents: 1,

  "consultations.date": -1
});

print(" Index composé créé");


// Explication :
// - wilaya en premier → filtre principal
// - antecedents ensuite → filtre médical
// - consultations.date → tri chronologique



// ──────────────────────────────────────────────────────────────────────────────
// 4.4 : Index TTL
// ──────────────────────────────────────────────────────────────────────────────

print("\n=== Index TTL ===");

db.analyses.createIndex(

  { date: 1 },

  {
    expireAfterSeconds: 157680000
  }
);

print(" TTL créé pour suppression automatique après 5 ans");