import 'package:picktory/models/community_post_kind.dart';

/// IA MY-3 내가 쓴 글 항목 (카테고리 칩 노출)
class MyCommunityPostItem {
  const MyCommunityPostItem({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.likeCount,
    required this.commentCount,
    required this.kind,
  });

  final String id;
  final String title;
  final String timeLabel;
  final int likeCount;
  final int commentCount;

  /// 스레드 / 유저미션 / 유저투표
  final CommunityPostKind kind;
}

class MyCommunityCommentItem {
  const MyCommunityCommentItem({
    required this.id,
    required this.postId,
    required this.postTitle,
    required this.content,
    required this.timeLabel,
    required this.likeCount,
  });

  final String id;

  /// 탭 시 이동할 원 게시글 ID (IA: 글 상세로 이동)
  final String postId;
  final String postTitle;
  final String content;
  final String timeLabel;
  final int likeCount;
}
