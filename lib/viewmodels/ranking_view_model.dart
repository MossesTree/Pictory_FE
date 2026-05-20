import 'package:flutter/foundation.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/models/ranking_my_summary.dart';
import 'package:picktory/models/ranking_period.dart';
import 'package:picktory/models/ranking_profile_preview.dart';
import 'package:picktory/services/ranking_repository.dart';

class _RankingTabCache {
  List<RankingPodiumEntry> podium = const [];
  List<RankingEntry> entries = const [];
  RankingMySummary? mySummary;
  List<RankingPeriodOption> periodOptions = const [];
  String selectedPeriodId = '';
  bool hasMore = false;
  int page = 0;
  String? infoBannerMessage;
  bool useCommunityTitles = false;
  String? errorMessage;
}

class RankingViewModel extends ChangeNotifier {
  RankingViewModel({required RankingRepository rankingRepository})
      : _rankingRepository = rankingRepository;

  final RankingRepository _rankingRepository;
  final Map<RankingMainTab, _RankingTabCache> _caches = {};

  RankingMainTab _mainTab = RankingMainTab.season;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isRefreshing = false;

  RankingMainTab get mainTab => _mainTab;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isRefreshing => _isRefreshing;

  _RankingTabCache get _active => _caches.putIfAbsent(_mainTab, _RankingTabCache.new);

  List<RankingPodiumEntry> get podium =>
      List<RankingPodiumEntry>.unmodifiable(_active.podium);
  List<RankingEntry> get entries =>
      List<RankingEntry>.unmodifiable(_active.entries);
  RankingMySummary? get mySummary => _active.mySummary;
  List<RankingPeriodOption> get periodOptions =>
      List<RankingPeriodOption>.unmodifiable(_active.periodOptions);
  String get selectedPeriodId => _active.selectedPeriodId;
  bool get hasMore => _active.hasMore;
  String? get errorMessage => _active.errorMessage;
  String? get infoBannerMessage => _active.infoBannerMessage;
  bool get useCommunityTitles => _active.useCommunityTitles;

  List<RankingPodiumEntry> podiumFor(RankingMainTab tab) =>
      List<RankingPodiumEntry>.unmodifiable(
        _caches[tab]?.podium ?? const [],
      );

  List<RankingEntry> entriesFor(RankingMainTab tab) =>
      List<RankingEntry>.unmodifiable(_caches[tab]?.entries ?? const []);

  List<RankingPeriodOption> periodOptionsFor(RankingMainTab tab) =>
      List<RankingPeriodOption>.unmodifiable(
        _caches[tab]?.periodOptions ?? const [],
      );

  String selectedPeriodIdFor(RankingMainTab tab) =>
      _caches[tab]?.selectedPeriodId ?? '';

  String? infoBannerFor(RankingMainTab tab) => _caches[tab]?.infoBannerMessage;

  bool useCommunityTitlesFor(RankingMainTab tab) =>
      _caches[tab]?.useCommunityTitles ?? false;

  String? errorMessageFor(RankingMainTab tab) => _caches[tab]?.errorMessage;

  bool hasCacheFor(RankingMainTab tab) =>
      _caches[tab]?.podium.isNotEmpty == true;

  bool isLoadingFor(RankingMainTab tab) =>
      _isLoading && _mainTab == tab;

  bool isLoadingMoreFor(RankingMainTab tab) =>
      _isLoadingMore && _mainTab == tab;

  bool hasMoreFor(RankingMainTab tab) => _caches[tab]?.hasMore ?? false;

  void selectMainTab(RankingMainTab tab) {
    if (_mainTab == tab) {
      return;
    }
    _mainTab = tab;
    notifyListeners();
    if (!hasCacheFor(tab)) {
      load();
    }
  }

  void selectPeriod(String periodId) {
    if (_active.selectedPeriodId == periodId) {
      return;
    }
    _active.selectedPeriodId = periodId;
    _active.page = 0;
    notifyListeners();
    load();
  }

  void selectPeriodForTab(RankingMainTab tab, String periodId) {
    _mainTab = tab;
    _caches.putIfAbsent(tab, _RankingTabCache.new);
    _active.selectedPeriodId = periodId;
    _active.page = 0;
    notifyListeners();
    load();
  }

  Future<void> load({bool isRefresh = false}) async {
    if (_isLoading || _isLoadingMore) {
      return;
    }
    final cache = _caches.putIfAbsent(_mainTab, _RankingTabCache.new);

    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    cache.errorMessage = null;
    cache.page = 0;
    notifyListeners();

    try {
      final feed = await _rankingRepository.fetchRanking(
        tab: _mainTab,
        periodId: cache.selectedPeriodId,
        page: 0,
      );
      _applyFeed(cache, feed, resetEntries: true);
    } catch (_) {
      cache.errorMessage = '랭킹 데이터를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    final cache = _active;
    if (!cache.hasMore || _isLoading || _isLoadingMore) {
      return;
    }
    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = cache.page + 1;
      final feed = await _rankingRepository.fetchRanking(
        tab: _mainTab,
        periodId: cache.selectedPeriodId,
        page: nextPage,
      );
      cache.page = nextPage;
      cache.hasMore = feed.hasMore;
      cache.entries = [...cache.entries, ...feed.entries];
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
        periodId: _active.selectedPeriodId,
      );
    } catch (_) {
      return null;
    }
  }

  void _applyFeed(
    _RankingTabCache cache,
    RankingFeed feed, {
    required bool resetEntries,
  }) {
    cache.podium = feed.podium;
    cache.entries =
        resetEntries ? feed.entries : [...cache.entries, ...feed.entries];
    cache.mySummary = feed.mySummary;
    cache.periodOptions = feed.periodOptions;
    cache.selectedPeriodId = feed.selectedPeriodId;
    cache.hasMore = feed.hasMore;
    cache.infoBannerMessage = feed.infoBannerMessage;
    cache.useCommunityTitles = feed.useCommunityTitles;
    cache.page = 0;
  }
}
