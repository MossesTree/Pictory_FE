/// 기간 선택 옵션
class RankingPeriodOption {
  const RankingPeriodOption({
    required this.id,
    required this.label,
    this.subtitle,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String? subtitle;
  final bool isDefault;
}
