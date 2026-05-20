import 'package:flutter/foundation.dart';
import 'package:picktory/models/auth_session.dart';
import 'package:picktory/services/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  final String title = '로그인 / 회원가입';
  final String subtitle = '소셜 + 이메일 자체 로그인 통합 화면';

  String email = '';
  String password = '';
  String? errorMessage;
  String? recentProvider;
  bool isSubmitting = false;

  bool get canLogin => email.isNotEmpty && password.isNotEmpty && !isSubmitting;

  void updateEmail(String value) {
    email = value;
    errorMessage = null;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> signInWithEmail() async {
    if (!canLogin) {
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      if (!success) {
        errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다';
        return false;
      }
      recentProvider = 'email';
      return true;
    } catch (_) {
      errorMessage = '로그인에 실패했습니다';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<AuthSession?> signInWithSocial(String provider) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.signInWithSocial(provider);
      if (!success) {
        errorMessage = '$provider 로그인에 실패했습니다';
        return null;
      }
      recentProvider = provider;
      return await _authRepository.getSession();
    } catch (_) {
      errorMessage = '소셜 로그인에 실패했습니다';
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
