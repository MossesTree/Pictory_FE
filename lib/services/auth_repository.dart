import 'package:picktory/models/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> getSession();

  Future<void> saveSession(AuthSession session);

  Future<void> clearSession();

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  });

  Future<bool> signInWithSocial(String provider);
}
