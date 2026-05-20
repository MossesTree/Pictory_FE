import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/views/shell/main_tab.dart';

void navigateMainTab(BuildContext context, MainTab tab) {
  switch (tab) {
    case MainTab.ranking:
      context.go('/ranking');
    case MainTab.community:
      context.go(AppRoute.community.path);
    case MainTab.home:
      context.go(AppRoute.home.path);
    case MainTab.benefits:
      context.go('/benefits');
    case MainTab.my:
      context.go('/my');
  }
}
