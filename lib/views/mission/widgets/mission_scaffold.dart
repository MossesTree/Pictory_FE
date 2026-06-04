import 'package:flutter/material.dart';
import 'package:picktory/views/mission/mission_theme.dart';

/// 미션·결과·공유 화면 공통 스캐폴드 (Figma 524:3397 라이트 테마 기준)
class MissionScaffold extends StatelessWidget {
  const MissionScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottom,
    this.leading,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottom;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MissionTheme.background,
      appBar: AppBar(
        backgroundColor: MissionTheme.background,
        foregroundColor: MissionTheme.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: MissionTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: leading,
        actions: actions,
      ),
      bottomNavigationBar: bottom,
      body: body,
    );
  }
}
