import 'package:flutter/foundation.dart';
import 'package:picktory/models/community_comment.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/services/community_repository.dart';

class CommunityPostDetailViewModel extends ChangeNotifier {
  CommunityPostDetailViewModel({
    required String postId,
    required CommunityRepository communityRepository,
  })  : _postId = postId,
        _communityRepository = communityRepository;

  final String _postId;
  final CommunityRepository _communityRepository;

  bool _isLoading = false;
  String? _errorMessage;
  CommunityPost? _post;
  List<CommunityComment> _comments = const [];
  String _commentDraft = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CommunityPost? get post => _post;
  List<CommunityComment> get comments =>
      List<CommunityComment>.unmodifiable(_comments);
  String get commentDraft => _commentDraft;
  bool get canSubmitComment => _commentDraft.trim().isNotEmpty;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _post = await _communityRepository.fetchPostById(_postId);
      if (_post == null) {
        _errorMessage = '게시물을 찾을 수 없습니다.';
      } else {
        _comments = await _communityRepository.fetchComments(_postId);
      }
    } catch (_) {
      _errorMessage = '게시물을 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateCommentDraft(String value) {
    final canSubmitBefore = canSubmitComment;
    _commentDraft = value;
    final canSubmitAfter = canSubmitComment;
    if (canSubmitBefore != canSubmitAfter) {
      notifyListeners();
    }
  }

  Future<void> submitComment() async {
    if (!canSubmitComment) {
      return;
    }
    await _communityRepository.addComment(
      postId: _postId,
      content: _commentDraft.trim(),
    );
    _commentDraft = '';
    notifyListeners();
    await load();
  }

  void clearCommentDraft() {
    _commentDraft = '';
    notifyListeners();
  }

  Future<void> togglePostLike() async {
    await _communityRepository.togglePostLike(_postId);
    _post = await _communityRepository.fetchPostById(_postId);
    notifyListeners();
  }

  Future<void> deletePost() async {
    await _communityRepository.deletePost(_postId);
  }

  Future<void> deleteComment(String commentId) async {
    await _communityRepository.deleteComment(commentId);
    await load();
  }
}
