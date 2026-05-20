class AdRewardStatus {
  const AdRewardStatus({
    required this.canWatch,
    required this.rewardPicks,
    required this.watchesRemainingToday,
    required this.dailyWatchLimit,
  });

  final bool canWatch;
  final int rewardPicks;
  final int watchesRemainingToday;
  final int dailyWatchLimit;
}
