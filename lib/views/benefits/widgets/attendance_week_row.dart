import 'package:flutter/material.dart';
import 'package:picktory/models/attendance_day_slot.dart';
import 'package:picktory/views/benefits/benefit_theme.dart';

class AttendanceWeekRow extends StatelessWidget {
  const AttendanceWeekRow({super.key, required this.slots});

  final List<AttendanceDaySlot> slots;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: slots.map((slot) {
        final completed = slot.status == AttendanceDayStatus.completed;
        final isToday = slot.status == AttendanceDayStatus.today;
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? BenefitTheme.primary : Colors.white,
                border: Border.all(
                  color: completed
                      ? BenefitTheme.primary
                      : isToday
                          ? BenefitTheme.primary
                          : BenefitTheme.cardBorder,
                  width: isToday ? 2 : (completed ? 0 : 1.5),
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              slot.label,
              style: TextStyle(
                fontSize: 11,
                color: completed || isToday
                    ? BenefitTheme.primary
                    : BenefitTheme.textSecondary,
                fontWeight: completed || isToday
                    ? FontWeight.w700
                    : FontWeight.normal,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
