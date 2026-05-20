import 'package:flutter/material.dart';
import 'package:picktory/models/ad_banner.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
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
                      color: Colors.black26,
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(banner.subtitle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
