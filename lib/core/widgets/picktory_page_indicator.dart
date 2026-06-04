import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';

class PicktoryPageIndicator extends StatelessWidget {
  const PicktoryPageIndicator({
    super.key,
    required this.count,
    required this.index,
    this.palette = PicktoryColors.dark,
  });

  final int count;
  final int index;
  final PicktoryPalette palette;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? palette.accent : palette.border,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
