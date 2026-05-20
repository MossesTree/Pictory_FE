import 'package:flutter/foundation.dart';
import 'package:picktory/models/terms_consent.dart';
import 'package:picktory/services/signup_repository.dart';

class TermsViewModel extends ChangeNotifier {
  TermsViewModel({required SignupRepository signupRepository})
      : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  final String title = '서비스 이용에 동의해주세요';
  final String subtitle = '아래 항목을 읽어보고 동의해주세요';

  TermsConsent _consent = const TermsConsent();
  bool isSaving = false;
  String? errorMessage;

  TermsConsent get consent => _consent;
  bool get canProceed => _consent.requiredAgreed && !isSaving;

  void toggleAll(bool value) {
    _consent = TermsConsent(
      isOver14: value,
      agreedToTerms: value,
      agreedToPrivacy: value,
      agreedToMarketing: value,
      agreedToNightPush: value,
    );
    notifyListeners();
  }

  void toggleRequired({
    bool? isOver14,
    bool? agreedToTerms,
    bool? agreedToPrivacy,
  }) {
    _consent = _consent.copyWith(
      isOver14: isOver14,
      agreedToTerms: agreedToTerms,
      agreedToPrivacy: agreedToPrivacy,
    );
    notifyListeners();
  }

  void toggleOptional({
    bool? agreedToMarketing,
    bool? agreedToNightPush,
  }) {
    _consent = _consent.copyWith(
      agreedToMarketing: agreedToMarketing,
      agreedToNightPush: agreedToNightPush,
    );
    notifyListeners();
  }

  Future<bool> saveAndProceed() async {
    if (!canProceed) {
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final draft = await _signupRepository.loadDraft();
      await _signupRepository.saveDraft(
        draft.copyWith(terms: _consent),
      );
      return true;
    } catch (_) {
      errorMessage = '약관 동의 저장에 실패했습니다';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
