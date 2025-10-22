import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/classes/data/repositories/class_repository.dart';
import '../../features/classes/data/models/class_model.dart';

// Provider pour le repository des classes
final classRepositoryProvider = Provider<ClassRepository>((ref) {
  return ClassRepository();
});

// Provider pour récupérer toutes les classes
final classesStreamProvider = StreamProvider<List<ClassModel>>((ref) {
  final repository = ref.read(classRepositoryProvider);
  return repository.getClasses();
});

// Provider pour récupérer les classes par niveau
final classesByGradeProvider = StreamProvider.family<List<ClassModel>, String>((
  ref,
  grade,
) {
  final repository = ref.read(classRepositoryProvider);
  return repository.getClassesByGrade(grade);
});

// Provider pour récupérer une classe par ID
final classProvider = FutureProvider.family<ClassModel?, String>((
  ref,
  classId,
) {
  final repository = ref.read(classRepositoryProvider);
  return repository.getClassById(classId);
});
