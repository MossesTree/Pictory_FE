import 'package:flutter/foundation.dart';
import 'package:picktory/models/mission_participation_result.dart';
import 'package:picktory/services/mission_repository.dart';

class MissionResultViewModel extends ChangeNotifier {
  MissionResultViewModel({
    required String missionId,
    required MissionRepository missionRepository,
  })  : _missionId = missionId,
        _missionRepository = missionRepository;

  final String _missionId;
  final MissionRepository _missionRepository;

  MissionParticipationResult? _result;
  bool _isLoading = false;
  String? _errorMessage;

  MissionParticipationResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _result = await _missionRepository.fetchParticipationResult(_missionId);
      if (_result == null) {
        _errorMessage = '결과를 찾을 수 없습니다.';
      }
    } catch (_) {
      _errorMessage = '결과를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
