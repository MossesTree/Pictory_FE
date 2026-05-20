import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/program_selection_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class ProgramSelectionView extends StatefulWidget {
  const ProgramSelectionView({super.key, required this.viewModel});

  final ProgramSelectionViewModel viewModel;

  @override
  State<ProgramSelectionView> createState() => _ProgramSelectionViewState();
}

class _ProgramSelectionViewState extends State<ProgramSelectionView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeScaffold(
          title: viewModel.title,
          subtitle: viewModel.subtitle,
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: '프로그램 검색...',
                        ),
                        onChanged: viewModel.updateSearch,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: viewModel.categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = viewModel.categories[index];
                          return ChoiceChip(
                            label: Text(category),
                            selected: viewModel.selectedCategory == category,
                            onSelected: (_) =>
                                viewModel.selectCategory(category),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: viewModel.programs.length,
                        itemBuilder: (context, index) {
                          final program = viewModel.programs[index];
                          final selected =
                              viewModel.isSelected(program.id);
                          return Card(
                            child: ListTile(
                              title: Text(program.title),
                              subtitle: Text(program.channel),
                              trailing: selected
                                  ? const Icon(Icons.check)
                                  : null,
                              onTap: () =>
                                  viewModel.toggleProgram(program.id),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          bottom: WireframeButton(
            label: viewModel.isSaving ? '저장 중...' : '다음',
            enabled: viewModel.canProceed,
            onPressed: () async {
              final ok = await viewModel.saveAndProceed();
              if (!context.mounted || !ok) {
                return;
              }
              context.go(AppRoute.signupInvite.path);
            },
          ),
        );
      },
    );
  }
}
