import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20),
            const SizedBox(width: 8),
            Text(
              placeholder,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
