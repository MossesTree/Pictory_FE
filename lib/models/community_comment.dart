class CommunityComment {
  const CommunityComment({
    required this.id,
    required this.postId,
    required this.authorNickname,
    required this.content,
    required this.createdAtLabel,
    required this.likeCount,
    required this.isMine,
    this.isAnonymous = false,
    this.isEdited = false,
    this.isDeleted = false,
  });

  final String id;
  final String postId;
  final String authorNickname;
  final String content;
  final String createdAtLabel;
  final int likeCount;
  final bool isMine;
  final bool isAnonymous;
  final bool isEdited;
  final bool isDeleted;

  String get displayAuthor => isAnonymous ? '익명' : authorNickname;

  String get displayContent =>
      isDeleted ? '삭제된 댓글입니다' : content;
}
