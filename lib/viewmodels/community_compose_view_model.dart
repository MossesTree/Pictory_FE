import 'package:flutter/foundation.dart';
import 'package:picktory/core/widgets/program_episode_picker.dart';
import 'package:picktory/models/community_post_kind.dart';
import 'package:picktory/services/community_repository.dart';

/// IA C-5 글 작성 통합 ViewModel
/// - 글 종류(스레드/유저미션/유저투표) 칩으로 폼이 분기
/// - 카테고리/프로그램·회차 공통
/// - 스레드: 제목 + 내용 (필수)
/// - 유저미션: 마감 시간 + 미션 제목 + 선택지(A·B 필수, 최대 5) (필수)
/// - 유저투표: 투표 제목 + 선택지(A·B 필수, 최대 5) (필수, 마감일 없음)
class CommunityComposeViewModel extends ChangeNotifier {
  CommunityComposeViewModel({
    required CommunityRepository communityRepository,
    String? editPostId,
    CommunityPostKind initialKind = CommunityPostKind.thread,
  })  : _communityRepository = communityRepository,
        _editPostId = editPostId,
        _kind = initialKind;

  final CommunityRepository _communityRepository;
  final String? _editPostId;

  /// IA C-5 카테고리 옵션 (연애/서바이벌/음악)
  static const List<String> categoryOptions = ['연애', '서바이벌', '음악'];

  /// 마감 시간 옵션 (유저미션 전용)
  static const List<String> deadlineOptions = [
    '6시간 후',
    '12시간 후',
    '24시간 후',
    '48시간 후',
    '7일 후',
  ];

  /// 본문/내용 최대 길이
  static const int maxTitleLength = 60;
  static const int maxContentLength = 500;

  /// 이미지 최대 첨부 장수
  static const int maxImageCount = 5;

  /// 선택지 최소/최대
  static const int minChoiceCount = 2;
  static const int maxChoiceCount = 5;

  CommunityPostKind _kind;
  String? _category;
  ProgramEpisodeSelection? _programEpisode;
  String _title = '';
  String _content = '';
  List<String> _choices = ['', ''];
  String? _deadlineLabel;
  List<String> _imageAssetIds = const [];
  bool _showNickname = true;
  bool _isSubmitting = false;
  bool _isLoading = false;
  String? _errorMessage;

  // ─────────── Getters ───────────
  CommunityPostKind get kind => _kind;
  String? get category => _category;
  ProgramEpisodeSelection? get programEpisode => _programEpisode;
  String get title => _title;
  String get content => _content;
  List<String> get choices => List.unmodifiable(_choices);
  String? get deadlineLabel => _deadlineLabel;
  List<String> get imageAssetIds => List.unmodifiable(_imageAssetIds);
  bool get showNickname => _showNickname;
  bool get isSubmitting => _isSubmitting;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditMode => _editPostId != null;

  bool get canAddChoice =>
      _kind.hasChoices && _choices.length < maxChoiceCount && !_isSubmitting;
  bool get canRemoveChoice =>
      _kind.hasChoices && _choices.length > minChoiceCount;
  bool get canAddImage => _imageAssetIds.length < maxImageCount;

  /// IA C-5 게시하기 버튼 활성화 조건
  bool get canSubmit {
    if (_isSubmitting) return false;
    if (_category == null) return false;
    if (_programEpisode == null) return false;

    switch (_kind) {
      case CommunityPostKind.thread:
        return _title.trim().isNotEmpty && _content.trim().isNotEmpty;
      case CommunityPostKind.userMission:
        return _deadlineLabel != null &&
            _title.trim().isNotEmpty &&
            _hasMinChoices;
      case CommunityPostKind.userPoll:
        return _title.trim().isNotEmpty && _hasMinChoices;
    }
  }

  bool get _hasMinChoices =>
      _choices.length >= minChoiceCount &&
      _choices.take(minChoiceCount).every((c) => c.trim().isNotEmpty);

  // ─────────── Mutations ───────────

  void selectKind(CommunityPostKind kind) {
    if (_kind == kind) return;
    _kind = kind;
    // 종류 전환 시 종류별 전용 필드 초기화 (잘못된 상태 방지)
    if (!kind.hasChoices) {
      _choices = ['', ''];
    }
    if (!kind.needsDeadline) {
      _deadlineLabel = null;
    }
    notifyListeners();
  }

  void selectCategory(String value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
  }

  void selectProgramEpisode(ProgramEpisodeSelection value) {
    _programEpisode = value;
    notifyListeners();
  }

  void updateTitle(String value) {
    _title = value.length > maxTitleLength
        ? value.substring(0, maxTitleLength)
        : value;
    notifyListeners();
  }

  void updateContent(String value) {
    _content = value.length > maxContentLength
        ? value.substring(0, maxContentLength)
        : value;
    notifyListeners();
  }

  void updateChoice(int index, String value) {
    if (index < 0 || index >= _choices.length) return;
    _choices = List<String>.from(_choices);
    _choices[index] = value;
    notifyListeners();
  }

  void addChoice() {
    if (!canAddChoice) return;
    _choices = [..._choices, ''];
    notifyListeners();
  }

  void removeChoice(int index) {
    if (!canRemoveChoice || index < minChoiceCount) return;
    _choices = List<String>.from(_choices)..removeAt(index);
    notifyListeners();
  }

  void selectDeadline(String value) {
    if (_deadlineLabel == value) return;
    _deadlineLabel = value;
    notifyListeners();
  }

  void addImage(String assetId) {
    if (!canAddImage) return;
    _imageAssetIds = [..._imageAssetIds, assetId];
    notifyListeners();
  }

  void removeImage(int index) {
    if (index < 0 || index >= _imageAssetIds.length) return;
    _imageAssetIds = List<String>.from(_imageAssetIds)..removeAt(index);
    notifyListeners();
  }

  void toggleShowNickname(bool value) {
    _showNickname = value;
    notifyListeners();
  }

  Future<void> loadForEdit() async {
    if (_editPostId == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      final post = await _communityRepository.fetchPostById(_editPostId);
      if (post != null) {
        _kind = CommunityPostKind.thread;
        _title = post.title;
        _content = post.content;
        _showNickname = !post.isAnonymous;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ComposeSubmitResult?> submit() async {
    if (!canSubmit) return null;
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nonEmptyChoices = _choices
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();
      return await _communityRepository.submitCompose(
        kind: _kind,
        category: _category!,
        programLabel: _programEpisode!.program.title,
        episode: _programEpisode!.episode.label,
        imageAssetIds: _imageAssetIds,
        title: _title.trim(),
        content: _content.trim(),
        choices: nonEmptyChoices,
        deadlineLabel: _deadlineLabel,
        showNickname: _showNickname,
      );
    } catch (_) {
      _errorMessage = '게시에 실패했습니다.';
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
