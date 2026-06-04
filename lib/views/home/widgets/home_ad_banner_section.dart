import 'package:flutter/material.dart';
import 'package:picktory/models/ad_banner.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeAdBannerSection extends StatefulWidget {
  const HomeAdBannerSection({super.key, required this.banners});

  final List<AdBanner> banners;

  @override
  State<HomeAdBannerSection> createState() => _HomeAdBannerSectionState();
}

class _HomeAdBannerSectionState extends State<HomeAdBannerSection> {
  static const double _bannerHeight = 90;

  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _index) {
      setState(() => _index = page);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: _bannerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              return _PromoBannerCard(banner: widget.banners[index]);
            },
          ),
          if (widget.banners.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: _AdBannerPageDots(
                count: widget.banners.length,
                index: _index,
              ),
            ),
        ],
      ),
    );
  }
}

class _AdBannerPageDots extends StatelessWidget {
  const _AdBannerPageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return Container(
          width: active ? 7 : 6,
          height: active ? 7 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? Colors.white
                : const Color(0xFF1A1A1A).withValues(alpha: 0.45),
          ),
        );
      }),
    );
  }
}

class _PromoBannerCard extends StatelessWidget {
  const _PromoBannerCard({required this.banner});

  final AdBanner banner;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4A90D9),
                Color(0xFF2E6B8A),
                Color(0xFF1A4D5C),
              ],
            ),
          ),
        ),
        Positioned(
          right: -16,
          bottom: -8,
          child: Icon(
            Icons.beach_access_rounded,
            size: 72,
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: HomeTheme.adLabelYellow,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '광고',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                banner.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
