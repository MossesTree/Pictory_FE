import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_growth_record.dart';
import 'package:picktory/viewmodels/ranking_growth_view_model.dart';
import 'package:picktory/views/ranking/ranking_theme.dart';

class RankingGrowthRecordView extends StatefulWidget {
  const RankingGrowthRecordView({super.key, required this.viewModel});

  final RankingGrowthViewModel viewModel;

  @override
  State<RankingGrowthRecordView> createState() => _RankingGrowthRecordViewState();
}

class _RankingGrowthRecordViewState extends State<RankingGrowthRecordView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 성장 기록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.isLoading && widget.viewModel.record == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.errorMessage != null) {
            return Center(child: Text(widget.viewModel.errorMessage!));
          }

          final record = widget.viewModel.record;
          if (record == null) {
            return const SizedBox.shrink();
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _CurrentTierCard(record: record),
              const SizedBox(height: 24),
              const Text(
                '성장 단계',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...record.steps.map((step) => _TierStepTile(step: step)),
            ],
          );
        },
      ),
    );
  }
}

class _CurrentTierCard extends StatelessWidget {
  const _CurrentTierCard({required this.record});

  final RankingGrowthRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: RankingTheme.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RankingTheme.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            record.currentTierName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${record.tierMinPoints} -> ${record.tierMaxPoints}pt / 전체 ${record.currentPoints}pt',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: record.tierProgress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white,
              color: RankingTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierStepTile extends StatelessWidget {
  const _TierStepTile({required this.step});

  final GrowthTierStep step;

  @override
  Widget build(BuildContext context) {
    final isLocked = step.status == GrowthTierStatus.locked;
    final isCurrent = step.status == GrowthTierStatus.inProgress;
    final isDone = step.status == GrowthTierStatus.completed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent
                  ? RankingTheme.primary
                  : isDone
                      ? RankingTheme.primary.withValues(alpha: 0.5)
                      : Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCurrent ? RankingTheme.primary : Colors.grey.shade300,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isLocked ? Colors.grey : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.rangeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDone)
                    const Text(
                      '완료',
                      style: TextStyle(
                        color: RankingTheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  else if (isCurrent)
                    const Text(
                      '진행 중',
                      style: TextStyle(
                        color: RankingTheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  else
                    const Text('···', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
