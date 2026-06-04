import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/views/mission/mission_theme.dart';
import 'package:picktory/views/mission/widgets/mission_form_widgets.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

/// IA M-4 공유 완료 — Figma 미확정, 목 화면
class MissionShareCompleteView extends StatelessWidget {
  const MissionShareCompleteView({super.key, this.missionId});

  final String? missionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MissionTheme.background,
      appBar: const MissionFormAppBar(title: '공유 완료'),
      body: Padding(
        padding: const EdgeInsets.all(PicktorySpacing.lg),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: MissionTheme.badgeFill,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: MissionTheme.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '스레드에 공유됐어요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: MissionTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '커뮤니티 피드에서 확인할 수 있어요.\n'
              '최종 GUI 확정 후 이 화면이 교체됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: MissionTheme.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MissionTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: MissionTheme.border),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: MissionTheme.textTertiary,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '목 화면 · 실제 공유 완료 UI는 디자인 확정 후 반영 예정',
                      style: TextStyle(
                        fontSize: 12,
                        color: MissionTheme.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => context.go(AppRoute.home.path),
                style: OutlinedButton.styleFrom(
                  foregroundColor: MissionTheme.primary,
                  side: const BorderSide(
                    color: MissionTheme.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '홈으로',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
            MissionYellowButton(
              label: '커뮤니티 보기',
              onPressed: () => context.go(AppRoute.community.path),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
