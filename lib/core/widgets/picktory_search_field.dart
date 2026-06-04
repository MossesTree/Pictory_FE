import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_decorations.dart';
import 'package:picktory/core/theme/picktory_radius.dart';
import 'package:picktory/core/theme/picktory_typography.dart';

class PicktorySearchField extends StatelessWidget {
  const PicktorySearchField({
    super.key,
    required this.placeholder,
    this.palette = PicktoryColors.dark,
    this.onTap,
  });

  final String placeholder;
  final PicktoryPalette palette;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decorations = PicktoryDecorations(palette);
    final typography = PicktoryTypography(palette);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: PicktoryRadius.mdAll,
        child: Ink(
          decoration: decorations.searchField(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: palette.textTertiary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    placeholder,
                    style: typography.bodySecondary.copyWith(
                      color: palette.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
