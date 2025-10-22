import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/subject_providers.dart';
import '../../data/models/subject_model.dart';

class SubjectDetailScreen extends ConsumerWidget {
  final String subjectId;

  const SubjectDetailScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectAsync = ref.watch(subjectByIdProvider(subjectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la matière'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              context.push('/dashboard/subjects/edit/$subjectId');
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) async {
              if (value == 'delete') {
                final confirmed = await _showDeleteConfirmation(context);
                if (confirmed && context.mounted) {
                  try {
                    await ref.read(deleteSubjectProvider)(subjectId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Matière supprimée avec succès'),
                        ),
                      );
                      context.pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur lors de la suppression: $e'),
                        ),
                      );
                    }
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Supprimer'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: subjectAsync.when(
        data: (subject) {
          if (subject == null) {
            return const Center(child: Text('Matière non trouvée'));
          }
          return _buildSubjectDetail(context, subject);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(subjectByIdProvider(subjectId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectDetail(BuildContext context, SubjectModel subject) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // En-tête
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: _getDepartmentColor(subject.department),
                  child: Text(
                    subject.name.isNotEmpty
                        ? subject.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subject.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(subject.department),
                  backgroundColor: _getDepartmentColor(
                    subject.department,
                  ).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getDepartmentColor(subject.department),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Informations générales
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations générales',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.category,
                  'Département',
                  subject.department,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.access_time,
                  'Heures par semaine',
                  '${subject.creditHours} heure${subject.creditHours > 1 ? 's' : ''}',
                ),
                if (subject.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.description,
                    'Description',
                    subject.description,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Prérequis (si applicable)
        if (subject.prerequisiteIds.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prérequis',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...subject.prerequisiteIds.map(
                    (prereqId) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_right, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            'Matière: $prereqId',
                          ), // TODO: Récupérer le nom réel
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Actions rapides
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/dashboard/subjects/edit/$subjectId');
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifier'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implémenter la vue des cours utilisant cette matière
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fonctionnalité en cours de développement',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.schedule),
                        label: const Text('Voir les cours'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Color _getDepartmentColor(String department) {
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
      case 'biologie':
      case 'physique-chimie':
      case 'sciences de la vie et de la terre':
        return Colors.orange;
      case 'histoire':
      case 'géographie':
      case 'histoire-géographie':
        return Colors.brown;
      case 'anglais':
      case 'espagnol':
      case 'allemand':
      case 'langues':
        return Colors.purple;
      case 'art':
      case 'arts plastiques':
      case 'musique':
        return Colors.pink;
      case 'sport':
      case 'eps':
      case 'éducation physique et sportive':
        return Colors.red;
      case 'technologie':
      case 'informatique':
        return Colors.teal;
      case 'philosophie':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: const Text(
              'Êtes-vous sûr de vouloir supprimer cette matière ? Cette action est irréversible.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Supprimer'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
