import 'package:flutter/foundation.dart';
import 'package:picktory/core/widgets/program_episode_picker.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/models/mission_participation_result.dart';
import 'package:picktory/services/mission_repository.dart';

/// IA M-4 스레드에 공유 (Figma 549:1338)
class MissionShareViewModel extends ChangeNotifier {
  MissionShareViewModel({
    required String missionId,
    required MissionRepository missionRepository,
  })  : _missionId = missionId,
        _missionRepository = missionRepository;

  final String _missionId;
  final MissionRepository _missionRepository;

  static const List<String> categoryOptions = [
    '연애예능',
    '서바이벌',
    '음악',
    '드라마',
  ];

  static const int maxContentLength = 300;

  Mission? _mission;
  MissionParticipationResult? _result;
  String? _selectedCategory;
  ProgramEpisodeSelection? _programEpisode;
  String _content = '';
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  String get missionId => _missionId;
  Mission? get mission => _mission;
  MissionParticipationResult? get result => _result;
  String? get selectedCategory => _selectedCategory;
  ProgramEpisodeSelection? get programEpisode => _programEpisode;
  String get content => _content;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  bool get canSubmit =>
      _selectedCategory != null &&
      _programEpisode != null &&
      _content.trim().isNotEmpty &&
      _content.length <= maxContentLength &&
      !_isSubmitting;

  bool get hasPartialProgress =>
      !canSubmit &&
      (_selectedCategory != null ||
          _programEpisode != null ||
          _content.trim().isNotEmpty);

  int get contentLength => _content.length;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      final detail = await _missionRepository.fetchMissionDetail(_missionId);
      _mission = detail.mission;
      _result =
          await _missionRepository.fetchParticipationResult(_missionId);
      if (_selectedCategory == null && _mission != null) {
        _selectedCategory = categoryOptions.first;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }

  void selectProgramEpisode(ProgramEpisodeSelection value) {
    _programEpisode = value;
    notifyListeners();
  }

  void updateContent(String value) {
    if (value.length > maxContentLength) {
      _content = value.substring(0, maxContentLength);
    } else {
      _content = value;
    }
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
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return true;
    } catch (_) {
      _errorMessage = '공유에 실패했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
