import 'package:flutter/material.dart';
import 'package:picktory/models/ad_banner.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeAdBannerSection extends StatelessWidget {
  const HomeAdBannerSection({super.key, required this.banners});

  final List<AdBanner> banners;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: HomeTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '광고',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: HomeTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    banner.subtitle,
                    style: const TextStyle(color: HomeTheme.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
