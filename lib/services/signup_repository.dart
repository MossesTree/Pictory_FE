import 'package:picktory/models/signup_draft.dart';

abstract class SignupRepository {
  Future<SignupDraft> loadDraft();

  Future<void> saveDraft(SignupDraft draft);

  Future<void> clearDraft();

  Future<bool> validateInviteCode(String code);

  Future<void> completeSignup(SignupDraft draft);
}
