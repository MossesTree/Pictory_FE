import 'package:flutter/foundation.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/models/ranking_my_summary.dart';
import 'package:picktory/models/ranking_period.dart';
import 'package:picktory/models/ranking_profile_preview.dart';
import 'package:picktory/services/ranking_repository.dart';

class RankingViewModel extends ChangeNotifier {
  RankingViewModel({required RankingRepository rankingRepository})
      : _rankingRepository = rankingRepository;

  final RankingRepository _rankingRepository;

  RankingMainTab _mainTab = RankingMainTab.season;
  String _selectedPeriodId = '';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isRefreshing = false;
  String? _errorMessage;
  List<RankingPodiumEntry> _podium = const [];
  List<RankingEntry> _entries = const [];
  RankingMySummary? _mySummary;
  List<RankingPeriodOption> _periodOptions = const [];
  bool _hasMore = false;
  int _page = 0;
  String? _activityScoreFormula;

  RankingMainTab get mainTab => _mainTab;
  String get selectedPeriodId => _selectedPeriodId;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  List<RankingPodiumEntry> get podium =>
      List<RankingPodiumEntry>.unmodifiable(_podium);
  List<RankingEntry> get entries => List<RankingEntry>.unmodifiable(_entries);
  RankingMySummary? get mySummary => _mySummary;
  List<RankingPeriodOption> get periodOptions =>
      List<RankingPeriodOption>.unmodifiable(_periodOptions);
  bool get hasMore => _hasMore;
  String? get activityScoreFormula => _activityScoreFormula;

  RankingPeriodOption? get selectedPeriod {
    for (final option in _periodOptions) {
      if (option.id == _selectedPeriodId) {
        return option;
      }
    }
    return _periodOptions.isNotEmpty ? _periodOptions.first : null;
  }

  String get scoreColumnLabel =>
      _mainTab == RankingMainTab.community ? '활동점수' : '점수';

  void selectMainTab(RankingMainTab tab) {
    if (_mainTab == tab) {
      return;
    }
    _mainTab = tab;
    _selectedPeriodId = '';
    _page = 0;
    notifyListeners();
    load();
  }

  void selectPeriod(String periodId) {
    if (_selectedPeriodId == periodId) {
      return;
    }
    _selectedPeriodId = periodId;
    _page = 0;
    notifyListeners();
    load();
  }

  Future<void> load({bool isRefresh = false}) async {
    if (_isLoading || _isLoadingMore) {
      return;
    }
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    _page = 0;
    notifyListeners();

    try {
      final feed = await _rankingRepository.fetchRanking(
        tab: _mainTab,
        periodId: _selectedPeriodId,
        page: 0,
      );
      _applyFeed(feed, resetEntries: true);
    } catch (_) {
      _errorMessage = '랭킹 데이터를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoading || _isLoadingMore) {
      return;
    }
    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _page + 1;
      final feed = await _rankingRepository.fetchRanking(
        tab: _mainTab,
        periodId: _selectedPeriodId,
        page: nextPage,
      );
      _page = nextPage;
      _hasMore = feed.hasMore;
      _entries = [..._entries, ...feed.entries];
    } catch (_) {
      // 추가 로드 실패는 조용히 무시
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<RankingProfilePreview?> loadProfilePreview(String userId) async {
    try {
      return await _rankingRepository.fetchProfilePreview(
        userId: userId,
        tab: _mainTab,
        periodId: _selectedPeriodId,
      );
    } catch (_) {
      return null;
    }
  }

  void _applyFeed(RankingFeed feed, {required bool resetEntries}) {
    _podium = feed.podium;
    _entries = resetEntries ? feed.entries : [..._entries, ...feed.entries];
    _mySummary = feed.mySummary;
    _periodOptions = feed.periodOptions;
    _selectedPeriodId = feed.selectedPeriodId;
    _hasMore = feed.hasMore;
    _activityScoreFormula = feed.activityScoreFormula;
    _page = 0;
  }
}
