class HomeProgramItem {
  const HomeProgramItem({
    required this.id,
    required this.label,
    this.shortLabel,
    this.emoji,
    this.isAll = false,
  });

  final String id;
  final String label;
  final String? shortLabel;
  final String? emoji;
  final bool isAll;

  String get displayLabel => shortLabel ?? label;
}
