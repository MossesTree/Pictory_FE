class MiniGameItem {
  const MiniGameItem({
    required this.id,
    required this.title,
    required this.iconEmoji,
    this.isComingSoon = true,
  });

  final String id;
  final String title;
  final String iconEmoji;
  final bool isComingSoon;
}
