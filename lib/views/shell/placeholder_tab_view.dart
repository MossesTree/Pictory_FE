import 'package:flutter/material.dart';
import 'package:picktory/views/shell/main_shell_view.dart';
import 'package:picktory/views/shell/main_tab.dart';

class PlaceholderTabView extends StatelessWidget {
  const PlaceholderTabView({
    super.key,
    required this.tab,
    required this.onTabSelected,
  });

  final MainTab tab;
  final ValueChanged<MainTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return MainShellView(
      currentTab: tab,
      onTabSelected: onTabSelected,
      body: Center(
        child: Text('${tab.label} (준비 중)'),
      ),
    );
  }
}
