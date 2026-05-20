import 'package:flutter/material.dart';
import 'package:picktory/models/mini_game_item.dart';
import 'package:picktory/views/benefits/benefit_theme.dart';
import 'package:picktory/views/benefits/widgets/benefit_section_card.dart';

class MiniGameSection extends StatelessWidget {
  const MiniGameSection({
    super.key,
    required this.games,
    required this.onTapGame,
  });

  final List<MiniGameItem> games;
  final ValueChanged<MiniGameItem> onTapGame;

  @override
  Widget build(BuildContext context) {
    return BenefitSectionCard(
      title: '미니게임',
      subtitle: '다양한 게임으로 Pick을 모아보세요',
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
      child: Column(
        children: [
          for (var i = 0; i < games.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _MiniGameTile(
              game: games[i],
              onTap: () => onTapGame(games[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniGameTile extends StatelessWidget {
  const _MiniGameTile({required this.game, required this.onTap});

  final MiniGameItem game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.55,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(game.iconEmoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Text(
                game.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: BenefitTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(Icons.lock_outline, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
