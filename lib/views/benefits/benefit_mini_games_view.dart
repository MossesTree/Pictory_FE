import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/mini_game_item.dart';
import 'package:picktory/views/benefits/benefit_theme.dart';

/// IA B-5 미니게임 서브페이지 (Coming Soon 안내)
class BenefitMiniGamesView extends StatelessWidget {
  const BenefitMiniGamesView({super.key});

  @override
  Widget build(BuildContext context) {
    final games =
        ServiceLocator.instance.benefitViewModel.feed.miniGames;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('미니게임'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(PicktorySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ComingSoonBanner(),
            const SizedBox(height: PicktorySpacing.xl),
            const Text(
              '오픈 예정',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: BenefitTheme.textSecondary,
              ),
            ),
            const SizedBox(height: PicktorySpacing.sm),
            Expanded(
              child: ListView.separated(
                itemCount: games.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: PicktorySpacing.sm),
                itemBuilder: (_, i) => _MiniGamePreviewTile(game: games[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PicktorySpacing.lg),
      decoration: BoxDecoration(
        color: BenefitTheme.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🎮', style: TextStyle(fontSize: 32)),
          const SizedBox(width: PicktorySpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '미니게임 곧 오픈해요',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: BenefitTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '다양한 게임을 즐기며 Pick을 모을 수 있어요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: BenefitTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniGamePreviewTile extends StatelessWidget {
  const _MiniGamePreviewTile({required this.game});

  final MiniGameItem game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PicktorySpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: BenefitTheme.cardBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(game.iconEmoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: PicktorySpacing.sm),
          Expanded(
            child: Text(
              game.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: BenefitTheme.textPrimary,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: BenefitTheme.comingSoonBadge.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: BenefitTheme.comingSoonBadge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
