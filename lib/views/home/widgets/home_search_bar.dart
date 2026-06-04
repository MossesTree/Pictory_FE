import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.placeholder,
    this.onTap,
  });

  final String placeholder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PicktorySpacing.md,
        PicktorySpacing.xs,
        PicktorySpacing.md,
        PicktorySpacing.sm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Ink(
            height: 36,
            decoration: BoxDecoration(
              color: HomeTheme.surface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: HomeTheme.heroGradientEnd, width: 1),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(
                  Icons.search_rounded,
                  color: HomeTheme.textTertiary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    placeholder,
                    style: const TextStyle(
                      fontSize: 14,
                      color: HomeTheme.textTertiary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.mic_none_rounded,
                  color: HomeTheme.textTertiary,
                  size: 20,
                ),
                const SizedBox(width: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
