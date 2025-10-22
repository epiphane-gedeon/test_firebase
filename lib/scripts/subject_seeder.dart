import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/courses/data/models/subject_model.dart';

class SubjectSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedSubjects() async {
    print('🔧 Début du seed des matières...');

    final List<SubjectModel> subjects = [
      // Mathématiques
      SubjectModel(
        id: '',
        name: 'Algèbre',
        description: 'Étude des structures algébriques, équations et fonctions',
        department: 'Mathématiques',
        creditHours: 4,
      ),
      SubjectModel(
        id: '',
        name: 'Géométrie',
        description: 'Étude des formes, espaces et propriétés géométriques',
        department: 'Mathématiques',
        creditHours: 3,
      ),

      // Français
      SubjectModel(
        id: '',
        name: 'Grammaire',
        description: 'Règles de la langue française, orthographe et syntaxe',
        department: 'Français',
        creditHours: 3,
      ),
      SubjectModel(
        id: '',
        name: 'Littérature',
        description: 'Analyse de textes littéraires et œuvres classiques',
        department: 'Français',
        creditHours: 2,
      ),

      // Sciences
      SubjectModel(
        id: '',
        name: 'Physique',
        description: 'Étude des phénomènes physiques et des lois de la nature',
        department: 'Physique-Chimie',
        creditHours: 3,
      ),
      SubjectModel(
        id: '',
        name: 'Chimie',
        description: 'Étude de la matière et de ses transformations',
        department: 'Physique-Chimie',
        creditHours: 2,
      ),
      SubjectModel(
        id: '',
        name: 'Biologie',
        description: 'Étude du vivant, cellules, organismes et écosystèmes',
        department: 'Sciences de la Vie et de la Terre',
        creditHours: 3,
      ),

      // Histoire-Géographie
      SubjectModel(
        id: '',
        name: 'Histoire',
        description: 'Étude des événements passés et de leurs conséquences',
        department: 'Histoire-Géographie',
        creditHours: 3,
      ),
      SubjectModel(
        id: '',
        name: 'Géographie',
        description: 'Étude des territoires, populations et environnements',
        department: 'Histoire-Géographie',
        creditHours: 2,
      ),

      // Langues
      SubjectModel(
        id: '',
        name: 'Anglais',
        description: 'Apprentissage de la langue anglaise',
        department: 'Anglais',
        creditHours: 3,
      ),
      SubjectModel(
        id: '',
        name: 'Espagnol',
        description: 'Apprentissage de la langue espagnole',
        department: 'Espagnol',
        creditHours: 2,
      ),

      // Arts et Sport
      SubjectModel(
        id: '',
        name: 'Arts Plastiques',
        description: 'Expression artistique et créativité visuelle',
        department: 'Arts Plastiques',
        creditHours: 2,
      ),
      SubjectModel(
        id: '',
        name: 'Éducation Physique',
        description: 'Développement physique et activités sportives',
        department: 'Éducation Physique et Sportive',
        creditHours: 2,
      ),

      // Technologie
      SubjectModel(
        id: '',
        name: 'Informatique',
        description: 'Programmation et utilisation des outils numériques',
        department: 'Technologie',
        creditHours: 2,
      ),
    ];

    for (final subject in subjects) {
      try {
        // Vérifier si la matière existe déjà
        final existingQuery = await _firestore
            .collection('subjects')
            .where('name', isEqualTo: subject.name)
            .where('department', isEqualTo: subject.department)
            .get();

        if (existingQuery.docs.isEmpty) {
          await _firestore.collection('subjects').add(subject.toMap());
          print('✅ Matière créée: ${subject.name} (${subject.department})');
        } else {
          print('ℹ️ Matière déjà existante: ${subject.name}');
        }
      } catch (e) {
        print('❌ Erreur lors de la création de ${subject.name}: $e');
      }
    }

    print('🎉 Seed des matières terminé !');
  }
}
