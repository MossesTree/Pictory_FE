/// IA N-1 알림 종류 (8타입)
/// - 각 타입은 탭 시 명시된 deep-link로 라우팅
enum AppNotificationType {
  /// 결과 공개 → 미션 결과 화면
  result,

  /// 마감 임박 → 미션 상세 화면
  deadline,

  /// 새 미션 등록 → 미션 상세 화면
  newMission,

  /// 보상 지급 → 마이 페이지
  reward,

  /// 랭킹 변동 → 랭킹 탭
  ranking,

  /// 새 댓글 → 글 상세
  comment,

  /// 출석체크 리마인드 → 혜택 탭
  attendanceReminder,

  /// 이벤트/공지 → 이벤트 페이지 (없을 시 홈)
  event;

  String get displayLabel => switch (this) {
        AppNotificationType.result => '결과 공개',
        AppNotificationType.deadline => '마감 임박',
        AppNotificationType.newMission => '새 미션',
        AppNotificationType.reward => '보상 지급',
        AppNotificationType.ranking => '랭킹 변동',
        AppNotificationType.comment => '새 댓글',
        AppNotificationType.attendanceReminder => '출석체크',
        AppNotificationType.event => '이벤트·공지',
      };
}

/// 앱 인앱 알림 단일 항목
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.isRead,
    this.targetId,
    this.eventUrl,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final String timeLabel;
  final bool isRead;

  /// IA N-1 라우팅 대상 ID
  /// - result/deadline/newMission: missionId
  /// - comment: postId
  /// - reward/ranking/attendanceReminder/event: 사용 안 함 (탭 자체로 이동)
  final String? targetId;

  /// 이벤트 알림이 외부 또는 별도 페이지 URL을 가진 경우
  final String? eventUrl;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      timeLabel: timeLabel,
      isRead: isRead ?? this.isRead,
      targetId: targetId,
      eventUrl: eventUrl,
    );
  }
}
