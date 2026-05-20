import 'package:flutter/foundation.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/services/community_repository.dart';

enum CommunityFeedTab { thread, userMission }

class CommunityFeedViewModel extends ChangeNotifier {
  CommunityFeedViewModel({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  final CommunityRepository _communityRepository;

  CommunityFeedTab _tab = CommunityFeedTab.thread;
  UserMissionFilter _filter = UserMissionFilter.all;
  UserMissionSort _sort = UserMissionSort.latest;

  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;
  List<CommunityPost> _posts = const [];
  List<UserMission> _userMissions = const [];

  CommunityFeedTab get tab => _tab;
  UserMissionFilter get filter => _filter;
  UserMissionSort get sort => _sort;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  List<CommunityPost> get posts => List<CommunityPost>.unmodifiable(_posts);
  List<UserMission> get userMissions =>
      List<UserMission>.unmodifiable(_userMissions);

  void selectTab(CommunityFeedTab tab) {
    if (_tab == tab) {
      return;
    }
    _tab = tab;
    notifyListeners();
    load();
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
      if (_tab == CommunityFeedTab.thread) {
        await _loadPosts();
      } else {
        await _loadUserMissions();
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

  Future<void> _loadPosts() async {
    _posts = await _communityRepository.fetchThreadPosts();
  }

  Future<void> _loadUserMissions() async {
    _userMissions = await _communityRepository.fetchUserMissions(
      filter: _filter,
      sort: _sort,
    );
  }

  Future<void> _loadUserMissionsOnly() async {
    try {
      await _loadUserMissions();
    } catch (_) {
      _errorMessage = '유저 미션을 불러오지 못했습니다.';
      notifyListeners();
    }
  }
}
