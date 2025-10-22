import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';

class SubjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'subjects';

  // Récupérer toutes les matières
  Stream<List<SubjectModel>> getAllSubjects() {
    return _firestore
        .collection(_collection)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SubjectModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Récupérer une matière par ID
  Future<SubjectModel?> getSubjectById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return SubjectModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de la matière: $e');
      return null;
    }
  }

  // Créer une nouvelle matière
  Future<String> createSubject(SubjectModel subject) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(subject.toMap());
      return docRef.id;
    } catch (e) {
      print('Erreur lors de la création de la matière: $e');
      rethrow;
    }
  }

  // Mettre à jour une matière
  Future<void> updateSubject(SubjectModel subject) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(subject.id)
          .update(subject.toMap());
    } catch (e) {
      print('Erreur lors de la mise à jour de la matière: $e');
      rethrow;
    }
  }

  // Supprimer une matière
  Future<void> deleteSubject(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression de la matière: $e');
      rethrow;
    }
  }

  // Rechercher des matières par nom
  Future<List<SubjectModel>> searchSubjects(String query) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => SubjectModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      return [];
    }
  }

  // Récupérer les matières par département
  Stream<List<SubjectModel>> getSubjectsByDepartment(String department) {
    return _firestore
        .collection(_collection)
        .where('department', isEqualTo: department)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SubjectModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }
}
