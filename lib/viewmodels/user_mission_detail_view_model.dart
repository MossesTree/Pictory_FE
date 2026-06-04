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
  bool _isSubmitting = false;
  String? _errorMessage;
  UserMission? _mission;
  int? _selectedChoiceIndex;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  UserMission? get mission => _mission;
  int? get selectedChoiceIndex => _selectedChoiceIndex;

  bool get canParticipate =>
      _mission != null &&
      _mission!.isActive &&
      !_mission!.hasParticipated &&
      _selectedChoiceIndex != null &&
      !_isSubmitting;

  String get participateButtonLabel {
    if (_mission == null) {
      return '선택';
    }
    if (_mission!.isMissionType && _mission!.pointCost > 0) {
      return '선택 후 ${_mission!.pointCost}포인트 차감';
    }
    return '선택';
  }

  /// IA UM-4 → C-2: 이 유저 미션과 연결된 스레드 ID
  /// Phase 3 서버 연동 전까지 첫 더미 게시물(post-1)로 라우팅
  String get relatedPostId => 'post-1';

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

  void selectChoice(int index) {
    if (_mission == null || _mission!.hasParticipated) {
      return;
    }
    _selectedChoiceIndex = index;
    notifyListeners();
  }

  Future<bool> participate() async {
    final index = _selectedChoiceIndex;
    if (!canParticipate || index == null) {
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mission = await _communityRepository.participateUserMission(
        missionId: _missionId,
        choiceIndex: index,
      );
      return true;
    } catch (_) {
      _errorMessage = '참여에 실패했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
