import 'package:flutter/foundation.dart';
import 'package:picktory/models/gender.dart';
import 'package:picktory/models/user_profile.dart';
import 'package:picktory/services/signup_repository.dart';

class ProfileSetupViewModel extends ChangeNotifier {
  ProfileSetupViewModel({required SignupRepository signupRepository})
      : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  final String title = '프로필 설정';
  final String subtitle = '기본 정보를 입력해주세요';
  final String nicknameHint = '2~12자, 특수문자 제외';

  UserProfile _profile = const UserProfile();
  bool isNicknameChecked = false;
  bool isSaving = false;
  String? errorMessage;

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
        draft.copyWith(profile: _profile),
      );
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
