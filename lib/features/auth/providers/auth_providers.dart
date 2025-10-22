import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/models/user_model.dart';

// Provider pour FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provider pour FirebaseFirestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Provider pour AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firebaseFirestoreProvider);

  return AuthRepositoryImpl(firebaseAuth: firebaseAuth, firestore: firestore);
});

// Provider pour l'état de l'utilisateur connecté
final userStreamProvider = StreamProvider<UserModel?>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.user;
});

// Provider pour vérifier si l'utilisateur est connecté
final isUserLoggedInProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(userStreamProvider);
  return userAsync.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Provider pour obtenir l'utilisateur connecté
final currentUserProvider = Provider<UserModel?>((ref) {
  final userAsync = ref.watch(userStreamProvider);
  return userAsync.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Provider pour obtenir le rôle de l'utilisateur connecté
final currentUserRoleProvider = Provider<UserRole?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role;
});

// Provider pour vérifier si l'utilisateur est admin
final isAdminProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.admin;
});

// Provider pour vérifier si l'utilisateur est enseignant
final isTeacherProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.teacher;
});

// Provider pour vérifier si l'utilisateur est étudiant
final isStudentProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.student;
});

// Provider pour vérifier si l'utilisateur est parent
final isParentProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.parent;
});

// Provider pour la connexion
final signInProvider = FutureProvider.family<UserModel, SignInParams>((
  ref,
  params,
) async {
  final authRepository = ref.read(authRepositoryProvider);

  final result = await authRepository.signInWithEmailAndPassword(
    email: params.email,
    password: params.password,
  );

  return result.fold((error) => throw Exception(error), (user) => user);
});

// Provider pour l'inscription
final registerProvider = FutureProvider.family<UserModel, RegisterParams>((
  ref,
  params,
) async {
  final authRepository = ref.read(authRepositoryProvider);

  final result = await authRepository.registerWithEmailAndPassword(
    email: params.email,
    password: params.password,
    displayName: params.displayName,
    role: params.role,
  );

  return result.fold((error) => throw Exception(error), (user) => user);
});

// Provider pour la déconnexion
final signOutProvider = FutureProvider<void>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);

  final result = await authRepository.signOut();

  result.fold((error) => throw Exception(error), (_) {
    // Invalider les providers liés à l'authentification
    ref.invalidate(userStreamProvider);
  });
});

// Provider pour la réinitialisation du mot de passe
final resetPasswordProvider = FutureProvider.family<void, String>((
  ref,
  email,
) async {
  final authRepository = ref.read(authRepositoryProvider);

  final result = await authRepository.sendPasswordResetEmail(email);

  result.fold((error) => throw Exception(error), (_) {
    // Succès
  });
});

// Classes pour les paramètres
class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

class RegisterParams {
  final String email;
  final String password;
  final String displayName;
  final UserRole role;

  RegisterParams({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });
}

// Classe pour les actions d'authentification (plus simple)
class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  // Connexion
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final params = SignInParams(email: email, password: password);
    return await _ref.read(signInProvider(params).future);
  }

  // Inscription
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    final params = RegisterParams(
      email: email,
      password: password,
      displayName: displayName,
      role: role,
    );
    return await _ref.read(registerProvider(params).future);
  }

  // Déconnexion
  Future<void> signOut() async {
    await _ref.read(signOutProvider.future);
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    await _ref.read(resetPasswordProvider(email).future);
  }
}

// Provider pour le contrôleur d'authentification
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});
