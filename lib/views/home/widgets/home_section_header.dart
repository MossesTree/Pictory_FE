import 'package:flutter/material.dart';
import 'package:picktory/core/widgets/picktory_section_header.dart';
import 'package:picktory/views/home/home_theme.dart';

/// 홈 섹션 타이틀 — [PicktorySectionHeader] 래퍼
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.titleColor,
  });

  final String title;
  final Color? titleColor;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return PicktorySectionHeader(
      title: title,
      palette: HomeTheme.palette,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }
}
