class MyPageSummary {
  const MyPageSummary({
    required this.nickname,
    required this.tierLabel,
    required this.totalRanking,
    required this.communityRanking,
    required this.missionRanking,
    required this.accumulatedPoints,
    required this.currentPoints,
    required this.ticketCount,
  });

  final String nickname;
  final String tierLabel;
  final int totalRanking;
  final int communityRanking;
  final int missionRanking;
  final int accumulatedPoints;
  final int currentPoints;
  final int ticketCount;
}
