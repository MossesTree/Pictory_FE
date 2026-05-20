class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.authorNickname,
    required this.programLabel,
    required this.title,
    required this.content,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.createdAtLabel,
    required this.isMine,
    this.authorBadge,
    this.isAnonymous = false,
    this.isMissionShare = false,
    this.linkedMissionLabel,
    this.linkedMissionId,
    this.categoryId = 'all',
    this.broadcastDate,
    this.hasPoll = false,
    this.pollOptions = const [],
  });

  final String id;
  final String authorNickname;
  final String? authorBadge;
  final String programLabel;
  final String title;
  final String content;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final String createdAtLabel;
  final bool isMine;
  final bool isAnonymous;
  final bool isMissionShare;
  final String? linkedMissionLabel;
  final String? linkedMissionId;
  final String categoryId;
  final String? broadcastDate;
  final bool hasPoll;
  final List<String> pollOptions;

  String get displayAuthor => isAnonymous ? '익명' : authorNickname;

  String get headerLabel {
    if (broadcastDate != null) {
      return '$programLabel · $broadcastDate';
    }
    return programLabel;
  }
}
