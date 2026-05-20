import 'package:picktory/models/ad_reward_status.dart';
import 'package:picktory/models/attendance_check_in_result.dart';
import 'package:picktory/models/attendance_day_slot.dart';
import 'package:picktory/models/benefit_feed.dart';
import 'package:picktory/models/mini_game_item.dart';
import 'package:picktory/services/benefit_repository.dart';

class DummyBenefitRepository implements BenefitRepository {
  static const int _dailyAdLimit = 5;
  static const int _adRewardPicks = 3;
  static const int _attendanceRewardPicks = 1;
  static const int _weekBonusPicks = 5;

  int _cumulativeDays = 3;
  int _consecutiveDays = 3;
  int _weekProgress = 3;
  bool _checkedInToday = false;
  int _adWatchesToday = 0;
  int _picksEarnedToday = 0;

  static const List<MiniGameItem> _miniGames = [
    MiniGameItem(id: 'ox', title: 'OX 퀴즈', iconEmoji: '✓'),
    MiniGameItem(id: 'roulette', title: '룰렛', iconEmoji: '🎯'),
    MiniGameItem(id: 'card', title: '카드 뒤집기', iconEmoji: '🃏'),
  ];

  @override
  Future<BenefitFeed> fetchFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return BenefitFeed(
      cumulativeAttendanceDays: _cumulativeDays,
      consecutiveDays: _consecutiveDays,
      checkedInToday: _checkedInToday,
      weekSlots: _buildWeekSlots(),
      adReward: AdRewardStatus(
        canWatch: _adWatchesToday < _dailyAdLimit,
        rewardPicks: _adRewardPicks,
        watchesRemainingToday: _dailyAdLimit - _adWatchesToday,
        dailyWatchLimit: _dailyAdLimit,
      ),
      miniGames: _miniGames,
      totalPicksEarnedToday: _picksEarnedToday,
    );
  }

  @override
  Future<AttendanceCheckInResult?> checkInToday() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (_checkedInToday) {
      return null;
    }

    _checkedInToday = true;
    _cumulativeDays += 1;
    _consecutiveDays += 1;
    _weekProgress = (_weekProgress + 1).clamp(1, 7);
    _picksEarnedToday += _attendanceRewardPicks;

    var earned = _attendanceRewardPicks;
    String? bonusMessage;
    if (_weekProgress >= 7) {
      earned += _weekBonusPicks;
      bonusMessage = '7일 연속 출석 보너스 +$_weekBonusPicks Pick!';
      _weekProgress = 0;
    } else {
      bonusMessage = '7일 연속 출석 시 추가 보너스!';
    }

    return AttendanceCheckInResult(
      earnedPicks: earned,
      consecutiveDays: _consecutiveDays,
      cumulativeDays: _cumulativeDays,
      weekSlots: _buildWeekSlots(),
      bonusMessage: bonusMessage,
    );
  }

  @override
  Future<int?> completeAdWatch() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (_adWatchesToday >= _dailyAdLimit) {
      return null;
    }
    _adWatchesToday += 1;
    _picksEarnedToday += _adRewardPicks;
    return _adRewardPicks;
  }

  List<AttendanceDaySlot> _buildWeekSlots() {
    return List.generate(7, (index) {
      final day = index + 1;
      final completed = day <= _weekProgress;
      return AttendanceDaySlot(
        dayIndex: day,
        label: '$day일',
        status: completed
            ? AttendanceDayStatus.completed
            : AttendanceDayStatus.upcoming,
      );
    });
  }
}
