import 'package:picktory/models/user_profile.dart';

class UserPreference {
  const UserPreference({
    this.profile,
    this.selectedProgramIds = const {},
    this.isOnboardingCompleted = false,
  });

  final UserProfile? profile;
  final Set<String> selectedProgramIds;
  final bool isOnboardingCompleted;

  bool get hasProgramSelection => selectedProgramIds.isNotEmpty;

  UserPreference copyWith({
    UserProfile? profile,
    Set<String>? selectedProgramIds,
    bool? isOnboardingCompleted,
  }) {
    return UserPreference(
      profile: profile ?? this.profile,
      selectedProgramIds: selectedProgramIds ?? this.selectedProgramIds,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }
}
