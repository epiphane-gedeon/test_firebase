import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher_model.dart';

class TeacherRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'teachers';

  TeacherRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Créer un nouvel enseignant
  Future<void> createTeacher(TeacherModel teacher) async {
    await _firestore
        .collection(_collection)
        .doc(teacher.id)
        .set(teacher.toMap());
  }

  // Récupérer tous les enseignants
  Stream<List<TeacherModel>> getTeachers() {
    return _firestore
        .collection(_collection)
        .orderBy('lastName')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TeacherModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Récupérer un enseignant par ID
  Future<TeacherModel?> getTeacherById(String teacherId) async {
    final doc = await _firestore.collection(_collection).doc(teacherId).get();
    if (doc.exists) {
      return TeacherModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Récupérer un enseignant par userId
  Future<TeacherModel?> getTeacherByUserId(String userId) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return TeacherModel.fromMap(querySnapshot.docs.first.data());
    }
    return null;
  }

  // Mettre à jour un enseignant
  Future<void> updateTeacher(TeacherModel teacher) async {
    await _firestore
        .collection(_collection)
        .doc(teacher.id)
        .update(teacher.toMap());
  }

  // Supprimer un enseignant
  Future<void> deleteTeacher(String teacherId) async {
    await _firestore.collection(_collection).doc(teacherId).delete();
  }

  // Récupérer les enseignants par département
  Stream<List<TeacherModel>> getTeachersByDepartment(String department) {
    return _firestore
        .collection(_collection)
        .where('department', isEqualTo: department)
        .orderBy('lastName')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TeacherModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Ajouter une classe à un enseignant
  Future<void> assignClassToTeacher(String teacherId, String classId) async {
    await _firestore.collection(_collection).doc(teacherId).update({
      'classIds': FieldValue.arrayUnion([classId]),
    });
  }

  // Retirer une classe d'un enseignant
  Future<void> removeClassFromTeacher(String teacherId, String classId) async {
    await _firestore.collection(_collection).doc(teacherId).update({
      'classIds': FieldValue.arrayRemove([classId]),
    });
  }

  // Ajouter une matière à un enseignant
  Future<void> assignSubjectToTeacher(
    String teacherId,
    String subjectId,
  ) async {
    await _firestore.collection(_collection).doc(teacherId).update({
      'subjectIds': FieldValue.arrayUnion([subjectId]),
    });
  }

  // Retirer une matière d'un enseignant
  Future<void> removeSubjectFromTeacher(
    String teacherId,
    String subjectId,
  ) async {
    await _firestore.collection(_collection).doc(teacherId).update({
      'subjectIds': FieldValue.arrayRemove([subjectId]),
    });
  }
}
