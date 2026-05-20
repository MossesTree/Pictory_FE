enum PickHistoryFilter { all, mission, community, other }

enum PickHistoryType { mission, community, other }

class PickHistoryItem {
  const PickHistoryItem({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.points,
    required this.type,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String timeLabel;
  final int points;
  final PickHistoryType type;
  final bool isCompleted;
}
