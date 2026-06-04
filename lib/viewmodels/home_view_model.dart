import 'package:flutter/foundation.dart';
import 'package:picktory/models/home_feed.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/services/home_repository.dart';
import 'package:picktory/services/user_preference_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required HomeRepository homeRepository,
    required UserPreferenceRepository userPreferenceRepository,
  })  : _homeRepository = homeRepository,
        _userPreferenceRepository = userPreferenceRepository;

  final HomeRepository _homeRepository;
  final UserPreferenceRepository _userPreferenceRepository;

  // IA H-1 텍스트 상수
  final String pickSectionTitle = '당신의 PICK은?';
  final String interestEmptyMessage = '해당 조건의 미션이 없습니다';
  final String searchPlaceholder = '프로그램, 미션 검색...';
  final String resultSectionTitle = '결과공개';
  final String suggestCardTitle = '새 미션 건의하기';
  final String suggestCardSubtitle = '원하는 미션을 직접 제안해보세요';

  HomeFeed _feed = HomeFeed.empty;
  String _selectedCategory = 'ALL';
  String _selectedProgramId = 'all';
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;

  HomeFeed get feed => _feed;
  String get selectedCategory => _selectedCategory;
  String get selectedProgramId => _selectedProgramId;

  String get displayNickname => '${_feed.nickname}님';

  /// IA H-1 카테고리 탭 + 프로그램 캐러셀 조합 필터링
  List<Mission> get filteredMissions {
    var list = _feed.activeMissions;
    if (_selectedCategory != 'ALL') {
      list = list.where((m) => m.category == _selectedCategory).toList();
    }
    if (_selectedProgramId != 'all') {
      list = list.where(_matchesProgram).toList();
    }
    return list;
  }

  bool _matchesProgram(Mission mission) {
    // Phase 3에서 서버 programId 매핑으로 교체될 임시 매칭
    switch (_selectedProgramId) {
      case 'prog-solo':
        return mission.programLabel.contains('솔로') ||
            mission.programLabel.contains('나솔');
      case 'prog-transit':
        return mission.programLabel.contains('환승');
      case 'prog-chef':
        return mission.programLabel.contains('요리사');
      case 'prog-produce':
        return mission.programLabel.contains('프로듀');
      default:
        return true;
    }
  }

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  bool get hasData =>
      _feed.adBanners.isNotEmpty ||
      _feed.noticeBanners.isNotEmpty ||
      _feed.heroMissions.isNotEmpty ||
      _feed.activeMissions.isNotEmpty ||
      _feed.results.isNotEmpty;

  Future<void> loadFeed({bool isRefresh = false}) async {
    if (_isLoading || _isRefreshing) {
      return;
    }

    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      // 독립 요청은 병렬 실행하여 초기 진입 지연을 최소화
      final results = await Future.wait([
        _userPreferenceRepository.load(),
      ]);
      final preference = results[0];
      _feed = await _homeRepository.fetchFeed(
        programIds: preference.selectedProgramIds,
      );
    } catch (_) {
      _errorMessage = '홈 피드를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void refresh() => loadFeed(isRefresh: true);

  void selectCategory(String category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }

  void selectProgram(String programId) {
    if (_selectedProgramId == programId) {
      return;
    }
    _selectedProgramId = programId;
    notifyListeners();
  }
}
