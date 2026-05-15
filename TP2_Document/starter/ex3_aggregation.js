/**
 * TP2 - Exercice 3 : Pipelines d'Agrégation
 * Use Case : Statistiques médicales HealthCare DZ
 */

use("medical_db");

// ─── 3.1 : Distribution des diagnostics par wilaya ────────────────────────────

print("=== 3.1 : Top diagnostics par wilaya ===");

const diagParWilaya = db.patients.aggregate([

  {
    $unwind: "$consultations"
  },

  {
    $group: {

      _id: {

        wilaya: "$adresse.wilaya",

        diagnostic: "$consultations.diagnostic"
      },

      count: {
        $sum: 1
      }
    }
  },

  {
    $sort: {
      count: -1
    }
  },

  {
    $limit: 20
  }

]).toArray();

printjson(diagParWilaya);



// ──────────────────────────────────────────────────────────────────────────────

print("\n=== 3.2 : Top médicaments par spécialité ===");

const medsParSpecialite = db.patients.aggregate([

  {
    $unwind: "$consultations"
  },

  {
    $unwind: "$consultations.medicaments"
  },

  {
    $group: {

      _id: {

        specialite: "$consultations.medecin.specialite",

        medicament: "$consultations.medicaments.nom"
      },

      total: {
        $sum: 1
      }
    }
  },

  {
    $sort: {
      total: -1
    }
  },

  {
    $group: {

      _id: "$_id.specialite",

      topMedicament: {
        $first: "$_id.medicament"
      },

      prescriptions: {
        $first: "$total"
      }
    }
  }

]).toArray();

printjson(medsParSpecialite);



// ──────────────────────────────────────────────────────────────────────────────

print("\n=== 3.3 : Consultations par mois (12 derniers mois) ===");

const evolutionMensuelle = db.patients.aggregate([

  {
    $unwind: "$consultations"
  },

  {
    $match: {

      "consultations.date": {

        $gte: new Date(
          new Date().setFullYear(
            new Date().getFullYear() - 1
          )
        )
      }
    }
  },

  {
    $group: {

      _id: {

        year: {
          $year: "$consultations.date"
        },

        month: {
          $month: "$consultations.date"
        }
      },

      totalConsultations: {
        $sum: 1
      }
    }
  },

  {
    $sort: {

      "_id.year": 1,

      "_id.month": 1
    }
  },

  {
    $project: {

      mois: {

        $concat: [

          { $toString: "$_id.year" },

          "-",

          { $toString: "$_id.month" }
        ]
      },

      totalConsultations: 1,

      _id: 0
    }
  }

]).toArray();

printjson(evolutionMensuelle);



// ──────────────────────────────────────────────────────────────────────────────

print("\n=== 3.4 : Profil patients à risque élevé ===");

const patientsRisque = db.patients.aggregate([

  {
    $match: {

      antecedents: {
        $all: ["Diabète type 2", "HTA"]
      }
    }
  },

  {
    $addFields: {

      age: {

        $subtract: [
          2026,
          { $year: "$dateNaissance" }
        ]
      },

      nbConsultations: {
        $size: "$consultations"
      }
    }
  },

  {
    $match: {

      age: {
        $gt: 60
      }
    }
  },

  {
    $group: {

      _id: null,

      nombrePatients: {
        $sum: 1
      },

      moyenneConsultations: {
        $avg: "$nbConsultations"
      }
    }
  }

]).toArray();

printjson(patientsRisque);



// ──────────────────────────────────────────────────────────────────────────────

print("\n=== 3.5 : Top 5 médecins & taux de ré-consultation ===");

const rapportMedecins = db.patients.aggregate([

  {
    $unwind: "$consultations"
  },

  {
    $group: {

      _id: "$consultations.medecin.nom",

      totalConsultations: {
        $sum: 1
      },

      patientsUniques: {
        $addToSet: "$_id"
      }
    }
  },

  {
    $addFields: {

      nbPatientsUniques: {
        $size: "$patientsUniques"
      }
    }
  },

  {
    $addFields: {

      tauxReconsultation: {

        $multiply: [

          {

            $divide: [

              {

                $subtract: [
                  "$totalConsultations",
                  "$nbPatientsUniques"
                ]
              },

              "$nbPatientsUniques"
            ]
          },

          100
        ]
      }
    }
  },

  {
    $sort: {
      totalConsultations: -1
    }
  },

  {
    $limit: 5
  }

]).toArray();

printjson(rapportMedecins);