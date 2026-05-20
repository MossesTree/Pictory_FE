import 'package:flutter/foundation.dart';
import 'package:picktory/core/navigation/splash_destination.dart';
import 'package:picktory/services/auth_repository.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  static const Duration maxWait = Duration(milliseconds: 1500);

  final String appName = '픽토리';
  final String tagline = 'Pick Your Story\n당신의 픽으로 결과를 맞혀보세요';
  final String loadingLabel = '로딩 중...';

  bool _isResolving = false;

  bool get isResolving => _isResolving;

  Future<SplashDestination> resolveDestination() async {
    _isResolving = true;
    notifyListeners();

    final startedAt = DateTime.now();
    final session = await _authRepository.getSession();
    final elapsed = DateTime.now().difference(startedAt);
    final remaining = maxWait - elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    _isResolving = false;
    notifyListeners();

    if (session != null &&
        session.isValid &&
        session.isOnboardingCompleted) {
      return SplashDestination.home;
    }
    if (session != null && session.isValid) {
      return SplashDestination.signup;
    }
    return SplashDestination.login;
  }
}
