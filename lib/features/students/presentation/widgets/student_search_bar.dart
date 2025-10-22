import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_search_provider.dart';

class StudentSearchBar extends ConsumerWidget {
  const StudentSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(studentSearchProvider);
    final availableClasses = ref.watch(availableClassesProvider);

    return Column(
      children: [
        // Barre de recherche principale
        _buildSearchField(ref, searchState),
        
        const SizedBox(height: 8),
        
        // Filtres avancés
        _buildAdvancedFilters(ref, searchState, availableClasses),
      ],
    );
  }

  Widget _buildSearchField(WidgetRef ref, StudentSearchState searchState) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher un étudiant...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchState.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  ref.read(studentSearchProvider.notifier).updateSearch('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      onChanged: (value) {
        ref.read(studentSearchProvider.notifier).updateSearch(value);
      },
    );
  }

  Widget _buildAdvancedFilters(
    WidgetRef ref,
    StudentSearchState searchState,
    List<String> availableClasses,
  ) {
    return Row(
      children: [
        // Filtre par classe
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: searchState.selectedClass,
            decoration: InputDecoration(
              hintText: 'Toutes les classes',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Toutes les classes'),
              ),
              ...availableClasses.map((classId) {
                return DropdownMenuItem(
                  value: classId,
                  child: Text(classId),
                );
              }),
            ],
            onChanged: (value) {
              ref.read(studentSearchProvider.notifier).updateClass(value);
            },
          )
        ),
        
        const SizedBox(width: 8),
        
        // Bouton pour effacer tous les filtres
        if (searchState.selectedClass != null || searchState.searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            tooltip: 'Effacer tous les filtres',
            onPressed: () {
              ref.read(studentSearchProvider.notifier).clearAll();
            },
          ),
      ],
    );
  }
}