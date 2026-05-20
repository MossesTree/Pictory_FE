import 'package:flutter/foundation.dart';
import 'package:picktory/models/community_category.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/services/community_repository.dart';

enum CommunityFeedTab { all, thread, userMission }

class CommunityFeedViewModel extends ChangeNotifier {
  CommunityFeedViewModel({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;

  CommunityFeedTab _tab = CommunityFeedTab.all;
  String _categoryId = 'all';
  UserMissionFilter _filter = UserMissionFilter.all;
  UserMissionSort _sort = UserMissionSort.latest;

  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;
  List<CommunityPost> _posts = const [];
  List<UserMission> _userMissions = const [];
  List<CommunityCategory> _categories = const [];

  CommunityFeedTab get tab => _tab;
  String get categoryId => _categoryId;
  UserMissionFilter get filter => _filter;
  UserMissionSort get sort => _sort;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  List<CommunityPost> get posts => List<CommunityPost>.unmodifiable(_posts);
  List<UserMission> get userMissions =>
      List<UserMission>.unmodifiable(_userMissions);
  List<CommunityCategory> get categories =>
      List<CommunityCategory>.unmodifiable(_categories);

  bool get showCategoryCarousel =>
      _tab == CommunityFeedTab.thread || _tab == CommunityFeedTab.userMission;

  Future<void> load({bool isRefresh = false}) async {
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
      _categories = await _communityRepository.fetchCategories();
      if (_tab == CommunityFeedTab.userMission) {
        await _loadUserMissions();
      } else {
        await _loadPosts();
      }
    } catch (_) {
      _errorMessage = '커뮤니티 데이터를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load(isRefresh: true);

  void selectTab(CommunityFeedTab tab) {
    if (_tab == tab) {
      return;
    }
    _tab = tab;
    notifyListeners();
    load();
  }

  void selectCategory(String categoryId) {
    if (_categoryId == categoryId) {
      return;
    }
    _categoryId = categoryId;
    notifyListeners();
    if (_tab == CommunityFeedTab.userMission) {
      _loadUserMissionsOnly();
    } else {
      _loadPostsOnly();
    }
  }

  void selectFilter(UserMissionFilter filter) {
    _filter = filter;
    notifyListeners();
    if (_tab == CommunityFeedTab.userMission) {
      _loadUserMissionsOnly();
    }
  }

  void selectSort(UserMissionSort sort) {
    _sort = sort;
    notifyListeners();
    if (_tab == CommunityFeedTab.userMission) {
      _loadUserMissionsOnly();
    }
  }

  Future<void> _loadPosts() async {
    final category = _tab == CommunityFeedTab.all ? null : _categoryId;
    _posts = await _communityRepository.fetchThreadPosts(
      categoryId: category == 'all' ? null : category,
    );
  }

  Future<void> _loadUserMissions() async {
    _userMissions = await _communityRepository.fetchUserMissions(
      filter: _filter,
      sort: _sort,
      categoryId: _categoryId == 'all' ? null : _categoryId,
    );
  }

  Future<void> _loadPostsOnly() async {
    try {
      await _loadPosts();
      notifyListeners();
    } catch (_) {
      _errorMessage = '게시물을 불러오지 못했습니다.';
      notifyListeners();
    }
  }

  Future<void> _loadUserMissionsOnly() async {
    try {
      await _loadUserMissions();
      notifyListeners();
    } catch (_) {
      _errorMessage = '유저 미션을 불러오지 못했습니다.';
      notifyListeners();
    }
  }
}
