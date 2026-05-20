import 'package:flutter/material.dart';
import 'package:picktory/models/pick_history_item.dart';
import 'package:picktory/viewmodels/my_pick_history_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

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
      appBar: AppBar(title: const Text('내 픽 기록')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: PickHistoryFilter.values.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_filterLabel(filter)),
                        selected: widget.viewModel.filter == filter,
                        selectedColor: MyTheme.primaryLight,
                        checkmarkColor: MyTheme.primary,
                        onSelected: (_) =>
                            widget.viewModel.selectFilter(filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: widget.viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: widget.viewModel.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = widget.viewModel.items[index];
                          return ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.timeLabel),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '+${item.points}pt',
                                  style: const TextStyle(
                                    color: MyTheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (item.isCompleted)
                                  const Text(
                                    '완료',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: MyTheme.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _filterLabel(PickHistoryFilter filter) => switch (filter) {
        PickHistoryFilter.all => '전체',
        PickHistoryFilter.mission => '미션',
        PickHistoryFilter.community => '커뮤니티',
        PickHistoryFilter.other => '기타',
      };
}
