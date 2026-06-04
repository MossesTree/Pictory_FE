import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/notice_banner.dart';
import 'package:picktory/views/home/home_theme.dart';

/// H-1 공지 배너 섹션
/// - Pick 충전 유도 배너 / 이벤트 / 일반 공지를 가로 스와이프로 노출
/// - IA: "공지사항 띄우는 배너"
class HomeNoticeBannerSection extends StatefulWidget {
  const HomeNoticeBannerSection({
    super.key,
    required this.banners,
    required this.onTap,
  });

  final List<NoticeBanner> banners;
  final ValueChanged<NoticeBanner> onTap;

  @override
  State<HomeNoticeBannerSection> createState() =>
      _HomeNoticeBannerSectionState();
}

class _HomeNoticeBannerSectionState extends State<HomeNoticeBannerSection> {
  static const double _height = 56;

  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1);
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PicktorySpacing.md,
        PicktorySpacing.sm,
        PicktorySpacing.md,
        0,
      ),
      child: SizedBox(
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  final banner = widget.banners[index];
                  return _NoticeCard(
                    banner: banner,
                    onTap: () => widget.onTap(banner),
                  );
                },
              ),
            ),
            if (widget.banners.length > 1)
              Positioned(
                right: 10,
                bottom: 6,
                child: _PageDots(
                  count: widget.banners.length,
                  index: _index,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.banner, required this.onTap});

  final NoticeBanner banner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HomeTheme.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Text(
                banner.emoji ?? '📢',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      banner.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: HomeTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (banner.subtitle != null)
                      Text(
                        banner.subtitle!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: HomeTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: HomeTheme.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return Container(
          width: active ? 6 : 5,
          height: active ? 6 : 5,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? HomeTheme.primaryPurple
                : HomeTheme.textTertiary.withValues(alpha: 0.4),
          ),
        );
      }),
    );
  }
}
