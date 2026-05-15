// TP4 - Exercice 1 : Création du graphe UniConnect DZ
// Effacer la base pour partir propre
MATCH (n) DETACH DELETE n;

// ─── 1.1 : Contraintes d'unicité ─────────────────────────────────────────────
CREATE CONSTRAINT etudiant_id IF NOT EXISTS FOR (e:Etudiant) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT cours_code IF NOT EXISTS FOR (c:Cours) REQUIRE c.code IS UNIQUE;
CREATE CONSTRAINT competence_nom IF NOT EXISTS FOR (c:Competence) REQUIRE c.nom IS UNIQUE;

// ─── 1.2 : Créer les compétences ──────────────────────────────────────────────
UNWIND [
  {nom: "Python", categorie: "Programmation"},
  {nom: "Java", categorie: "Programmation"},
  {nom: "SQL", categorie: "Bases de Données"},
  {nom: "NoSQL", categorie: "Bases de Données"},
  {nom: "Machine Learning", categorie: "IA"},
  {nom: "Deep Learning", categorie: "IA"},
  {nom: "React", categorie: "Web"},
  {nom: "Docker", categorie: "DevOps"},
  {nom: "Linux", categorie: "Systèmes"},
  {nom: "Réseaux", categorie: "Infrastructure"}
] AS comp
MERGE (:Competence {nom: comp.nom, categorie: comp.categorie});

// ─── 1.3 : Créer les cours ────────────────────────────────────────────────────
UNWIND [
  {code: "INFO401", intitule: "Bases de Données Avancées", credits: 6, dept: "Informatique"},
  {code: "INFO402", intitule: "Intelligence Artificielle", credits: 6, dept: "Informatique"},
  {code: "INFO403", intitule: "Développement Web", credits: 4, dept: "Informatique"},
  {code: "INFO404", intitule: "Systèmes Distribués", credits: 5, dept: "Informatique"},
  {code: "INFO405", intitule: "Cloud Computing", credits: 4, dept: "Informatique"}
] AS cours
MERGE (:Cours {code: cours.code, intitule: cours.intitule, 
               credits: cours.credits, departement: cours.dept});

// ─── 1.4 : Créer les étudiants ────────────────────────────────────────────────

UNWIND [

{id:"E001", prenom:"Ahmed", nom:"Bensalem", universite:"USTHB", filiere:"Informatique", annee:3, ville:"Alger"},
{id:"E002", prenom:"Fatima", nom:"Ouali", universite:"USTHB", filiere:"Informatique", annee:3, ville:"Alger"},
{id:"E003", prenom:"Yasmine", nom:"Kaci", universite:"UMBB", filiere:"GL", annee:2, ville:"Boumerdes"},
{id:"E004", prenom:"Karim", nom:"Messaoud", universite:"USTO", filiere:"Telecoms", annee:4, ville:"Oran"},
{id:"E005", prenom:"Imene", nom:"Bouzid", universite:"UBMA", filiere:"Mathématiques", annee:1, ville:"Annaba"},
{id:"E006", prenom:"Sofiane", nom:"Rahmani", universite:"UMC", filiere:"Electronique", annee:5, ville:"Constantine"},
{id:"E007", prenom:"Nadia", nom:"Benali", universite:"USTHB", filiere:"Informatique", annee:2, ville:"Alger"},
{id:"E008", prenom:"Walid", nom:"Hamdi", universite:"UMBB", filiere:"GL", annee:3, ville:"Boumerdes"},
{id:"E009", prenom:"Samira", nom:"Zerrouki", universite:"USTO", filiere:"Telecoms", annee:2, ville:"Oran"},
{id:"E010", prenom:"Amine", nom:"Ferhat", universite:"UBMA", filiere:"Mathématiques", annee:4, ville:"Annaba"},

{id:"E011", prenom:"Rania", nom:"Mokdad", universite:"UMC", filiere:"Electronique", annee:1, ville:"Constantine"},
{id:"E012", prenom:"Bilal", nom:"Khelifi", universite:"USTHB", filiere:"GL", annee:5, ville:"Alger"},
{id:"E013", prenom:"Lina", nom:"Brahimi", universite:"USTHB", filiere:"Informatique", annee:3, ville:"Alger"},
{id:"E014", prenom:"Youcef", nom:"Saidi", universite:"UMBB", filiere:"Electronique", annee:2, ville:"Boumerdes"},
{id:"E015", prenom:"Melissa", nom:"Touati", universite:"USTO", filiere:"Mathématiques", annee:1, ville:"Oran"},
{id:"E016", prenom:"Aymen", nom:"Belkacem", universite:"UBMA", filiere:"Telecoms", annee:5, ville:"Annaba"},
{id:"E017", prenom:"Nour", nom:"Benaissa", universite:"UMC", filiere:"Informatique", annee:4, ville:"Constantine"},
{id:"E018", prenom:"Houssem", nom:"Djabri", universite:"USTHB", filiere:"GL", annee:2, ville:"Alger"},
{id:"E019", prenom:"Ikram", nom:"Cherif", universite:"UMBB", filiere:"Mathématiques", annee:3, ville:"Boumerdes"},
{id:"E020", prenom:"Anis", nom:"Guerfi", universite:"USTO", filiere:"Electronique", annee:1, ville:"Oran"}

] AS data

MERGE (e:Etudiant {id: data.id})

SET e += data;



// ─────────────────────────────────────────────
// Relations CONNAIT
// ─────────────────────────────────────────────

MATCH (a:Etudiant {id:"E001"}),
      (b:Etudiant {id:"E002"})
MERGE (a)-[:CONNAIT {
    depuis:2023,
    contexte:"USTHB"
}]->(b);

MATCH (a:Etudiant {id:"E002"}),
      (b:Etudiant {id:"E003"})
MERGE (a)-[:CONNAIT {
    depuis:2022,
    contexte:"Hackathon"
}]->(b);

MATCH (a:Etudiant {id:"E003"}),
      (b:Etudiant {id:"E004"})
MERGE (a)-[:CONNAIT {
    depuis:2024,
    contexte:"Projet"
}]->(b);

MATCH (a:Etudiant {id:"E004"}),
      (b:Etudiant {id:"E005"})
MERGE (a)-[:CONNAIT {
    depuis:2023,
    contexte:"Club"
}]->(b);

MATCH (a:Etudiant {id:"E005"}),
      (b:Etudiant {id:"E006"})
MERGE (a)-[:CONNAIT {
    depuis:2021,
    contexte:"Stage"
}]->(b);

MATCH (a:Etudiant {id:"E006"}),
      (b:Etudiant {id:"E007"})
MERGE (a)-[:CONNAIT {
    depuis:2022,
    contexte:"Conférence"
}]->(b);

MATCH (a:Etudiant {id:"E007"}),
      (b:Etudiant {id:"E008"})
MERGE (a)-[:CONNAIT {
    depuis:2024,
    contexte:"Université"
}]->(b);

MATCH (a:Etudiant {id:"E008"}),
      (b:Etudiant {id:"E009"})
MERGE (a)-[:CONNAIT {
    depuis:2023,
    contexte:"Projet"
}]->(b);

MATCH (a:Etudiant {id:"E009"}),
      (b:Etudiant {id:"E010"})
MERGE (a)-[:CONNAIT {
    depuis:2022,
    contexte:"Club"
}]->(b);



// ─────────────────────────────────────────────
// Relations SUIT
// ─────────────────────────────────────────────

MATCH (e:Etudiant {id:"E001"}),
      (c:Cours {code:"INFO401"})
MERGE (e)-[:SUIT {
    semestre:"S1",
    note:15
}]->(c);

MATCH (e:Etudiant {id:"E001"}),
      (c:Cours {code:"INFO402"})
MERGE (e)-[:SUIT {
    semestre:"S2",
    note:17
}]->(c);

MATCH (e:Etudiant {id:"E002"}),
      (c:Cours {code:"INFO401"})
MERGE (e)-[:SUIT {
    semestre:"S1",
    note:14
}]->(c);

MATCH (e:Etudiant {id:"E003"}),
      (c:Cours {code:"INFO403"})
MERGE (e)-[:SUIT {
    semestre:"S2",
    note:16
}]->(c);

MATCH (e:Etudiant {id:"E004"}),
      (c:Cours {code:"INFO404"})
MERGE (e)-[:SUIT {
    semestre:"S1",
    note:13
}]->(c);



// ─────────────────────────────────────────────
// Relations MAITRISE
// ─────────────────────────────────────────────

MATCH (e:Etudiant {id:"E001"}),
      (c:Competence {nom:"Python"})
MERGE (e)-[:MAITRISE {
    niveau:"Avancé"
}]->(c);

MATCH (e:Etudiant {id:"E001"}),
      (c:Competence {nom:"SQL"})
MERGE (e)-[:MAITRISE {
    niveau:"Intermédiaire"
}]->(c);

MATCH (e:Etudiant {id:"E002"}),
      (c:Competence {nom:"Machine Learning"})
MERGE (e)-[:MAITRISE {
    niveau:"Avancé"
}]->(c);

MATCH (e:Etudiant {id:"E003"}),
      (c:Competence {nom:"React"})
MERGE (e)-[:MAITRISE {
    niveau:"Intermédiaire"
}]->(c);

MATCH (e:Etudiant {id:"E004"}),
      (c:Competence {nom:"Docker"})
MERGE (e)-[:MAITRISE {
    niveau:"Débutant"
}]->(c);



// ─────────────────────────────────────────────
// Vérification
// ─────────────────────────────────────────────

MATCH (n)

RETURN labels(n)[0] AS type,
count(n) AS total

ORDER BY total DESC;



MATCH ()-[r]->()

RETURN type(r) AS relation,
count(r) AS total

ORDER BY total DESC;