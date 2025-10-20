import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final authRepo = ref.read(authNotifierProvider);
              await authRepo.signOut();
            },
          ),
        ],
      ),
      body: authState.when(
        data: (user) => user == null
            ? Center(child: Text('Non authentifié'))
            : _buildDashboardContent(user, context),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildDashboardContent(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de bienvenue
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Icon(Icons.person, color: Colors.blue[700]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour, ${user.displayName ?? user.email}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Chip(
                          label: Text(
                            user.role.name.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: _getRoleColor(user.role),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Statistiques rapides
          Text(
            'Aperçu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Grille des fonctionnalités
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                if (user.role == UserRole.admin ||
                    user.role == UserRole.teacher)
                  _buildFeatureCard(
                    icon: Icons.people,
                    title: 'Étudiants',
                    color: Colors.green,
                    onTap: () {
                      context.push('/dashboard/students');
                    },
                  ),
                if (user.role == UserRole.admin ||
                    user.role == UserRole.teacher)
                  _buildFeatureCard(
                    icon: Icons.school,
                    title: 'Classes',
                    color: Colors.orange,
                    onTap: () {
                      context.push('/dashboard/classes');
                    },
                  ),
                if (user.role == UserRole.admin)
                  _buildFeatureCard(
                    icon: Icons.person_pin,
                    title: 'Enseignants',
                    color: Colors.teal,
                    onTap: () {
                      context.push('/dashboard/teachers');
                    },
                  ),
                _buildFeatureCard(
                  icon: Icons.book,
                  title: 'Cours',
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Naviguer vers la gestion des cours
                  },
                ),
                if (user.role == UserRole.teacher)
                  _buildFeatureCard(
                    icon: Icons.assignment,
                    title: 'Notes',
                    color: Colors.red,
                    onTap: () {
                      // TODO: Naviguer vers la gestion des notes
                    },
                  ),
                if (user.role == UserRole.teacher)
                  _buildFeatureCard(
                    icon: Icons.calendar_today,
                    title: 'Présences',
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Naviguer vers la gestion des présences
                    },
                  ),
                _buildFeatureCard(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  color: Colors.grey,
                  onTap: () {
                    // TODO: Naviguer vers les paramètres
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.teacher:
        return Colors.blue;
      case UserRole.student:
        return Colors.green;
      case UserRole.parent:
        return Colors.orange;
    }
  }
}
