import 'package:flutter/foundation.dart';
import 'package:picktory/models/notification_settings.dart';
import 'package:picktory/services/my_repository.dart';

class NotificationSettingsViewModel extends ChangeNotifier {
  NotificationSettingsViewModel({required MyRepository myRepository})
      : _myRepository = myRepository;

  final MyRepository _myRepository;

  NotificationSettings _settings = const NotificationSettings();
  bool _isLoading = false;

  NotificationSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _settings = await _myRepository.fetchNotificationSettings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    await _myRepository.saveNotificationSettings(_settings);
  }

  void setMissionResult(bool value) {
    _settings = _settings.copyWith(missionResult: value);
    notifyListeners();
    _save();
  }

  void setPointReward(bool value) {
    _settings = _settings.copyWith(pointReward: value);
    notifyListeners();
    _save();
  }

  void setInterestedProgram(bool value) {
    _settings = _settings.copyWith(interestedProgram: value);
    notifyListeners();
    _save();
  }

  void setComment(bool value) {
    _settings = _settings.copyWith(comment: value);
    notifyListeners();
    _save();
  }

  void setLike(bool value) {
    _settings = _settings.copyWith(like: value);
    notifyListeners();
    _save();
  }

  void setRankingChange(bool value) {
    _settings = _settings.copyWith(rankingChange: value);
    notifyListeners();
    _save();
  }

  void setSpecialBadge(bool value) {
    _settings = _settings.copyWith(specialBadge: value);
    notifyListeners();
    _save();
  }

  void setGrowthBadgeLevelUp(bool value) {
    _settings = _settings.copyWith(growthBadgeLevelUp: value);
    notifyListeners();
    _save();
  }

  void setEventNotice(bool value) {
    _settings = _settings.copyWith(eventNotice: value);
    notifyListeners();
    _save();
  }

  void setAppUpdate(bool value) {
    _settings = _settings.copyWith(appUpdate: value);
    notifyListeners();
    _save();
  }
}
