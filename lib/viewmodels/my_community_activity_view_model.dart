import 'package:flutter/foundation.dart';
import 'package:picktory/models/my_community_activity.dart';
import 'package:picktory/services/my_repository.dart';

enum MyCommunityActivityTab { posts, comments }

class MyCommunityActivityViewModel extends ChangeNotifier {
  MyCommunityActivityViewModel({required MyRepository myRepository})
      : _myRepository = myRepository;

  final MyRepository _myRepository;

  MyCommunityActivityTab _tab = MyCommunityActivityTab.posts;
  List<MyCommunityPostItem> _posts = const [];
  List<MyCommunityCommentItem> _comments = const [];
  bool _isLoading = false;

  MyCommunityActivityTab get tab => _tab;
  List<MyCommunityPostItem> get posts =>
      List<MyCommunityPostItem>.unmodifiable(_posts);
  List<MyCommunityCommentItem> get comments =>
      List<MyCommunityCommentItem>.unmodifiable(_comments);
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _myRepository.fetchMyPosts();
      _comments = await _myRepository.fetchMyComments();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(MyCommunityActivityTab tab) {
    if (_tab == tab) {
      return;
    }
    _tab = tab;
    notifyListeners();
  }
}
