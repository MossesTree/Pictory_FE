import 'package:flutter/foundation.dart';
import 'package:picktory/models/mission_detail.dart';
import 'package:picktory/models/mission_participation_result.dart';
import 'package:picktory/services/mission_repository.dart';

class MissionDetailViewModel extends ChangeNotifier {
  MissionDetailViewModel({
    required String missionId,
    required MissionRepository missionRepository,
  })  : _missionId = missionId,
        _missionRepository = missionRepository;

  final String _missionId;
  final MissionRepository _missionRepository;

  MissionDetail? _detail;
  String? _selectedChoiceId;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _notifyOnResult = true;

  MissionDetail? get detail => _detail;
  String? get selectedChoiceId => _selectedChoiceId;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get notifyOnResult => _notifyOnResult;
  bool get canSubmit => _selectedChoiceId != null && !_isSubmitting;

  String get submitButtonLabel {
    final cost = _detail?.mission.pointCost ?? 10;
    return '선택 후 ${cost}포인트 차감';
  }

  String? get selectedChoiceLabel {
    final id = _selectedChoiceId;
    if (id == null || _detail == null) {
      return null;
    }
    return _detail!.options
        .firstWhere((o) => o.id == id)
        .label
        .replaceFirst(RegExp(r'^[A-D]\.\s*'), '');
  }

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await _missionRepository.fetchMissionDetail(_missionId);
    } catch (_) {
      _errorMessage = '미션 정보를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectChoice(String choiceId) {
    _selectedChoiceId = choiceId;
    notifyListeners();
  }

  void setNotifyOnResult(bool value) {
    _notifyOnResult = value;
    notifyListeners();
  }

  Future<MissionParticipationResult?> submitChoice() async {
    final choiceId = _selectedChoiceId;
    if (choiceId == null || _isSubmitting) {
      return null;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _missionRepository.submitChoice(
        missionId: _missionId,
        choiceId: choiceId,
        notifyOnResult: _notifyOnResult,
      );
    } catch (_) {
      _errorMessage = '참여에 실패했습니다.';
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
