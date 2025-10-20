import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_search_provider.dart';
import '../../../../core/providers/student_providers.dart';
import '../../domain/entities/student_entity.dart';

class SearchStatsWidget extends ConsumerWidget {
  const SearchStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsStreamProvider);
    final filteredStudents = ref.watch(filteredStudentsProvider);
    final searchState = ref.watch(studentSearchProvider);

    final allStudents = studentsAsync.when(
      data: (students) => students,
      loading: () => <StudentEntity>[],
      error: (error, stack) => <StudentEntity>[],
    );

    final hasFilters = searchState.searchQuery.isNotEmpty || 
                      searchState.selectedClass != null;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${filteredStudents.length} étudiant(s) trouvé(s)',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          if (filteredStudents.length != allStudents.length)
            Text(
              'sur ${allStudents.length}',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}