import 'package:flutter/foundation.dart';
import 'package:picktory/services/community_repository.dart';

class MissionSuggestViewModel extends ChangeNotifier {
  MissionSuggestViewModel({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;

  String programLabel = '환승연애4';
  String episode = '';
  String title = '';
  String description = '';
  String choiceA = '';
  String choiceB = '';
  String choiceC = '';
  String expectedCloseLabel = '';
  String resultSource = '';
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

  void updateEpisode(String value) {
    episode = value;
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

  void updateChoiceC(String value) {
    choiceC = value;
    notifyListeners();
  }

  void updateExpectedClose(String value) {
    expectedCloseLabel = value;
    notifyListeners();
  }

  void updateResultSource(String value) {
    resultSource = value;
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
      final choices = [
        choiceA.trim(),
        choiceB.trim(),
        if (choiceC.trim().isNotEmpty) choiceC.trim(),
      ];
      await _communityRepository.submitMissionSuggestion(
        title: title.trim(),
        programLabel: programLabel,
        episode: episode.trim(),
        description: description.trim(),
        choices: choices,
        expectedCloseLabel:
            expectedCloseLabel.trim().isEmpty ? null : expectedCloseLabel.trim(),
        resultSource:
            resultSource.trim().isEmpty ? null : resultSource.trim(),
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
