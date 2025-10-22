import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/student_repository.dart';
import '../entities/student_entity.dart';
import '../../data/models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final FirebaseFirestore _firestore;

  StudentRepositoryImpl({required FirebaseFirestore firestore}) 
      : _firestore = firestore;

  CollectionReference get _studentsRef => _firestore.collection('students');

  @override
  Stream<List<StudentEntity>> watchStudents() {
    return _studentsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Stream<StudentEntity?> watchStudent(String id) {
    return _studentsRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return StudentModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<String, StudentEntity>> getStudent(String id) async {
    try {
      final doc = await _studentsRef.doc(id).get();
      if (!doc.exists) {
        return left('Student not found');
      }
      return right(StudentModel.fromMap(doc.data() as Map<String, dynamic>));
    } catch (e) {
      return left('Error getting student: $e');
    }
  }

  @override
  Future<Either<String, StudentEntity>> createStudent(StudentEntity student) async {
    try {
      await _studentsRef.doc(student.id).set((student as StudentModel).toMap());
      return right(student);
    } catch (e) {
      return left('Error creating student: $e');
    }
  }

  @override
  Future<Either<String, StudentEntity>> updateStudent(StudentEntity student) async {
    try {
      await _studentsRef.doc(student.id).update((student as StudentModel).toMap());
      return right(student);
    } catch (e) {
      return left('Error updating student: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteStudent(String id) async {
    try {
      await _studentsRef.doc(id).delete();
      return right(null);
    } catch (e) {
      return left('Error deleting student: $e');
    }
  }

  @override
  Future<Either<String, List<StudentEntity>>> getStudentsByClass(String classId) async {
    try {
      final query = await _studentsRef.where('classId', isEqualTo: classId).get();
      final students = query.docs
          .map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return right(students);
    } catch (e) {
      return left('Error getting students by class: $e');
    }
  }
}