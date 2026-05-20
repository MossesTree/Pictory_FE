import 'package:flutter/foundation.dart';
import 'package:picktory/models/home_feed.dart';
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

  final String interestSectionTitle = '내 관심 프로그램 미션';
  final String interestEmptyMessage = '관심 프로그램을 설정해보세요';
  final String searchPlaceholder = '프로그램, 미션 검색...';
  final String resultSectionTitle = '결과공개';

  HomeFeed _feed = HomeFeed.empty;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;

  HomeFeed get feed => _feed;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  bool get hasData =>
      _feed.adBanners.isNotEmpty ||
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
      final preference = await _userPreferenceRepository.load();
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
}
