/// 공지 배너 (H-1 홈 메인의 공지/이벤트/Pick 충전 유도 배너)
/// - Pick 충전 배너: 탭 시 혜택 탭으로 이동
/// - 이벤트 배너: 탭 시 각 이벤트 페이지로 이동
class NoticeBanner {
  const NoticeBanner({
    required this.id,
    required this.title,
    required this.action,
    this.subtitle,
    this.emoji,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? emoji;
  final NoticeBannerAction action;
}

/// 공지 배너 액션 종류
enum NoticeBannerAction {
  /// Pick 충전 유도 → 혜택 탭으로 이동
  pickRecharge,

  /// 이벤트 페이지 진입
  event,

  /// 일반 공지 → 별도 동작 없음 또는 상세 화면
  notice,
}
