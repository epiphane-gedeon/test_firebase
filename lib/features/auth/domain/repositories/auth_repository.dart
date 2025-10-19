import 'package:fpdart/fpdart.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get user;
  Future<Either<String, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<String, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  });
  Future<Either<String, void>> signOut();
  Future<Either<String, void>> sendPasswordResetEmail(String email);
}