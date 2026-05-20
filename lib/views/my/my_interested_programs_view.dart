import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/models/tv_program.dart';
import 'package:picktory/viewmodels/my_interested_programs_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';

class MyInterestedProgramsView extends StatefulWidget {
  const MyInterestedProgramsView({super.key, required this.viewModel});

  final MyInterestedProgramsViewModel viewModel;

  @override
  State<MyInterestedProgramsView> createState() =>
      _MyInterestedProgramsViewState();
}

class _MyInterestedProgramsViewState extends State<MyInterestedProgramsView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    widget.viewModel.load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmSave() async {
    final programs = widget.viewModel.selectedPrograms;
    final preview = programs.take(2).map((p) => p.title).join(', ');
    final extra = programs.length > 2 ? ', +${programs.length - 2}' : '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('저장할까요?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('선택한 프로그램으로 관심 목록을 업데이트할게요'),
            const SizedBox(height: 12),
            Text('$preview$extra'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: MyTheme.primary),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final ok = await widget.viewModel.save();
    if (ok && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;

        return Scaffold(
          appBar: AppBar(title: const Text('관심 프로그램')),
          bottomNavigationBar: vm.canSave
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _confirmSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('저장'),
                      ),
                    ),
                  ),
                )
              : null,
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        '관심 프로그램 미션이 열리면 알려드려요',
                        style: TextStyle(color: MyTheme.textSecondary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '프로그램 검색',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: vm.searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    vm.search('');
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onChanged: vm.search,
                      ),
                    ),
                    if (vm.selectedPrograms.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '선택한 프로그램',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: vm.selectedPrograms.map((program) {
                            return InputChip(
                              label: Text(program.title),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () => vm.removeProgram(program.id),
                              side: const BorderSide(color: MyTheme.primary),
                              labelStyle: const TextStyle(color: MyTheme.primary),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    Expanded(
                      child: vm.searchQuery.isEmpty && vm.searchResults.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 48,
                                    color: MyTheme.textSecondary,
                                  ),
                                  SizedBox(height: 12),
                                  Text('프로그램 이름을 검색해보세요'),
                                  Text(
                                    '무한도전, 런닝맨, 1박2일',
                                    style: TextStyle(
                                      color: MyTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: vm.searchResults.length,
                              itemBuilder: (context, index) {
                                final program = vm.searchResults[index];
                                return _ProgramResultTile(
                                  program: program,
                                  isAdded: vm.isSelected(program.id),
                                  onAdd: () => vm.addProgram(program),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ProgramResultTile extends StatelessWidget {
  const _ProgramResultTile({
    required this.program,
    required this.isAdded,
    required this.onAdd,
  });

  final TvProgram program;
  final bool isAdded;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(program.title),
      subtitle: Text('${program.category} · ${program.channel}'),
      trailing: isAdded
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: MyTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 14, color: MyTheme.textSecondary),
                  SizedBox(width: 4),
                  Text('추가됨', style: TextStyle(fontSize: 12)),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: onAdd,
              style: OutlinedButton.styleFrom(
                foregroundColor: MyTheme.primary,
                side: const BorderSide(color: MyTheme.primary),
              ),
              child: const Text('+ 추가'),
            ),
    );
  }
}
