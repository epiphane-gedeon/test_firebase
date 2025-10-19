import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions Rapides',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ActionChip(
                  label: const Text('Ajouter Étudiant'),
                  avatar: const Icon(Icons.person_add, size: 18),
                  onPressed: () {
                    context.push('/dashboard/students');
                  },
                ),
                ActionChip(
                  label: const Text('Voir Classes'),
                  avatar: const Icon(Icons.class_, size: 18),
                  onPressed: () {
                    // TODO: Naviguer vers les classes
                  },
                ),
                ActionChip(
                  label: const Text('Cours'),
                  avatar: const Icon(Icons.book, size: 18),
                  onPressed: () {
                    // TODO: Naviguer vers les cours
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}