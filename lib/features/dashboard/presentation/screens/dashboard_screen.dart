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
        title: const Text('Tableau de Bord'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authRepo = ref.read(authNotifierProvider);
              await authRepo.signOut();
            },
          ),
        ],
      ),
      body: authState.when(
        data: (user) => user == null
            ? const Center(child: Text('Non authentifié'))
            : _buildDashboardByRole(user, context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildDashboardByRole(UserModel user, BuildContext context) {
    switch (user.role) {
      case UserRole.admin:
        return _buildAdminDashboard(user, context);
      case UserRole.teacher:
        return _buildTeacherDashboard(user, context);
      case UserRole.student:
        return _buildStudentDashboard(user, context);
      case UserRole.parent:
        return _buildParentDashboard(user, context);
    }
  }

  // DASHBOARD ADMINISTRATEUR
  Widget _buildAdminDashboard(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(user, 'Administrateur', Colors.red),
          const SizedBox(height: 24),
          
          const Text(
            'Administration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  icon: Icons.people,
                  title: 'Gestion des Étudiants',
                  subtitle: 'Créer, modifier, supprimer',
                  color: Colors.green,
                  onTap: () {
                    context.pushNamed('students');
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.school,
                  title: 'Gestion des Classes',
                  subtitle: 'Organiser les classes',
                  color: Colors.orange,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.person,
                  title: 'Gestion des Enseignants',
                  subtitle: 'Gérer le personnel',
                  color: Colors.blue,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.book,
                  title: 'Gestion des Cours',
                  subtitle: 'Planifier les cours',
                  color: Colors.purple,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.assessment,
                  title: 'Statistiques',
                  subtitle: 'Vue d\'ensemble',
                  color: Colors.teal,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  subtitle: 'Configuration',
                  color: Colors.grey,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DASHBOARD ENSEIGNANT
  Widget _buildTeacherDashboard(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(user, 'Enseignant', Colors.blue),
          const SizedBox(height: 24),
          
          const Text(
            'Mes Espaces',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  icon: Icons.people,
                  title: 'Mes Étudiants',
                  subtitle: 'Voir mes classes',
                  color: Colors.green,
                  onTap: () {
                    context.pushNamed('students');
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.assignment,
                  title: 'Notes',
                  subtitle: 'Saisir les notes',
                  color: Colors.red,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.calendar_today,
                  title: 'Présences',
                  subtitle: 'Marquer les absences',
                  color: Colors.blue,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.book,
                  title: 'Mes Cours',
                  subtitle: 'Emploi du temps',
                  color: Colors.purple,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.chat,
                  title: 'Communication',
                  subtitle: 'Messages aux parents',
                  color: Colors.orange,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.settings,
                  title: 'Mon Profil',
                  subtitle: 'Paramètres personnels',
                  color: Colors.grey,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DASHBOARD ÉTUDIANT
  Widget _buildStudentDashboard(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(user, 'Étudiant', Colors.green),
          const SizedBox(height: 24),
          
          const Text(
            'Mon Espace',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  icon: Icons.schedule,
                  title: 'Emploi du Temps',
                  subtitle: 'Voir mes cours',
                  color: Colors.purple,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.assignment,
                  title: 'Mes Notes',
                  subtitle: 'Consulter mes résultats',
                  color: Colors.blue,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.percent,
                  title: 'Mes Moyennes',
                  subtitle: 'Statistiques personnelles',
                  color: Colors.orange,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.calendar_today,
                  title: 'Mes Absences',
                  subtitle: 'Historique des présences',
                  color: Colors.red,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.event_note,
                  title: 'Devoirs',
                  subtitle: 'Travaux à rendre',
                  color: Colors.teal,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.person,
                  title: 'Mon Profil',
                  subtitle: 'Informations personnelles',
                  color: Colors.grey,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DASHBOARD PARENT
  Widget _buildParentDashboard(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(user, 'Parent', Colors.orange),
          const SizedBox(height: 24),
          
          const Text(
            'Suivi de mon enfant',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  icon: Icons.assignment,
                  title: 'Notes',
                  subtitle: 'Résultats de mon enfant',
                  color: Colors.blue,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.calendar_today,
                  title: 'Présences',
                  subtitle: 'Absences et retards',
                  color: Colors.red,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.chat,
                  title: 'Messagerie',
                  subtitle: 'Échanger avec les profs',
                  color: Colors.green,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.event_note,
                  title: 'Devoirs',
                  subtitle: 'Travaux à faire',
                  color: Colors.teal,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.schedule,
                  title: 'Emploi du Temps',
                  subtitle: 'Cours de mon enfant',
                  color: Colors.purple,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  subtitle: 'Configuration',
                  color: Colors.grey,
                  onTap: () {
                    _showComingSoon(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // COMPOSANTS RÉUTILISABLES
  Widget _buildWelcomeHeader(UserModel user, String roleText, Color roleColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: roleColor.withAlpha(50),
              child: Icon(Icons.person, color: roleColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, ${user.displayName ?? user.email}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      roleText.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: roleColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité en cours de développement...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}