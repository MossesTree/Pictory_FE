import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/pick_history_item.dart';
import 'package:picktory/viewmodels/my_pick_history_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

/// IA MY-2 내 픽 기록
class MyPickHistoryView extends StatefulWidget {
  const MyPickHistoryView({super.key, required this.viewModel});

  final MyPickHistoryViewModel viewModel;

  @override
  State<MyPickHistoryView> createState() => _MyPickHistoryViewState();
}

class _MyPickHistoryViewState extends State<MyPickHistoryView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('내 픽 기록'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Column(
            children: [
              _FilterRow(
                selected: widget.viewModel.filter,
                onSelected: widget.viewModel.selectFilter,
              ),
              Expanded(
                child: widget.viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : widget.viewModel.items.isEmpty
                        ? const Center(
                            child: Text(
                              '아직 기록이 없어요',
                              style: TextStyle(color: MyTheme.textSecondary),
                            ),
                          )
                        : ListView.separated(
                            itemCount: widget.viewModel.items.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = widget.viewModel.items[index];
                              return _HistoryTile(item: item);
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onSelected});

  final PickHistoryFilter selected;
  final ValueChanged<PickHistoryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: PicktorySpacing.sm),
        children: PickHistoryFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_label(filter)),
              selected: selected == filter,
              selectedColor: MyTheme.primaryLight,
              checkmarkColor: MyTheme.primary,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  static String _label(PickHistoryFilter filter) => switch (filter) {
        PickHistoryFilter.all => '전체',
        PickHistoryFilter.correct => '정답',
        PickHistoryFilter.incorrect => '오답',
        PickHistoryFilter.pending => '대기',
      };
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final PickHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(AppRoute.missionResultPath(item.missionId)),
      title: Text(item.title),
      subtitle: Text(item.timeLabel),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _ResultBadge(result: item.result),
          if (item.result == PickHistoryResult.correct &&
              item.points > 0) ...[
            const SizedBox(height: 2),
            Text(
              '+${item.points}pt',
              style: const TextStyle(
                color: MyTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final PickHistoryResult result;

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg) = switch (result) {
      PickHistoryResult.correct => ('정답', MyTheme.primary, MyTheme.primaryLight),
      PickHistoryResult.incorrect => (
          '오답',
          MyTheme.danger,
          Color(0x1AFF3B30),
        ),
      PickHistoryResult.pending => (
          '대기',
          MyTheme.textSecondary,
          MyTheme.surface,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
