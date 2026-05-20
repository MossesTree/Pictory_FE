import 'package:flutter/foundation.dart';
import 'package:picktory/models/app_notification.dart';
import 'package:picktory/services/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel({
    required NotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  final NotificationRepository _notificationRepository;

  List<AppNotification> _items = const [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppNotification> get items => _items;
  bool get isLoading => _isLoading;
  bool get isEmpty => !_isLoading && _items.isEmpty;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _notificationRepository.fetchNotifications();
    } catch (_) {
      _errorMessage = '알림을 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
