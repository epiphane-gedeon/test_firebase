import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/class_providers.dart';
import '../../../../core/providers/auth_provider.dart';

class ClassDetailScreen extends ConsumerWidget {
  final String classId;

  const ClassDetailScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classAsync = ref.watch(classProvider(classId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la classe'),
        actions: [
          if (currentUser?.role.name == 'admin')
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed(
                  'edit_class',
                  pathParameters: {'id': classId},
                );
              },
            ),
          if (currentUser?.role.name == 'admin')
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(context, ref);
              },
            ),
        ],
      ),
      body: classAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (classModel) {
          if (classModel == null) {
            return const Center(child: Text('Classe non trouvée'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // En-tête avec avatar et nom
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Avatar de la classe
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: _getGradeColor(classModel.grade),
                          child: Text(
                            classModel.grade.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Nom de la classe
                        Text(
                          classModel.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Badge du niveau
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Niveau: ${classModel.grade}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Informations détaillées
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations Générales',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          Icons.school,
                          'Niveau',
                          classModel.grade,
                        ),
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Année académique',
                          '${classModel.academicYear}-${classModel.academicYear + 1}',
                        ),
                        _buildDetailRow(
                          Icons.people,
                          'Étudiants inscrits',
                          '${classModel.studentIds.length}/${classModel.maxStudents}',
                        ),
                        _buildDetailRow(
                          Icons.event_seat,
                          'Places disponibles',
                          '${classModel.maxStudents - classModel.studentIds.length}',
                        ),
                        _buildDetailRow(
                          Icons.book,
                          'Cours associés',
                          '${classModel.courseIds.length}',
                        ),
                        _buildDetailRow(
                          Icons.analytics,
                          'Taux de remplissage',
                          '${((classModel.studentIds.length / classModel.maxStudents) * 100).toInt()}%',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'cp':
      case 'ce1':
      case 'ce2':
        return Colors.green;
      case 'cm1':
      case 'cm2':
        return Colors.blue;
      case '6ème':
      case '5ème':
      case '4ème':
      case '3ème':
        return Colors.orange;
      case 'seconde':
      case 'première':
      case 'terminale':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la classe'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer cette classe ? Cette action est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final repository = ref.read(classRepositoryProvider);
                  await repository.deleteClass(classId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Classe supprimée avec succès'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur lors de la suppression : $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
