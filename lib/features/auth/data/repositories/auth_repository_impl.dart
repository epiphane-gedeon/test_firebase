import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      
      if (!userDoc.exists) return null;
      
      return UserModel.fromMap(userDoc.data()!);
    });
  }

  @override
  Future<Either<String, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastLoginAt': DateTime.now().millisecondsSinceEpoch,
      });

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return right(UserModel.fromMap(userDoc.data()!));
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? 'Erreur de connexion');
    } catch (e) {
      return left('Erreur inattendue: $e');
    }
  }

  @override
  Future<Either<String, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        role: role,
        createdAt: DateTime.now(),
        isEmailVerified: false,
      );

      // Save user to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());

      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? "Erreur d'inscription");
    } catch (e) {
      return left('Erreur inattendue: $e');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(null);
    } catch (e) {
      return left('Erreur lors de la déconnexion: $e');
    }
  }

  @override
  Future<Either<String, void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? "Erreur d'envoi d'email");
    } catch (e) {
      return left('Erreur inattendue: $e');
    }
  }
}