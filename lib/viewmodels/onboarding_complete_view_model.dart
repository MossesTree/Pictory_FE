import 'package:flutter/foundation.dart';
import 'package:picktory/models/auth_session.dart';
import 'package:picktory/services/auth_repository.dart';
import 'package:picktory/services/signup_repository.dart';

class OnboardingCompleteViewModel extends ChangeNotifier {
  OnboardingCompleteViewModel({
    required SignupRepository signupRepository,
    required AuthRepository authRepository,
  })  : _signupRepository = signupRepository,
        _authRepository = authRepository;

  final SignupRepository _signupRepository;
  final AuthRepository _authRepository;

  /// IA O-6: 닉네임으로 환영 메시지 표시
  String _nickname = '';
  String get title => _nickname.isEmpty
      ? '픽토리에 오신 걸 환영해요!'
      : '$_nickname님, 환영해요!';
  final String subtitle = '가입을 축하드려요. Pick을 모아 랭킹에 도전해보세요';

  int baseCoins = 100;
  int bonusCoins = 0;
  bool isCompleting = false;
  String? errorMessage;

  int get totalCoins => baseCoins + bonusCoins;

  Future<void> load() async {
    final draft = await _signupRepository.loadDraft();
    bonusCoins = draft.inviteBonusApplied ? 100 : 0;
    _nickname = draft.profile?.nickname ?? '';
    notifyListeners();
  }

  Future<bool> completeOnboarding() async {
    isCompleting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final draft = await _signupRepository.loadDraft();
      await _signupRepository.completeSignup(draft);

      final session = await _authRepository.getSession();
      if (session != null) {
        await _authRepository.saveSession(
          AuthSession(
            accessToken: session.accessToken,
            isOnboardingCompleted: true,
            socialProvider: session.socialProvider,
          ),
        );
      } else {
        await _authRepository.saveSession(
          const AuthSession(
            accessToken: 'dummy-new-user',
            isOnboardingCompleted: true,
          ),
        );
      }
      return true;
    } catch (_) {
      errorMessage = '가입 완료 처리에 실패했습니다';
      return false;
    } finally {
      isCompleting = false;
      notifyListeners();
    }
  }
}
