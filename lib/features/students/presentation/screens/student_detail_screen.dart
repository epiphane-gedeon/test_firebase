import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/student_providers.dart';

class StudentDetailScreen extends ConsumerWidget {
  final String id;

  const StudentDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentStreamProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'étudiant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.pushNamed('edit_student', pathParameters: {'id': id});
            },
          ),
        ],
      ),
      body: studentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
        data: (student) {
          if (student == null) {
            return const Center(
              child: Text('Étudiant non trouvé'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec nom
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      student.firstName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    student.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Informations détaillées
                _buildInfoRow('Email parent', student.parentEmail ?? 'Non renseigné'),
                _buildInfoRow('Classe', student.classId),
                _buildInfoRow('Date d\'inscription', 
                  '${student.enrollmentDate.day}/${student.enrollmentDate.month}/${student.enrollmentDate.year}'),
                
                if (student.dateOfBirth != null)
                  _buildInfoRow('Date de naissance', 
                    '${student.dateOfBirth!.day}/${student.dateOfBirth!.month}/${student.dateOfBirth!.year}'),
                
                if (student.phoneNumber != null)
                  _buildInfoRow('Téléphone', student.phoneNumber!),
                
                if (student.address != null)
                  _buildInfoRow('Adresse', student.address!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}