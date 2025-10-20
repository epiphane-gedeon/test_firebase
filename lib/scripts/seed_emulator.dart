import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../features/auth/data/models/user_model.dart';

class EmulatorSeeder {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  EmulatorSeeder({required this.firestore, required this.auth});

  Future<void> seed() async {
    debugPrint('🌱 Début du seed des données de test...');

    try {
      // Créer les utilisateurs de test
      await _createTestUsers();

      debugPrint('✅ Seed terminé avec succès !');
    } catch (e) {
      debugPrint('❌ Erreur lors du seed: $e');
    }
  }

  Future<void> _createTestUsers() async {
    final users = [
      {
        'email': 'admin@school.com',
        'password': 'password123',
        'displayName': 'Admin Principal',
        'role': UserRole.admin,
      },
      {
        'email': 'teacher@school.com',
        'password': 'password123',
        'displayName': 'Professeur Dupont',
        'role': UserRole.teacher,
      },
      {
        'email': 'student@school.com',
        'password': 'password123',
        'displayName': 'Élève Martin',
        'role': UserRole.student,
      },
    ];

    for (final userData in users) {
      try {
        // Créer l'utilisateur Firebase Auth
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: userData['email'] as String,
          password: userData['password'] as String,
        );

        // Créer le document utilisateur dans Firestore
        final user = UserModel(
          uid: userCredential.user!.uid,
          email: userData['email'] as String,
          displayName: userData['displayName'] as String,
          role: userData['role'] as UserRole,
          createdAt: DateTime.now(),
          isEmailVerified: true,
        );

        await firestore.collection('users').doc(user.uid).set(user.toMap());

        debugPrint('✅ Utilisateur créé: ${user.email}');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          debugPrint('ℹ️ Utilisateur déjà existant: ${userData['email']}');
        } else {
          debugPrint('❌ Erreur création utilisateur ${userData['email']}: $e');
        }
      }
    }
  }
}
