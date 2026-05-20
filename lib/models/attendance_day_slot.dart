enum AttendanceDayStatus {
  completed,
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
