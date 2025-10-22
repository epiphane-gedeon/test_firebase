import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/student_providers.dart';
import '../providers/student_search_provider.dart';
import '../widgets/student_card.dart';
import '../widgets/student_search_bar.dart';
import '../../domain/entities/student_entity.dart';
import '../widgets/search_stats_widget.dart';

class StudentListScreen extends ConsumerWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsStreamProvider);
    final filteredStudents = ref.watch(filteredStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Étudiants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.pushNamed('add_student');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche et filtres
          const Padding(
            padding: EdgeInsets.all(16),
            child: StudentSearchBar(),
          ),
          
          // Statistiques de recherche
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchStatsWidget(),
          ),
          
          // Liste des étudiants
          Expanded(
            child: studentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorWidget(error, context, ref),
              data: (allStudents) => _buildStudentList(filteredStudents, allStudents, context),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_student');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildErrorWidget(Object error, BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(studentsStreamProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

 Widget _buildStudentList(
  List<StudentEntity> filteredStudents,
  List<StudentEntity> allStudents,
  BuildContext context,
) {
  if (filteredStudents.isEmpty) {
    return _buildEmptyState(allStudents.isEmpty, context);
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: filteredStudents.length,
    itemBuilder: (context, index) {
      final student = filteredStudents[index];
      return StudentCard(
        student: student,
        onTap: () {
          context.pushNamed(
            'student_detail',
            pathParameters: {'id': student.id},
          );
        },
      );
    },
  );
}


  Widget _buildEmptyState(bool noStudents, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            noStudents ? Icons.people_outline : Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            noStudents ? 'Aucun étudiant' : 'Aucun résultat',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            noStudents 
                ? 'Commencez par ajouter votre premier étudiant'
                : 'Aucun étudiant ne correspond à votre recherche',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          if (noStudents) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Utiliser le context du parent widget
                final navigator = Navigator.of(context);
                navigator.pushNamed('add_student');
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un étudiant'),
            ),
          ],
        ],
      ),
    );
  }
}