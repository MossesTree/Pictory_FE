import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/theme/picktory_typography.dart';
import 'package:picktory/core/widgets/picktory_badge.dart';
import 'package:picktory/core/widgets/picktory_surface_card.dart';
import 'package:picktory/models/mission_result.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeResultCard extends StatelessWidget {
  const HomeResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final MissionResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = HomeTheme.palette;
    final typography = PicktoryTypography(palette);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PicktorySpacing.md),
      child: PicktorySurfaceCard(
        onTap: onTap,
        radius: 12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (result.isCorrect ? palette.success : palette.error)
                    .withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                result.isCorrect
                    ? Icons.check_rounded
                    : Icons.close_rounded,
                color: result.isCorrect ? palette.success : palette.error,
                size: 22,
              ),
            ),
            const SizedBox(width: PicktorySpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PicktoryBadge(
                    label: '결과공개',
                    variant: PicktoryBadgeVariant.result,
                  ),
                  const SizedBox(height: PicktorySpacing.xs),
                  Text(
                    result.programLabel,
                    style: typography.cardTitle.copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.resultLabel,
                    style: typography.caption.copyWith(
                      color: result.isCorrect
                          ? palette.success
                          : palette.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${result.participantCount}명 참여',
                    style: typography.caption,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: palette.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
