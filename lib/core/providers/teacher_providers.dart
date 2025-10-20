import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/teachers/data/repositories/teacher_repository.dart';
import '../../features/teachers/data/models/teacher_model.dart';

// Provider pour le repository des enseignants
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository();
});

// Provider pour récupérer tous les enseignants
final teachersStreamProvider = StreamProvider<List<TeacherModel>>((ref) {
  final repository = ref.read(teacherRepositoryProvider);
  return repository.getTeachers();
});

// Provider pour récupérer les enseignants par département
final teachersByDepartmentProvider =
    StreamProvider.family<List<TeacherModel>, String>((ref, department) {
      final repository = ref.read(teacherRepositoryProvider);
      return repository.getTeachersByDepartment(department);
    });

// Provider pour récupérer un enseignant par ID
final teacherProvider = FutureProvider.family<TeacherModel?, String>((
  ref,
  teacherId,
) {
  final repository = ref.read(teacherRepositoryProvider);
  return repository.getTeacherById(teacherId);
});

// Provider pour récupérer un enseignant par userId
final teacherByUserIdProvider = FutureProvider.family<TeacherModel?, String>((
  ref,
  userId,
) {
  final repository = ref.read(teacherRepositoryProvider);
  return repository.getTeacherByUserId(userId);
});
