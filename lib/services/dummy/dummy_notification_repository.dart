import 'package:picktory/models/app_notification.dart';
import 'package:picktory/services/notification_repository.dart';

class DummyNotificationRepository implements NotificationRepository {
  /// IA N-1 8타입 샘플
  final List<AppNotification> _items = [
    const AppNotification(
      id: 'n1',
      type: AppNotificationType.result,
      title: '결과 공개',
      body: '환승연애4 5화 미션 결과가 공개되었어요',
      timeLabel: '방금 전',
      isRead: false,
      targetId: 'mission-2',
    ),
    const AppNotification(
      id: 'n2',
      type: AppNotificationType.deadline,
      title: '마감 임박',
      body: '나솔16기 10회 미션 마감까지 30분 남았어요',
      timeLabel: '20분 전',
      isRead: false,
      targetId: 'mission-1',
    ),
    const AppNotification(
      id: 'n3',
      type: AppNotificationType.newMission,
      title: '새 미션 등록',
      body: '관심 프로그램에 새 미션이 열렸어요',
      timeLabel: '1시간 전',
      isRead: false,
      targetId: 'mission-4',
    ),
    const AppNotification(
      id: 'n4',
      type: AppNotificationType.reward,
      title: '보상 지급',
      body: '+120 Pick이 지급되었습니다',
      timeLabel: '3시간 전',
      isRead: false,
    ),
    const AppNotification(
      id: 'n5',
      type: AppNotificationType.ranking,
      title: '랭킹 변동',
      body: '시즌 순위가 8계단 상승했어요',
      timeLabel: '어제',
      isRead: true,
    ),
    const AppNotification(
      id: 'n6',
      type: AppNotificationType.comment,
      title: '새 댓글',
      body: '내 글에 새로운 댓글이 달렸어요',
      timeLabel: '어제',
      isRead: true,
      targetId: 'post-1',
    ),
    const AppNotification(
      id: 'n7',
      type: AppNotificationType.attendanceReminder,
      title: '출석체크',
      body: '오늘 출석체크하고 Pick을 받아가세요',
      timeLabel: '2일 전',
      isRead: true,
    ),
    const AppNotification(
      id: 'n8',
      type: AppNotificationType.event,
      title: '이벤트 공지',
      body: '시즌 1 랭킹 이벤트가 시작되었어요',
      timeLabel: '3일 전',
      isRead: true,
    ),
  ];

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List<AppNotification>.unmodifiable(_items);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final index = _items.indexWhere((n) => n.id == notificationId);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(isRead: true);
  }
}
