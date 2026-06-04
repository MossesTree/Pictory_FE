import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/shell/app_bottom_nav_bar.dart';
import 'package:picktory/views/shell/main_tab.dart';

/// 스크롤 콘텐츠 위에 글래스 탭바가 떠 있는 메인 셸
class MainShellView extends StatelessWidget {
  const MainShellView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: HomeTheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          navigationShell,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              currentTab: MainTab.values[navigationShell.currentIndex],
              onTabSelected: (tab) {
                navigationShell.goBranch(
                  tab.index,
                  initialLocation: tab.index == navigationShell.currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
