import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_model.dart';

class ClassRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'classes';

  ClassRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Créer une nouvelle classe
  Future<void> createClass(ClassModel classModel) async {
    await _firestore
        .collection(_collection)
        .doc(classModel.id)
        .set(classModel.toMap());
  }

  // Récupérer toutes les classes
  Stream<List<ClassModel>> getClasses() {
    return _firestore
        .collection(_collection)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClassModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Récupérer une classe par ID
  Future<ClassModel?> getClassById(String classId) async {
    final doc = await _firestore.collection(_collection).doc(classId).get();
    if (doc.exists) {
      return ClassModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Mettre à jour une classe
  Future<void> updateClass(ClassModel classModel) async {
    await _firestore
        .collection(_collection)
        .doc(classModel.id)
        .update(classModel.toMap());
  }

  // Supprimer une classe
  Future<void> deleteClass(String classId) async {
    await _firestore.collection(_collection).doc(classId).delete();
  }

  // Récupérer les classes par niveau
  Stream<List<ClassModel>> getClassesByGrade(String grade) {
    return _firestore
        .collection(_collection)
        .where('grade', isEqualTo: grade)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClassModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Ajouter un étudiant à une classe
  Future<void> addStudentToClass(String classId, String studentId) async {
    await _firestore.collection(_collection).doc(classId).update({
      'studentIds': FieldValue.arrayUnion([studentId]),
    });
  }

  // Retirer un étudiant d'une classe
  Future<void> removeStudentFromClass(String classId, String studentId) async {
    await _firestore.collection(_collection).doc(classId).update({
      'studentIds': FieldValue.arrayRemove([studentId]),
    });
  }
}
