import 'package:flutter/foundation.dart';
import 'package:picktory/models/mission_participation_result.dart';
import 'package:picktory/services/mission_repository.dart';

class MissionShareViewModel extends ChangeNotifier {
  MissionShareViewModel({
    required String missionId,
    required MissionRepository missionRepository,
  })  : _missionId = missionId,
        _missionRepository = missionRepository;

  final String _missionId;
  final MissionRepository _missionRepository;

  MissionParticipationResult? _result;
  String _content = '';
  String _category = '환승연애4';
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  MissionParticipationResult? get result => _result;
  String get content => _content;
  String get category => _category;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get canSubmit => _content.trim().isNotEmpty && !_isSubmitting;

  final List<String> categories = const [
    '환승연애4',
    '나는솔로',
    '프로듀스101',
    '기타',
  ];

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _result =
          await _missionRepository.fetchParticipationResult(_missionId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateContent(String value) {
    _content = value;
    notifyListeners();
  }

  void updateCategory(String value) {
    _category = value;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!canSubmit) {
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 300));

    _isSubmitting = false;
    notifyListeners();
    return true;
  }
}
