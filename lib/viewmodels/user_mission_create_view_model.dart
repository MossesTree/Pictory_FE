import 'package:flutter/foundation.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/services/community_repository.dart';

class UserMissionCreateViewModel extends ChangeNotifier {
  UserMissionCreateViewModel({
    required CommunityRepository communityRepository,
  }) : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;

  UserMissionType type = UserMissionType.mission;
  String programLabel = '환승연애4 · 5화';
  String title = '';
  String description = '';
  String choiceA = '';
  String choiceB = '';
  String deadlineLabel = '24시간';
  int pointCost = 50;
  bool isSubmitting = false;
  String? errorMessage;

  bool get canSubmit =>
      title.trim().isNotEmpty &&
      choiceA.trim().isNotEmpty &&
      choiceB.trim().isNotEmpty &&
      !isSubmitting;

  void selectType(UserMissionType value) {
    type = value;
    notifyListeners();
  }

  void updateProgram(String value) {
    programLabel = value;
    notifyListeners();
  }

  void updateTitle(String value) {
    title = value;
    notifyListeners();
  }

  void updateDescription(String value) {
    description = value;
    notifyListeners();
  }

  void updateChoiceA(String value) {
    choiceA = value;
    notifyListeners();
  }

  void updateChoiceB(String value) {
    choiceB = value;
    notifyListeners();
  }

  void updateDeadline(String value) {
    deadlineLabel = value;
    notifyListeners();
  }

  Future<UserMission?> submit() async {
    if (!canSubmit) {
      return null;
    }
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      return await _communityRepository.createUserMission(
        type: type,
        title: title.trim(),
        programLabel: programLabel,
        description: description.trim(),
        choices: [choiceA.trim(), choiceB.trim()],
        deadlineLabel: type == UserMissionType.mission ? deadlineLabel : null,
        pointCost: type == UserMissionType.mission ? pointCost : 0,
      );
    } catch (_) {
      errorMessage = '유저 미션 등록에 실패했습니다.';
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
