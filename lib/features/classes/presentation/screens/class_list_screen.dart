import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/class_providers.dart';
import '../../../../core/providers/auth_provider.dart';
import '../widgets/class_card.dart';

class ClassListScreen extends ConsumerWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(classesStreamProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Classes'),
        actions: [
          if (currentUser?.role.name == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.pushNamed('add_class');
              },
            ),
        ],
      ),
      body: classesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (classes) {
          if (classes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune classe trouvée',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classModel = classes[index];
              return ClassCard(
                classModel: classModel,
                showMenu: currentUser?.role.name == 'admin',
                onTap: () {
                  context.pushNamed(
                    'class_detail',
                    pathParameters: {'id': classModel.id},
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
                context.pushNamed('add_class');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
