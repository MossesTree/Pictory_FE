import 'package:flutter/material.dart';
import 'package:picktory/views/shell/main_tab.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final MainTab currentTab;
  final ValueChanged<MainTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: MainTab.values.map((tab) {
          final isActive = tab == currentTab;
          if (tab == MainTab.home) {
            return _HomeFabItem(
              isActive: isActive,
              onTap: () => onTabSelected(tab),
            );
          }
          return _NavItem(
            icon: tab.icon,
            label: tab.label,
            isActive: isActive,
            onTap: () => onTabSelected(tab),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeFabItem extends StatelessWidget {
  const _HomeFabItem({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '홈',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '홈',
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
