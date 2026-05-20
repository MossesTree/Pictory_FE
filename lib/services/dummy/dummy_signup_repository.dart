import 'package:picktory/models/signup_draft.dart';
import 'package:picktory/models/user_preference.dart';
import 'package:picktory/services/signup_repository.dart';
import 'package:picktory/services/user_preference_repository.dart';

class DummySignupRepository implements SignupRepository {
  DummySignupRepository({
    required UserPreferenceRepository userPreferenceRepository,
  }) : _userPreferenceRepository = userPreferenceRepository;

  final UserPreferenceRepository _userPreferenceRepository;
  SignupDraft _draft = const SignupDraft();

  @override
  Future<SignupDraft> loadDraft() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _draft;
  }

  @override
  Future<void> saveDraft(SignupDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _draft = draft;
  }

  @override
  Future<void> clearDraft() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _draft = const SignupDraft();
  }

  @override
  Future<bool> validateInviteCode(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return code.toUpperCase() == 'KPICK123';
  }

  @override
  Future<void> completeSignup(SignupDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await _userPreferenceRepository.save(
      UserPreference(
        profile: draft.profile,
        selectedProgramIds: draft.selectedProgramIds,
        isOnboardingCompleted: true,
      ),
    );
    await clearDraft();
  }
}
