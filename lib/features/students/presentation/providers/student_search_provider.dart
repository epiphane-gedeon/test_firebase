import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/student_entity.dart';
import '../../../../core/providers/student_providers.dart';

/// État de recherche et filtrage
class StudentSearchState {
  final String searchQuery;
  final String? selectedClass;
  final bool isActiveOnly;

  const StudentSearchState({
    this.searchQuery = '',
    this.selectedClass,
    this.isActiveOnly = false,
  });

  StudentSearchState copyWith({
    String? searchQuery,
    String? selectedClass,
    bool? isActiveOnly,
  }) {
    return StudentSearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedClass: selectedClass ?? this.selectedClass,
      isActiveOnly: isActiveOnly ?? this.isActiveOnly,
    );
  }
}

/// Notifier responsable de la logique de recherche
class StudentSearchNotifier extends Notifier<StudentSearchState> {
  @override
  StudentSearchState build() {
    return const StudentSearchState();
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateClass(String? classId) {
    state = state.copyWith(selectedClass: classId);
  }

  void clearAll() {
    state = const StudentSearchState();
  }
}

/// Provider pour l'état de recherche
final studentSearchProvider =
    NotifierProvider<StudentSearchNotifier, StudentSearchState>(
  StudentSearchNotifier.new,
);

/// Provider pour la liste filtrée
final filteredStudentsProvider = Provider<List<StudentEntity>>((ref) {
  final searchState = ref.watch(studentSearchProvider);
  final studentsAsync = ref.watch(studentsStreamProvider);

  final allStudents = studentsAsync.when(
    data: (students) => students,
    loading: () => <StudentEntity>[],
    error: (error, stack) => <StudentEntity>[],
  );

  return _filterStudents(allStudents, searchState);
});

List<StudentEntity> _filterStudents(
  List<StudentEntity> students,
  StudentSearchState searchState,
) {
  var filtered = students;

  // Filtrage par recherche texte
  if (searchState.searchQuery.isNotEmpty) {
    final query = searchState.searchQuery.toLowerCase();
    filtered = filtered.where((student) {
      return student.fullName.toLowerCase().contains(query) ||
          student.firstName.toLowerCase().contains(query) ||
          student.lastName.toLowerCase().contains(query) ||
          (student.parentEmail?.toLowerCase().contains(query) ?? false) ||
          student.classId.toLowerCase().contains(query) ||
          (student.phoneNumber?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  // Filtrage par classe
  if (searchState.selectedClass != null) {
    filtered = filtered
        .where((student) => student.classId == searchState.selectedClass)
        .toList();
  }

  return filtered;
}

/// Provider pour les classes uniques (filtre par classe)
final availableClassesProvider = Provider<List<String>>((ref) {
  final studentsAsync = ref.watch(studentsStreamProvider);

  final students = studentsAsync.when(
    data: (students) => students,
    loading: () => <StudentEntity>[],
    error: (error, stack) => <StudentEntity>[],
  );

  final classes = students.map((student) => student.classId).toSet().toList();
  classes.sort();
  return classes;
});
