import 'package:flutter/foundation.dart';
import 'package:picktory/models/gender.dart';
import 'package:picktory/models/user_profile.dart';
import 'package:picktory/services/signup_repository.dart';

class ProfileSetupViewModel extends ChangeNotifier {
  ProfileSetupViewModel({required SignupRepository signupRepository})
      : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  final String title = '프로필 설정';
  final String subtitle = '기본 정보를 입력해 주세요';
  final String nicknameHint = '2~12자, 특수문자 제외';

  UserProfile _profile = const UserProfile();
  bool isNicknameChecked = false;
  bool isSaving = false;
  String? errorMessage;

  /// IA O-4: 친구 초대코드 (선택)
  String inviteCode = '';
  String? inviteErrorMessage;
  bool isInviteApplied = false;

  UserProfile get profile => _profile;
  bool get canProceed => _profile.isComplete && isNicknameChecked && !isSaving;

  void updateNickname(String value) {
    _profile = _profile.copyWith(nickname: value);
    isNicknameChecked = false;
    notifyListeners();
  }

  void selectGender(Gender gender) {
    _profile = _profile.copyWith(gender: gender);
    notifyListeners();
  }

  void updateBirthDate(String value) {
    _profile = _profile.copyWith(birthDate: value);
    notifyListeners();
  }

  void checkNicknameDuplicate() {
    if (_profile.nickname.length < 2) {
      errorMessage = '닉네임을 2자 이상 입력해주세요';
      isNicknameChecked = false;
    } else {
      errorMessage = null;
      isNicknameChecked = true;
    }
    notifyListeners();
  }

  /// IA O-4: 초대코드 입력 — 5자리 영숫자
  void updateInviteCode(String value) {
    inviteCode = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (inviteCode.length > 5) {
      inviteCode = inviteCode.substring(0, 5);
    }
    inviteErrorMessage = null;
    isInviteApplied = false;
    notifyListeners();
  }

  Future<bool> saveAndProceed() async {
    if (!canProceed) {
      return false;
    }

    isSaving = true;
    errorMessage = null;
    inviteErrorMessage = null;
    notifyListeners();

    try {
      // 초대코드가 입력되어 있으면 먼저 검증
      var applyInvite = false;
      String? appliedCode;
      if (inviteCode.isNotEmpty) {
        if (inviteCode.length != 5) {
          inviteErrorMessage = '초대코드는 5자리여야 합니다';
          return false;
        }
        final valid =
            await _signupRepository.validateInviteCode(inviteCode);
        if (!valid) {
          inviteErrorMessage = '유효하지 않은 초대코드입니다';
          return false;
        }
        applyInvite = true;
        appliedCode = inviteCode;
      }

      final draft = await _signupRepository.loadDraft();
      await _signupRepository.saveDraft(
        draft.copyWith(
          profile: _profile,
          inviteCode: appliedCode,
          inviteBonusApplied: applyInvite,
        ),
      );
      isInviteApplied = applyInvite;
      return true;
    } catch (_) {
      errorMessage = '프로필 저장에 실패했습니다';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
