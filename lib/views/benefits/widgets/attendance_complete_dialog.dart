import 'package:flutter/material.dart';
import 'package:picktory/models/attendance_check_in_result.dart';
import 'package:picktory/views/benefits/benefit_theme.dart';
import 'package:picktory/views/benefits/widgets/attendance_week_row.dart';

class AttendanceCompleteDialog extends StatelessWidget {
  const AttendanceCompleteDialog({super.key, required this.result});

  final AttendanceCheckInResult result;

  static Future<void> show(
    BuildContext context, {
    required AttendanceCheckInResult result,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AttendanceCompleteDialog(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BenefitTheme.primaryLight,
                border: Border.all(color: BenefitTheme.primary, width: 2),
              ),
              alignment: Alignment.center,
              child: const Text('🎉', style: TextStyle(fontSize: 36)),
            ),
            const SizedBox(height: 16),
            const Text(
              '출석 완료!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: BenefitTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+${result.earnedPicks} Pick 획득',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BenefitTheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${result.consecutiveDays}일 연속 출석 중 🔥',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: BenefitTheme.textPrimary,
              ),
            ),
            if (result.bonusMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                result.bonusMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: BenefitTheme.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 20),
            AttendanceWeekRow(slots: result.weekSlots),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: BenefitTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
