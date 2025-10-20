import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/teacher_providers.dart';
import '../../../../core/providers/auth_provider.dart';

class TeacherDetailScreen extends ConsumerWidget {
  final String teacherId;

  const TeacherDetailScreen({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherAsync = ref.watch(teacherProvider(teacherId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'enseignant'),
        actions: [
          if (currentUser?.role.name == 'admin')
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed(
                  'edit_teacher',
                  pathParameters: {'id': teacherId},
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
      body: teacherAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
        data: (teacher) {
          if (teacher == null) {
            return const Center(child: Text('Enseignant non trouvé'));
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
                        // Avatar de l'enseignant
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: _getDepartmentColor(
                            teacher.department,
                          ),
                          child: Text(
                            _getInitials(teacher.fullName),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Nom complet
                        Text(
                          teacher.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Badge du département
                        if (teacher.department != null)
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
                              'Département: ${teacher.department}',
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

                // Informations personnelles
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations Personnelles',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(Icons.email, 'Email', teacher.email),
                        if (teacher.phoneNumber != null)
                          _buildDetailRow(
                            Icons.phone,
                            'Téléphone',
                            teacher.phoneNumber!,
                          ),
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Date d\'embauche',
                          '${teacher.hireDate.day}/${teacher.hireDate.month}/${teacher.hireDate.year}',
                        ),
                        if (teacher.office != null)
                          _buildDetailRow(
                            Icons.room,
                            'Bureau',
                            teacher.office!,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Informations professionnelles
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations Professionnelles',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          Icons.business,
                          'Département',
                          teacher.department ?? 'Non assigné',
                        ),
                        _buildDetailRow(
                          Icons.school,
                          'Classes assignées',
                          '${teacher.classIds.length}',
                        ),
                        _buildDetailRow(
                          Icons.book,
                          'Matières enseignées',
                          '${teacher.subjectIds.length}',
                        ),
                        _buildDetailRow(
                          Icons.access_time,
                          'Ancienneté',
                          '${DateTime.now().difference(teacher.hireDate).inDays ~/ 365} an(s)',
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

  String _getInitials(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }

  Color _getDepartmentColor(String? department) {
    if (department == null) return Colors.grey;

    switch (department.toLowerCase()) {
      case 'mathématiques':
      case 'maths':
        return Colors.blue;
      case 'français':
      case 'littérature':
        return Colors.green;
      case 'sciences':
      case 'physique':
      case 'chimie':
        return Colors.orange;
      case 'histoire':
      case 'géographie':
        return Colors.brown;
      case 'langues':
      case 'anglais':
      case 'espagnol':
        return Colors.purple;
      case 'arts':
      case 'musique':
        return Colors.pink;
      case 'sport':
      case 'eps':
        return Colors.red;
      default:
        return Colors.teal;
    }
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer l\'enseignant'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer cet enseignant ? Cette action est irréversible.',
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
                  final repository = ref.read(teacherRepositoryProvider);
                  await repository.deleteTeacher(teacherId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enseignant supprimé avec succès'),
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
