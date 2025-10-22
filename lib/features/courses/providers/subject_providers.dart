import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/subject_repository.dart';
import '../data/models/subject_model.dart';

// Repository provider
final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepository();
});

// Provider pour toutes les matières
final subjectsProvider = StreamProvider<List<SubjectModel>>((ref) {
  final repository = ref.watch(subjectRepositoryProvider);
  return repository.getAllSubjects();
});

// Provider pour une matière par ID
final subjectByIdProvider = FutureProvider.family<SubjectModel?, String>((
  ref,
  id,
) {
  final repository = ref.watch(subjectRepositoryProvider);
  return repository.getSubjectById(id);
});

// Provider pour les matières par département
final subjectsByDepartmentProvider =
    StreamProvider.family<List<SubjectModel>, String>((ref, department) {
      final repository = ref.watch(subjectRepositoryProvider);
      return repository.getSubjectsByDepartment(department);
    });

// Provider pour créer une matière
final createSubjectProvider = Provider<Future<String> Function(SubjectModel)>((
  ref,
) {
  final repository = ref.watch(subjectRepositoryProvider);
  return (subject) => repository.createSubject(subject);
});

// Provider pour mettre à jour une matière
final updateSubjectProvider = Provider<Future<void> Function(SubjectModel)>((
  ref,
) {
  final repository = ref.watch(subjectRepositoryProvider);
  return (subject) => repository.updateSubject(subject);
});

// Provider pour supprimer une matière
final deleteSubjectProvider = Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(subjectRepositoryProvider);
  return (id) => repository.deleteSubject(id);
});

// Provider pour la recherche
final searchSubjectsProvider =
    FutureProvider.family<List<SubjectModel>, String>((ref, query) {
      final repository = ref.watch(subjectRepositoryProvider);
      return repository.searchSubjects(query);
    });
