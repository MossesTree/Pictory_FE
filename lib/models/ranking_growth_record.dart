/// 성장 티어 단계 상태
enum GrowthTierStatus {
  completed,
  inProgress,
  locked,
}

/// 성장 기록 티어 한 단계
class GrowthTierStep {
  const GrowthTierStep({
    required this.name,
    required this.minPoints,
    this.maxPoints,
    required this.status,
  });

  final String name;
  final int minPoints;
  final int? maxPoints;
  final GrowthTierStatus status;

  String get rangeLabel {
    if (maxPoints == null) {
      return '$minPoints pt 이상';
    }
    return '$minPoints ~ ${maxPoints! - 1} pt';
  }
}

/// 내 성장 기록 (R-성장기록)
class RankingGrowthRecord {
  const RankingGrowthRecord({
    required this.currentTierName,
    required this.currentPoints,
    required this.tierMinPoints,
    required this.tierMaxPoints,
    required this.steps,
  });

  final String currentTierName;
  final int currentPoints;
  final int tierMinPoints;
  final int tierMaxPoints;
  final List<GrowthTierStep> steps;

  double get tierProgress =>
      (currentPoints - tierMinPoints) / (tierMaxPoints - tierMinPoints);
}
