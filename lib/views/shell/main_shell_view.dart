import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/views/shell/app_bottom_nav_bar.dart';
import 'package:picktory/views/shell/main_tab.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentTab: MainTab.values[navigationShell.currentIndex],
        onTabSelected: (tab) {
          navigationShell.goBranch(
            tab.index,
            initialLocation: tab.index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
