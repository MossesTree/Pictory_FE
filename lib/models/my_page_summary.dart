/// IA MY-1 마이 메인 요약 모델
class MyPageSummary {
  const MyPageSummary({
    required this.nickname,
    required this.tierLabel,
    required this.tierEmoji,
    required this.tierProgress,
    required this.seasonRanking,
    required this.totalRanking,
    required this.communityRanking,
    required this.accumulatedPoints,
    required this.currentPoints,
    required this.ticketCount,
    required this.inviteCode,
    this.profileImageUrl,
  });

  final String nickname;

  /// 성장 뱃지 단계 라벨 (예: "프리티어 2")
  final String tierLabel;

  /// 성장 뱃지 단계 이모지 (예: "🌱")
  final String tierEmoji;

  /// 현재 단계 진행률 0.0 ~ 1.0
  final double tierProgress;

  /// IA MY-1: 시즌/전체/커뮤니티 랭킹 (위 단위, 0 이면 표시 없음)
  final int seasonRanking;
  final int totalRanking;
  final int communityRanking;

  /// 전체 랭킹 누적 포인트
  final int accumulatedPoints;

  /// 현재 보유 Pick
  final int currentPoints;

  /// 보유 티켓 (예: 부활권 등)
  final int ticketCount;

  /// 내 초대 코드
  final String inviteCode;

  final String? profileImageUrl;
}
