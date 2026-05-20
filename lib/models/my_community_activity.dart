class MyCommunityPostItem {
  const MyCommunityPostItem({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.likeCount,
    required this.commentCount,
  });

  final String id;
  final String title;
  final String timeLabel;
  final int likeCount;
  final int commentCount;
}

class MyCommunityCommentItem {
  const MyCommunityCommentItem({
    required this.id,
    required this.postTitle,
    required this.content,
    required this.timeLabel,
    required this.likeCount,
  });

  final String id;
  final String postTitle;
  final String content;
  final String timeLabel;
  final int likeCount;
}
