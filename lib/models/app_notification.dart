enum AppNotificationType {
  result,
  mission,
  reward,
  ranking,
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.isRead,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final String timeLabel;
  final bool isRead;
}
