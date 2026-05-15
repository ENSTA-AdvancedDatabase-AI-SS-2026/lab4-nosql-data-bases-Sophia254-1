/**
 * TP2 - Exercice 5 : $lookup et données référencées
 * Use Case : HealthCare DZ
 */

use("medical_db");

print("=== 5.1 Dossier complet patient + analyses ===");

const dossierComplet = db.patients.aggregate([

  {
    $lookup: {

      from: "analyses",

      localField: "_id",

      foreignField: "patient_id",

      as: "analysesPatient"
    }
  }

]).toArray();

printjson(dossierComplet);



// ─────────────────────────────────────────────

print("\n=== 5.2 Patients avec glycémie > 1.26 g/L ===");

const glycemieElevee = db.analyses.aggregate([

  {
    $match: {

      type: "Glycémie",

      "resultats.glycémie": {
        $gt: "1.26 g/L"
      }
    }
  },

  {
    $lookup: {

      from: "patients",

      localField: "patient_id",

      foreignField: "_id",

      as: "patient"
    }
  }

]).toArray();

printjson(glycemieElevee);



// ─────────────────────────────────────────────

print("\n=== 5.3 Taux d’analyses anormales par wilaya ===");

const statsWilaya = db.analyses.aggregate([

  {
    $lookup: {

      from: "patients",

      localField: "patient_id",

      foreignField: "_id",

      as: "patient"
    }
  },

  {
    $unwind: "$patient"
  },

  {
    $group: {

      _id: "$patient.adresse.wilaya",

      totalAnalyses: {
        $sum: 1
      },

      analysesAnormales: {

        $sum: {

          $cond: [

            { $eq: ["$valide", false] },

            1,

            0
          ]
        }
      }
    }
  },

  {
    $project: {

      wilaya: "$_id",

      totalAnalyses: 1,

      analysesAnormales: 1,

      tauxAnormal: {

        $multiply: [

          {
            $divide: [
              "$analysesAnormales",
              "$totalAnalyses"
            ]
          },

          100
        ]
      }
    }
  }

]).toArray();

printjson(statsWilaya);