import 'package:flutter/foundation.dart';
import 'package:picktory/core/widgets/program_episode_picker.dart';
import 'package:picktory/services/community_repository.dart';

/// IA M-5 미션 건의하기 (Figma 543:891)
class MissionSuggestViewModel extends ChangeNotifier {
  MissionSuggestViewModel({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;

  static const List<String> categoryOptions = [
    '연애예능',
    '서바이벌',
    '음악',
    '드라마',
  ];

  static const int maxChoiceCount = 5;
  static const int minChoiceCount = 2;

  ProgramEpisodeSelection? _programEpisode;
  String? _selectedCategory;
  String _title = '';
  List<String> _choices = ['', ''];
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _isSuccess = false;

  ProgramEpisodeSelection? get programEpisode => _programEpisode;
  String? get selectedCategory => _selectedCategory;
  String get title => _title;
  List<String> get choices => List.unmodifiable(_choices);
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  bool get canAddChoice => _choices.length < maxChoiceCount && !_isSubmitting;
  bool get canRemoveChoice => _choices.length > minChoiceCount;

  bool get canSubmit =>
      _programEpisode != null &&
      _selectedCategory != null &&
      _title.trim().isNotEmpty &&
      _choices.length >= minChoiceCount &&
      _choices.take(minChoiceCount).every((c) => c.trim().isNotEmpty) &&
      !_isSubmitting;

  bool get hasPartialProgress =>
      !canSubmit &&
      (_programEpisode != null ||
          _selectedCategory != null ||
          _title.trim().isNotEmpty ||
          _choices.any((c) => c.trim().isNotEmpty));

  void selectProgramEpisode(ProgramEpisodeSelection value) {
    _programEpisode = value;
    notifyListeners();
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }

  void updateTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void updateChoice(int index, String value) {
    if (index < 0 || index >= _choices.length) {
      return;
    }
    _choices = List<String>.from(_choices);
    _choices[index] = value;
    notifyListeners();
  }

  void addChoice() {
    if (!canAddChoice) {
      return;
    }
    _choices = [..._choices, ''];
    notifyListeners();
  }

  void removeChoice(int index) {
    if (!canRemoveChoice || index < minChoiceCount) {
      return;
    }
    _choices = List<String>.from(_choices)..removeAt(index);
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!canSubmit) {
      return false;
    }
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nonEmpty = _choices
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();
      await _communityRepository.submitMissionSuggestion(
        title: _title.trim(),
        programLabel: _programEpisode!.program.title,
        episode: _programEpisode!.episode.label,
        description: '',
        choices: nonEmpty,
      );
      _isSuccess = true;
      return true;
    } catch (_) {
      _errorMessage = '건의 제출에 실패했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
