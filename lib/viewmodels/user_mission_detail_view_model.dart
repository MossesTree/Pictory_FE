import 'package:flutter/foundation.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/services/community_repository.dart';

class UserMissionDetailViewModel extends ChangeNotifier {
  UserMissionDetailViewModel({
    required String missionId,
    required CommunityRepository communityRepository,
  })  : _missionId = missionId,
        _communityRepository = communityRepository;

  final String _missionId;
  final CommunityRepository _communityRepository;

  bool _isLoading = false;
  String? _errorMessage;
  UserMission? _mission;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserMission? get mission => _mission;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mission = await _communityRepository.fetchUserMissionById(_missionId);
      if (_mission == null) {
        _errorMessage = '미션을 찾을 수 없습니다.';
      }
    } catch (_) {
      _errorMessage = '미션을 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike() async {
    notifyListeners();
  }
}
