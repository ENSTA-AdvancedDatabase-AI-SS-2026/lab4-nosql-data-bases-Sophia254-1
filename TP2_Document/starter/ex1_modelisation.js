/**
 * TP2 - Exercice 1 : Modélisation MongoDB
 * Use Case : HealthCare DZ - Dossiers Médicaux
 */

// Se connecter à la base médicale
use("medical_db");


// ─── 1.1 : Créer la collection avec validation ────────────────────────────────

db.createCollection("patients", {

  validator: {

    $jsonSchema: {

      bsonType: "object",

      required: [
        "cin",
        "nom",
        "prenom",
        "dateNaissance",
        "sexe"
      ],

      properties: {

        cin: {
          bsonType: "string",
          description: "CIN obligatoire"
        },

        nom: {
          bsonType: "string"
        },

        prenom: {
          bsonType: "string"
        },

        dateNaissance: {
          bsonType: "date"
        },

        sexe: {
          enum: ["M", "F"]
        },

        groupeSanguin: {
          bsonType: "string"
        },

        antecedents: {
          bsonType: "array"
        },

        allergies: {
          bsonType: "array"
        },

        consultations: {
          bsonType: "array"
        }
      }
    }
  }
});


// ─── 1.2 : Insérer des patients ───────────────────────────────────────────────

const patients = [

  {
    cin: "198001012300",
    nom: "Bensalem",
    prenom: "Ahmed",
    dateNaissance: new Date("1980-01-01"),
    sexe: "M",

    adresse: {
      wilaya: "Alger",
      commune: "Bab Ezzouar"
    },

    groupeSanguin: "O+",

    antecedents: ["Diabète type 2", "HTA"],

    allergies: ["Pénicilline"],

    consultations: [

      {
        id: UUID(),

        date: new Date("2024-01-15"),

        medecin: {
          nom: "Dr. Mansouri",
          specialite: "Cardiologie"
        },

        diagnostic: "Hypertension artérielle",

        tension: {
          systolique: 145,
          diastolique: 92
        },

        medicaments: [
          {
            nom: "Amlodipine",
            dosage: "5mg",
            duree: "30 jours"
          }
        ],

        notes: "Surveillance recommandée"
      },

      {
        id: UUID(),

        date: new Date("2024-07-10"),

        medecin: {
          nom: "Dr. Ferhat",
          specialite: "Médecine interne"
        },

        diagnostic: "Diabète",

        tension: {
          systolique: 138,
          diastolique: 85
        },

        medicaments: [
          {
            nom: "Metformine",
            dosage: "850mg",
            duree: "60 jours"
          }
        ],

        notes: "Contrôle glycémie"
      }
    ]
  },



  {
    cin: "197512101111",
    nom: "Kaci",
    prenom: "Samira",
    dateNaissance: new Date("1975-12-10"),
    sexe: "F",

    adresse: {
      wilaya: "Blida",
      commune: "Boufarik"
    },

    groupeSanguin: "A+",

    antecedents: ["Asthme"],

    allergies: [],

    consultations: [

      {
        id: UUID(),

        date: new Date("2024-02-11"),

        medecin: {
          nom: "Dr. Benali",
          specialite: "Pneumologie"
        },

        diagnostic: "Crise asthmatique",

        tension: {
          systolique: 120,
          diastolique: 80
        },

        medicaments: [
          {
            nom: "Ventoline",
            dosage: "2 bouffées",
            duree: "15 jours"
          }
        ],

        notes: "Repos conseillé"
      }
    ]
  },



  {
    cin: "199003151222",
    nom: "Messaoudi",
    prenom: "Yasmine",
    dateNaissance: new Date("1990-03-15"),
    sexe: "F",

    adresse: {
      wilaya: "Oran",
      commune: "Es Senia"
    },

    groupeSanguin: "B+",

    antecedents: [],

    allergies: ["Aspirine"],

    consultations: [

      {
        id: UUID(),

        date: new Date("2025-01-05"),

        medecin: {
          nom: "Dr. Hamidi",
          specialite: "Médecine générale"
        },

        diagnostic: "Fatigue",

        tension: {
          systolique: 118,
          diastolique: 79
        },

        medicaments: [
          {
            nom: "Vitamine C",
            dosage: "500mg",
            duree: "10 jours"
          }
        ],

        notes: "Repos recommandé"
      }
    ]
  },



  {
    cin: "196811201555",
    nom: "Bouzid",
    prenom: "Karim",
    dateNaissance: new Date("1968-11-20"),
    sexe: "M",

    adresse: {
      wilaya: "Constantine",
      commune: "El Khroub"
    },

    groupeSanguin: "AB+",

    antecedents: ["HTA"],

    allergies: [],

    consultations: [

      {
        id: UUID(),

        date: new Date("2024-03-12"),

        medecin: {
          nom: "Dr. Rahmani",
          specialite: "Cardiologie"
        },

        diagnostic: "Hypertension",

        tension: {
          systolique: 150,
          diastolique: 95
        },

        medicaments: [
          {
            nom: "Lasilix",
            dosage: "40mg",
            duree: "30 jours"
          }
        ],

        notes: "Surveillance tension"
      }
    ]
  },



  {
    cin: "199512302020",
    nom: "Zerrouki",
    prenom: "Imane",
    dateNaissance: new Date("1995-12-30"),
    sexe: "F",

    adresse: {
      wilaya: "Annaba",
      commune: "El Bouni"
    },

    groupeSanguin: "O-",

    antecedents: [],

    allergies: ["Pénicilline"],

    consultations: [

      {
        id: UUID(),

        date: new Date("2024-09-18"),

        medecin: {
          nom: "Dr. Belkacem",
          specialite: "Dermatologie"
        },

        diagnostic: "Allergie cutanée",

        tension: {
          systolique: 110,
          diastolique: 70
        },

        medicaments: [
          {
            nom: "Cétirizine",
            dosage: "10mg",
            duree: "7 jours"
          }
        ],

        notes: "Éviter allergènes"
      }
    ]
  }

];

db.patients.insertMany(patients);


// ─── 1.3 : Collection analyses ────────────────────────────────────────────────

const analyses = [

  {
    patient_id: patients[0]._id,

    date: new Date("2024-01-20"),

    type: "Glycémie",

    resultats: {
      glycémie: "1.45 g/L"
    },

    laboratoire: "Labo Central Alger",

    valide: true
  },



  {
    patient_id: patients[1]._id,

    date: new Date("2024-02-15"),

    type: "ECG",

    resultats: {
      conclusion: "Normal"
    },

    laboratoire: "Clinique Blida",

    valide: true
  },



  {
    patient_id: patients[2]._id,

    date: new Date("2025-01-10"),

    type: "NFS",

    resultats: {
      hemoglobine: "13 g/dL"
    },

    laboratoire: "Labo Oran",

    valide: true
  },



  {
    patient_id: patients[3]._id,

    date: new Date("2024-03-18"),

    type: "Lipidogramme",

    resultats: {
      cholesterol: "2.3 g/L"
    },

    laboratoire: "Clinique Constantine",

    valide: false
  },



  {
    patient_id: patients[4]._id,

    date: new Date("2024-09-20"),

    type: "Créatinine",

    resultats: {
      creatinine: "11 mg/L"
    },

    laboratoire: "Labo Annaba",

    valide: true
  }

];

db.analyses.insertMany(analyses);


print("✅ Modélisation terminée");
print("Patients insérés :", db.patients.countDocuments());
print("Analyses insérées :", db.analyses.countDocuments());