import 'package:flutter/foundation.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/services/community_repository.dart';

class CommunityComposeViewModel extends ChangeNotifier {
  CommunityComposeViewModel({
    required CommunityRepository communityRepository,
    String? editPostId,
  })  : _communityRepository = communityRepository,
        _editPostId = editPostId;

  final CommunityRepository _communityRepository;
  final String? _editPostId;

  String programLabel = '환승연애4 · 5화';
  String title = '';
  String content = '';
  bool showNickname = true;
  bool isSubmitting = false;
  bool isLoading = false;
  String? errorMessage;

  bool get isEditMode => _editPostId != null;
  bool get canSubmit =>
      title.trim().isNotEmpty &&
      content.trim().isNotEmpty &&
      !isSubmitting;

  Future<void> loadForEdit() async {
    if (_editPostId == null) {
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      final post = await _communityRepository.fetchPostById(_editPostId);
      if (post != null) {
        programLabel = post.programLabel;
        title = post.title;
        content = post.content;
        showNickname = !post.isAnonymous;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateProgram(String value) {
    programLabel = value;
    notifyListeners();
  }

  void updateTitle(String value) {
    title = value;
    notifyListeners();
  }

  void updateContent(String value) {
    content = value;
    notifyListeners();
  }

  void toggleShowNickname(bool value) {
    showNickname = value;
    notifyListeners();
  }

  Future<CommunityPost?> submit() async {
    if (!canSubmit) {
      return null;
    }
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (isEditMode) {
        return await _communityRepository.updatePost(
          id: _editPostId!,
          programLabel: programLabel,
          title: title.trim(),
          content: content.trim(),
          showNickname: showNickname,
        );
      }
      return await _communityRepository.createPost(
        programLabel: programLabel,
        title: title.trim(),
        content: content.trim(),
        showNickname: showNickname,
      );
    } catch (_) {
      errorMessage = '게시에 실패했습니다.';
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
