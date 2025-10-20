import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/teacher_providers.dart';
import '../../../../core/providers/auth_provider.dart';
import '../widgets/teacher_card.dart';

class TeacherListScreen extends ConsumerWidget {
  const TeacherListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersAsync = ref.watch(teachersStreamProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Enseignants'),
        actions: [
          if (currentUser?.role.name == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.pushNamed('add_teacher');
              },
            ),
        ],
      ),
      body: teachersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (teachers) {
          if (teachers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucun enseignant trouvé',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return TeacherCard(
                teacher: teacher,
                showMenu: currentUser?.role.name == 'admin',
                onTap: () {
                  context.pushNamed(
                    'teacher_detail',
                    pathParameters: {'id': teacher.id},
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: currentUser?.role.name == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                context.pushNamed('add_teacher');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
