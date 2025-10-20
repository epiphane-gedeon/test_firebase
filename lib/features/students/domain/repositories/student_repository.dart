import 'package:fpdart/fpdart.dart';
import '../entities/student_entity.dart';

abstract class StudentRepository {
  Stream<List<StudentEntity>> watchStudents();
  Stream<StudentEntity?> watchStudent(String id);
  Future<Either<String, StudentEntity>> getStudent(String id);
  Future<Either<String, StudentEntity>> createStudent(StudentEntity student);
  Future<Either<String, StudentEntity>> updateStudent(StudentEntity student);
  Future<Either<String, void>> deleteStudent(String id);
  Future<Either<String, List<StudentEntity>>> getStudentsByClass(String classId);
}