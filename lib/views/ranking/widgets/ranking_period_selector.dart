import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_period.dart';

class RankingPeriodSelector extends StatelessWidget {
  const RankingPeriodSelector({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final List<RankingPeriodOption> options;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = options.firstWhere(
      (o) => o.id == selectedId,
      orElse: () => options.first,
    );

    return InkWell(
      onTap: () => _showPeriodSheet(context),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  if (selected.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      selected.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (options.length > 1) const Text('▼', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _showPeriodSheet(BuildContext context) async {
    if (options.length <= 1) {
      return;
    }
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '기간 선택',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...options.map(
              (option) => ListTile(
                title: Text(option.label),
                subtitle:
                    option.subtitle != null ? Text(option.subtitle!) : null,
                trailing: option.id == selectedId
                    ? const Icon(Icons.check, size: 20)
                    : null,
                onTap: () => Navigator.pop(ctx, option.id),
              ),
            ),
          ],
        ),
      ),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }
}
