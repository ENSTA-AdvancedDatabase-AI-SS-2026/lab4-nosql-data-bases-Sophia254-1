/**
 * TP2 - Exercice 2 : Requêtes MongoDB
 * Use Case : HealthCare DZ
 */

use("medical_db");

print("=== 2.1 Patients diabétiques > 50 ans à Alger ===");

const diabetiques = db.patients.find({

  "adresse.wilaya": "Alger",

  antecedents: "Diabète type 2",

  dateNaissance: {
    $lte: new Date("1976-01-01")
  }

}).toArray();

printjson(diabetiques);



// ─────────────────────────────────────────────

print("\n=== 2.2 Allergiques pénicilline avec au moins 3 consultations ===");

const allergiques = db.patients.find({

  allergies: "Pénicilline",

  "consultations.2": {
    $exists: true
  }

}).toArray();

printjson(allergiques);



// ─────────────────────────────────────────────

print("\n=== 2.3 Nom, prénom et dernière consultation ===");

const projectionPatients = db.patients.aggregate([

  {
    $project: {

      nom: 1,

      prenom: 1,

      derniereConsultation: {
        $arrayElemAt: ["$consultations", -1]
      }
    }
  }

]).toArray();

printjson(projectionPatients);



// ─────────────────────────────────────────────

print("\n=== 2.4 Patients sans antécédents avec tension > 140 ===");

const tensionElevee = db.patients.find({

  antecedents: {
    $size: 0
  },

  "consultations.tension.systolique": {
    $gt: 140
  }

}).toArray();

printjson(tensionElevee);



// ─────────────────────────────────────────────

print("\n=== 2.5 Recherche textuelle sur les diagnostics ===");

db.patients.createIndex({
  "consultations.diagnostic": "text"
});

const rechercheDiagnostic = db.patients.find({

  $text: {
    $search: "Hypertension"
  }

}).toArray();

printjson(rechercheDiagnostic);