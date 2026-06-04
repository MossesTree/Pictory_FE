import 'package:picktory/models/auth_session.dart';
import 'package:picktory/services/auth_repository.dart';

class DummyAuthRepository implements AuthRepository {
  AuthSession? _session = const AuthSession(
    accessToken: 'dummy-bootstrap-token',
    isOnboardingCompleted: true,
    socialProvider: SocialProvider.kakao,
  );

  @override
  Future<AuthSession?> getSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _session;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _session = session;
  }

  @override
  Future<void> clearSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _session = null;
  }

  @override
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (email.isEmpty || password.length < 4) {
      return false;
    }
    _session = const AuthSession(
      accessToken: 'dummy-token',
      isOnboardingCompleted: true,
    );
    return true;
  }

  @override
  Future<bool> signInWithSocial(String provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final social = SocialProvider.values.firstWhere(
      (p) => p.name == provider,
      orElse: () => SocialProvider.kakao,
    );
    _session = AuthSession(
      accessToken: 'dummy-$provider-token',
      isOnboardingCompleted: false,
      socialProvider: social,
    );
    return true;
  }
}
