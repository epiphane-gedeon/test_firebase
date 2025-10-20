import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/student_providers.dart';
import 'add_edit_student_screen.dart';

class EditStudentScreen extends ConsumerWidget {
  final String id;

  const EditStudentScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentForEditingProvider(id));

    return studentAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
      data: (student) {
        if (student == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Étudiant non trouvé'),
            ),
          );
        }

        return AddEditStudentScreen(student: student);
      },
    );
  }
}