/// IA B-1 출석 슬롯 상태
/// - completed: 출석 완료 (색상 체크)
/// - today: 오늘 (색상 테두리)
/// - upcoming: 미래 (회색)
enum AttendanceDayStatus {
  completed,
  today,
  upcoming,
}

class AttendanceDaySlot {
  const AttendanceDaySlot({
    required this.dayIndex,
    required this.label,
    required this.status,
  });

  final int dayIndex;
  final String label;
  final AttendanceDayStatus status;
}
