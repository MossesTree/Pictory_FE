import 'package:picktory/models/attendance_day_slot.dart';

class AttendanceCheckInResult {
  const AttendanceCheckInResult({
    required this.earnedPicks,
    required this.consecutiveDays,
    required this.cumulativeDays,
    required this.weekSlots,
    this.bonusMessage,
  });

  final int earnedPicks;
  final int consecutiveDays;
  final int cumulativeDays;
  final List<AttendanceDaySlot> weekSlots;
  final String? bonusMessage;
}
