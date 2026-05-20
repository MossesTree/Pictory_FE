class UserMissionChoiceStat {
  const UserMissionChoiceStat({
    required this.label,
    required this.percent,
    this.isUserChoice = false,
  });

  final String label;
  final int percent;
  final bool isUserChoice;
}
