import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/views/home/home_theme.dart';

class HomeHeroMissionCarousel extends StatefulWidget {
  const HomeHeroMissionCarousel({
    super.key,
    required this.missions,
    required this.onParticipate,
  });

  final List<Mission> missions;
  final ValueChanged<Mission> onParticipate;

  @override
  State<HomeHeroMissionCarousel> createState() =>
      _HomeHeroMissionCarouselState();
}

class _HomeHeroMissionCarouselState extends State<HomeHeroMissionCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(_onPage);
  }

  void _onPage() {
    final page = _controller.page?.round() ?? 0;
    if (page != _index) {
      setState(() => _index = page);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPage);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.missions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PicktorySpacing.md,
        0,
        PicktorySpacing.md,
        PicktorySpacing.md,
      ),
      child: SizedBox(
        height: 172,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.missions.length,
          itemBuilder: (context, index) {
            return _HeroCard(
              mission: widget.missions[index],
              pageCount: widget.missions.length,
              activeIndex: _index,
              onParticipate: () =>
                  widget.onParticipate(widget.missions[index]),
            );
          },
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.mission,
    required this.pageCount,
    required this.activeIndex,
    required this.onParticipate,
  });

  final Mission mission;
  final int pageCount;
  final int activeIndex;
  final VoidCallback onParticipate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: HomeTheme.heroGradient,
        borderRadius: BorderRadius.circular(HomeTheme.heroCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: HomeTheme.progressOrange,
                      width: 1.2,
                    ),
                  ),
                  child: const Text(
                    '진행중',
                    style: TextStyle(
                      color: HomeTheme.progressOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: HomeTheme.heroPointPill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '+${mission.pointCost}P',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              mission.programLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              mission.title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '마감까지 ${mission.remainingLabel} · 참여 ${_formatCount(mission.participantCount)}명',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onParticipate,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 7,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    '참여하기',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _HeroPageDots(
              count: pageCount,
              index: activeIndex,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCount(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}K'.replaceAll('.0K', 'K');
    }
    return n.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}

class _HeroPageDots extends StatelessWidget {
  const _HeroPageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) {
      return const SizedBox.shrink();
    }
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
                : Colors.white.withValues(alpha: 0.35),
          ),
        );
      }),
    );
  }
}
