import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/program_selection_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_primary_button.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_scaffold.dart';

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
        return OnboardingScaffold(
          title: viewModel.title,
          subtitle: viewModel.subtitle,
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: '프로그램 검색...',
                          prefixIcon: Icon(Icons.search),
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
                          final selected =
                              viewModel.selectedCategory == category;
                          return FilterChip(
                            label: Text(category),
                            selected: selected,
                            selectedColor: OnboardingTheme.yellow,
                            checkmarkColor: OnboardingTheme.black,
                            onSelected: (_) =>
                                viewModel.selectCategory(category),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                        itemCount: viewModel.programs.length,
                        itemBuilder: (context, index) {
                          final program = viewModel.programs[index];
                          final selected = viewModel.isSelected(program.id);
                          return InkWell(
                            onTap: () => viewModel.toggleProgram(program.id),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selected
                                    ? OnboardingTheme.yellow.withValues(alpha: 0.35)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selected
                                      ? OnboardingTheme.yellow
                                      : Colors.grey.shade300,
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    program.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    program.channel,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (selected)
                                    const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: OnboardingTheme.black,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          bottom: OnboardingPrimaryButton(
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
