import 'package:flutter/material.dart';
import 'package:picktory/views/shell/app_bottom_nav_bar.dart';
import 'package:picktory/views/shell/main_tab.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.body,
  });

  final MainTab currentTab;
  final ValueChanged<MainTab> onTabSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: AppBottomNavBar(
        currentTab: currentTab,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
