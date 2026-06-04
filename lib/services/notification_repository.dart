import 'package:picktory/models/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> fetchNotifications();

  /// IA N-1 알림 탭 시 읽음 처리
  Future<void> markAsRead(String notificationId);
}
