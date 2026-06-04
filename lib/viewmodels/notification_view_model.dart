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

  List<AppNotification> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isEmpty => !_isLoading && _items.isEmpty;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _items.where((n) => !n.isRead).length;

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

  /// IA N-1 알림 탭 시 즉시 읽음 처리 (낙관적 업데이트)
  Future<void> markAsRead(String notificationId) async {
    final index = _items.indexWhere((n) => n.id == notificationId);
    if (index < 0 || _items[index].isRead) {
      return;
    }
    _items = List<AppNotification>.from(_items)
      ..[index] = _items[index].copyWith(isRead: true);
    notifyListeners();
    try {
      await _notificationRepository.markAsRead(notificationId);
    } catch (_) {
      // 실패 시 silent — 사용자 흐름을 막지 않음
    }
  }
}
