import 'dart:async';

import 'package:flutter/foundation.dart';

class BenefitAdWatchViewModel extends ChangeNotifier {
  BenefitAdWatchViewModel({
    this.totalDurationSeconds = 70,
    this.skipAvailableAfterSeconds = 64,
    this.rewardPicks = 3,
  });

  final int totalDurationSeconds;
  final int skipAvailableAfterSeconds;
  final int rewardPicks;

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isCompleted = false;

  int get elapsedSeconds => _elapsedSeconds;
  bool get isCompleted => _isCompleted;

  double get progress =>
      (_elapsedSeconds / totalDurationSeconds).clamp(0.0, 1.0);

  bool get canSkip => _elapsedSeconds >= skipAvailableAfterSeconds;

  int get secondsUntilSkip =>
      (skipAvailableAfterSeconds - _elapsedSeconds).clamp(0, 999);

  String get skipLabel {
    if (canSkip) {
      return '건너뛰기';
    }
    return '$secondsUntilSkip초 후 건너뛰기';
  }

  int get remainingSeconds =>
      (totalDurationSeconds - _elapsedSeconds).clamp(0, totalDurationSeconds);

  String get remainingTimeLabel {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    if (minutes > 0) {
      return '시청 완료까지 $minutes분 $seconds초 남음';
    }
    return '시청 완료까지 $seconds초 남음';
  }

  void start() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _isCompleted = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_elapsedSeconds >= totalDurationSeconds) {
        _complete();
        return;
      }
      _elapsedSeconds += 1;
      notifyListeners();
    });
    notifyListeners();
  }

  void _complete() {
    _timer?.cancel();
    _elapsedSeconds = totalDurationSeconds;
    _isCompleted = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
