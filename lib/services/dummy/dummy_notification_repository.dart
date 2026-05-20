import 'package:picktory/models/app_notification.dart';
import 'package:picktory/services/notification_repository.dart';

class DummyNotificationRepository implements NotificationRepository {
  static const _items = [
    AppNotification(
      id: 'n1',
      type: AppNotificationType.result,
      title: '결과 공지',
      body: '환승연애4 5화 미션 결과가 공개되었어요',
      timeLabel: '1시간 전',
      isRead: false,
    ),
    AppNotification(
      id: 'n2',
      type: AppNotificationType.mission,
      title: '미션 알림',
      body: '관심 프로그램에 새 미션이 열렸어요',
      timeLabel: '3시간 전',
      isRead: false,
    ),
    AppNotification(
      id: 'n3',
      type: AppNotificationType.reward,
      title: '보상 지급',
      body: '+120 포인트가 지급되었습니다',
      timeLabel: '어제',
      isRead: true,
    ),
    AppNotification(
      id: 'n4',
      type: AppNotificationType.ranking,
      title: '랭킹 변동',
      body: '시즌 순위가 8계단 상승했어요',
      timeLabel: '2일 전',
      isRead: true,
    ),
  ];

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _items;
  }
}
