class MissionResult {
  const MissionResult({
    required this.id,
    required this.programLabel,
    required this.title,
    required this.userChoiceLabel,
    required this.isCorrect,
    required this.rewardPoints,
    required this.participantCount,
  });

  final String id;
  final String programLabel;
  final String title;
  final String userChoiceLabel;
  final bool isCorrect;
  final int rewardPoints;
  final int participantCount;

  String get resultLabel {
    if (isCorrect) {
      return '✓ 내 선택: $userChoiceLabel · 정답! +$rewardPoints포인트';
    }
    return '✗ 내 선택: $userChoiceLabel · 오답';
  }
}
