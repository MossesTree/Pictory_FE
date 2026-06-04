import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_colors.dart';
import 'package:picktory/core/theme/picktory_decorations.dart';
import 'package:picktory/core/theme/picktory_radius.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';

class PicktorySurfaceCard extends StatelessWidget {
  const PicktorySurfaceCard({
    super.key,
    required this.child,
    this.palette = PicktoryColors.dark,
    this.padding = const EdgeInsets.all(PicktorySpacing.md),
    this.margin,
    this.onTap,
    this.radius = PicktoryRadius.lg,
    this.elevated = false,
  });

  final Widget child;
  final PicktoryPalette palette;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double radius;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final decorations = PicktoryDecorations(palette);
    final content = Container(
      margin: margin,
      padding: padding,
      decoration: elevated ? decorations.cardElevated(radius: radius) : decorations.card(radius: radius),
      child: child,
    );

    if (onTap == null) {
      return content;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: content,
      ),
    );
  }
}
