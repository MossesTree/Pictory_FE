import 'package:flutter/material.dart';
import 'package:picktory/models/special_badge.dart';
import 'package:picktory/viewmodels/my_special_badges_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

class MySpecialBadgesView extends StatefulWidget {
  const MySpecialBadgesView({super.key, required this.viewModel});

  final MySpecialBadgesViewModel viewModel;

  @override
  State<MySpecialBadgesView> createState() => _MySpecialBadgesViewState();
}

class _MySpecialBadgesViewState extends State<MySpecialBadgesView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스페셜 뱃지')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '획득 뱃지 ${widget.viewModel.earnedBadges.length}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _BadgeGrid(badges: widget.viewModel.earnedBadges),
              const SizedBox(height: 24),
              Text(
                '미획득 ${widget.viewModel.lockedBadges.length}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _BadgeGrid(badges: widget.viewModel.lockedBadges, locked: true),
            ],
          );
        },
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.badges, this.locked = false});

  final List<SpecialBadge> badges;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: badges.map((badge) {
        return Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: locked ? MyTheme.surface : MyTheme.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MyTheme.border),
          ),
          child: Column(
            children: [
              Text(
                badge.iconEmoji,
                style: TextStyle(
                  fontSize: 28,
                  color: locked ? Colors.grey : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: locked ? MyTheme.textSecondary : MyTheme.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
