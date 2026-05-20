import 'package:picktory/models/ad_reward_status.dart';
import 'package:picktory/models/attendance_day_slot.dart';
import 'package:picktory/models/mini_game_item.dart';

class BenefitFeed {
  const BenefitFeed({
    required this.cumulativeAttendanceDays,
    required this.consecutiveDays,
    required this.checkedInToday,
    required this.weekSlots,
    required this.adReward,
    required this.miniGames,
    required this.totalPicksEarnedToday,
  });

  final int cumulativeAttendanceDays;
  final int consecutiveDays;
  final bool checkedInToday;
  final List<AttendanceDaySlot> weekSlots;
  final AdRewardStatus adReward;
  final List<MiniGameItem> miniGames;
  final int totalPicksEarnedToday;

  static const empty = BenefitFeed(
    cumulativeAttendanceDays: 0,
    consecutiveDays: 0,
    checkedInToday: false,
    weekSlots: [],
    adReward: AdRewardStatus(
      canWatch: false,
      rewardPicks: 0,
      watchesRemainingToday: 0,
      dailyWatchLimit: 5,
    ),
    miniGames: [],
    totalPicksEarnedToday: 0,
  );
}
