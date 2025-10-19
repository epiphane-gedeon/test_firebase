import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/students/domain/repositories/student_repository.dart';
import '../../features/students/domain/repositories/student_repository_impl.dart';
import '../../features/students/domain/entities/student_entity.dart';
import '../providers/auth_provider.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepositoryImpl(firestore: ref.watch(firestoreProvider));
});

final studentsStreamProvider = StreamProvider<List<StudentEntity>>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.watchStudents();
});

final studentStreamProvider = StreamProvider.family<StudentEntity?, String>((ref, id) {
  final repository = ref.watch(studentRepositoryProvider);
  return repository.watchStudent(id);
});

final studentForEditingProvider = FutureProvider.family<StudentEntity?, String>((ref, id) async {
  final repository = ref.watch(studentRepositoryProvider);
  final result = await repository.getStudent(id);
  return result.fold(
    (error) => throw error,
    (student) => student,
  );
});