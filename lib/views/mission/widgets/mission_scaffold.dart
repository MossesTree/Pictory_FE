import 'package:flutter/material.dart';
import 'package:picktory/views/home/home_theme.dart';

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
      backgroundColor: HomeTheme.background,
      appBar: AppBar(
        backgroundColor: HomeTheme.background,
        foregroundColor: HomeTheme.textPrimary,
        title: Text(title),
        leading: leading,
        actions: actions,
      ),
      bottomNavigationBar: bottom,
      body: body,
    );
  }
}
