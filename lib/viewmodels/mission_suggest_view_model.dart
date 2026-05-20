import 'package:flutter/foundation.dart';
import 'package:picktory/services/community_repository.dart';

class MissionSuggestViewModel extends ChangeNotifier {
  MissionSuggestViewModel({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;

  String programLabel = '환승연애4 · 5화';
  String title = '';
  String description = '';
  String choiceA = '';
  String choiceB = '';
  bool isSubmitting = false;
  String? errorMessage;
  bool isSuccess = false;

  bool get canSubmit =>
      title.trim().isNotEmpty &&
      choiceA.trim().isNotEmpty &&
      choiceB.trim().isNotEmpty &&
      !isSubmitting;

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

  Future<bool> submit() async {
    if (!canSubmit) {
      return false;
    }
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _communityRepository.submitMissionSuggestion(
        title: title.trim(),
        programLabel: programLabel,
        description: description.trim(),
        choices: [choiceA.trim(), choiceB.trim()],
      );
      isSuccess = true;
      return true;
    } catch (_) {
      errorMessage = '건의 제출에 실패했습니다.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
