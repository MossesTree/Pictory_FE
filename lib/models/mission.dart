class Mission {
  const Mission({
    required this.id,
    required this.programLabel,
    required this.title,
    required this.pointCost,
    required this.remainingLabel,
    required this.participantCount,
    this.choices = const [],
    this.isUrgent = false,
  });

  final String id;
  final String programLabel;
  final String title;
  final int pointCost;
  final String remainingLabel;
  final int participantCount;
  final List<String> choices;
  final bool isUrgent;
}
