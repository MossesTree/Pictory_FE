import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: '🏆', label: '랭킹'),
          _NavItem(icon: '💬', label: '커뮤니티'),
          _NavItem(icon: '홈', label: '홈', isActive: true, isFab: true),
          _NavItem(icon: '🎁', label: '혜택'),
          _NavItem(icon: '👤', label: '마이'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isFab = false,
  });

  final String icon;
  final String label;
  final bool isActive;
  final bool isFab;

  @override
  Widget build(BuildContext context) {
    if (isFab) {
      return Column(
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
            child: Text(
              icon,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      );
    }

    return Column(
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
    );
  }
}
