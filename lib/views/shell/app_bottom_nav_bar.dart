import 'package:flutter/material.dart';
import 'package:picktory/core/widgets/picktory_glass_surface.dart';
import 'package:picktory/views/shell/main_tab.dart';
import 'package:picktory/views/shell/shell_theme.dart';

/// Figma 284:280 — 글래스모피즘 플로팅 탭바
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    this.floating = true,
  });

  final MainTab currentTab;
  final ValueChanged<MainTab> onTabSelected;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final content = _TabBarContent(
      currentTab: currentTab,
      onTabSelected: onTabSelected,
    );

    if (!floating) {
      return Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(bottom: bottomInset),
          decoration: const BoxDecoration(
            color: Color(0xFFF3EDFF),
            border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),
          ),
          height: ShellTheme.tabBarHeight + bottomInset,
          child: content,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ShellTheme.tabBarHorizontalMargin,
        0,
        ShellTheme.tabBarHorizontalMargin,
        ShellTheme.tabBarBottomMargin + bottomInset,
      ),
      child: PicktoryGlassSurface(
        borderRadius: BorderRadius.circular(ShellTheme.tabBarRadius),
        blurSigma: ShellTheme.tabBarBlurSigma,
        tintColor: ShellTheme.tabBarTintTop,
        tintColorEnd: ShellTheme.tabBarTintBottom,
        borderColor: ShellTheme.tabBarBorder,
        shadowColor: ShellTheme.tabBarShadow,
        specularColor: ShellTheme.tabBarSpecular,
        height: ShellTheme.tabBarHeight,
        child: content,
      ),
    );
  }
}

class _TabBarContent extends StatelessWidget {
  const _TabBarContent({
    required this.currentTab,
    required this.onTabSelected,
  });

  final MainTab currentTab;
  final ValueChanged<MainTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: MainTab.values.map((tab) {
        return _NavItem(
          tab: tab,
          isActive: tab == currentTab,
          onTap: () => onTabSelected(tab),
        );
      }).toList(),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final MainTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (tab) {
      MainTab.home => Icons.home_rounded,
      MainTab.ranking => Icons.emoji_events_outlined,
      MainTab.community => Icons.chat_bubble_outline_rounded,
      MainTab.benefits => Icons.card_giftcard_outlined,
      MainTab.my => Icons.person_outline_rounded,
    };

    final circleSize = isActive
        ? ShellTheme.tabIconActiveSize
        : ShellTheme.tabIconInactiveSize;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          splashColor: ShellTheme.tabActive.withValues(alpha: 0.12),
          highlightColor: ShellTheme.tabActive.withValues(alpha: 0.06),
          child: SizedBox(
            height: ShellTheme.tabBarHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: isActive ? ShellTheme.tabActive : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: ShellTheme.tabActive.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    iconData,
                    size: isActive ? 20 : 22,
                    color: isActive ? Colors.white : ShellTheme.tabInactive,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    height: 1,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? ShellTheme.tabActive
                        : ShellTheme.tabInactive,
                  ),
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
