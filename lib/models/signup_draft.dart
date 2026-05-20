import 'package:picktory/models/terms_consent.dart';
import 'package:picktory/models/user_profile.dart';

class SignupDraft {
  const SignupDraft({
    this.terms,
    this.profile,
    this.selectedProgramIds = const {},
    this.inviteCode,
    this.inviteBonusApplied = false,
  });

  final TermsConsent? terms;
  final UserProfile? profile;
  final Set<String> selectedProgramIds;
  final String? inviteCode;
  final bool inviteBonusApplied;

  SignupDraft copyWith({
    TermsConsent? terms,
    UserProfile? profile,
    Set<String>? selectedProgramIds,
    String? inviteCode,
    bool? inviteBonusApplied,
  }) {
    return SignupDraft(
      terms: terms ?? this.terms,
      profile: profile ?? this.profile,
      selectedProgramIds: selectedProgramIds ?? this.selectedProgramIds,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteBonusApplied: inviteBonusApplied ?? this.inviteBonusApplied,
    );
  }
}
