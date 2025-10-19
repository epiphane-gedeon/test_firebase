import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/models/user_model.dart';

// Providers for dependencies
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firestoreProvider),
  );
});

// Auth State Provider
final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.read(authRepositoryProvider).user;
});

// Auth Notifier Provider
final authNotifierProvider = Provider<AuthRepository>((ref) {
  return ref.read(authRepositoryProvider);
});

// Current user as a separate provider (convenience)
final currentUserProvider = Provider<UserModel?>((ref) {
  final auth = ref.watch(authStateProvider);
  return auth.asData?.value;
});
