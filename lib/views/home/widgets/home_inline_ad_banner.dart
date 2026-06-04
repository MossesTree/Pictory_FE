import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_decorations.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/theme/picktory_typography.dart';
import 'package:picktory/core/widgets/picktory_badge.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeInlineAdBanner extends StatelessWidget {
  const HomeInlineAdBanner({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = HomeTheme.palette;
    final decorations = PicktoryDecorations(palette);
    final typography = PicktoryTypography(palette);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PicktorySpacing.md,
        PicktorySpacing.xs,
        PicktorySpacing.md,
        PicktorySpacing.md,
      ),
      child: Container(
        height: 76,
        padding: const EdgeInsets.all(PicktorySpacing.md),
        decoration: decorations.adBanner(),
        child: Row(
          children: [
            const PicktoryBadge(
              label: '광고',
              variant: PicktoryBadgeVariant.ad,
            ),
            const SizedBox(width: PicktorySpacing.sm),
            Expanded(
              child: Text(
                title,
                style: typography.cardTitle.copyWith(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: palette.textTertiary),
          ],
        ),
      ),
    );
  }
}
