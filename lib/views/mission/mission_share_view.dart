import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/widgets/picktory_async_state.dart';
import 'package:picktory/core/widgets/program_episode_picker.dart';
import 'package:picktory/viewmodels/mission_share_view_model.dart';
import 'package:picktory/views/mission/mission_theme.dart';
import 'package:picktory/views/mission/widgets/mission_form_widgets.dart';

/// IA M-4 스레드에 공유 (Figma 549:1338)
class MissionShareView extends StatefulWidget {
  const MissionShareView({super.key, required this.viewModel});

  final MissionShareViewModel viewModel;

  @override
  State<MissionShareView> createState() => _MissionShareViewState();
}

class _MissionShareViewState extends State<MissionShareView> {
  MissionShareViewModel get viewModel => widget.viewModel;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    viewModel.load();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await viewModel.submit();
    if (!mounted || !ok) {
      return;
    }
    context.pushReplacement(
      AppRoute.missionShareCompletePath(viewModel.missionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: MissionTheme.background,
          appBar: const MissionFormAppBar(title: '스레드에 공유'),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: MissionFormSubmitButton(
                label: viewModel.isSubmitting
                    ? '공유 중...'
                    : '스레드에 공유하기',
                enabled: viewModel.canSubmit,
                partial: viewModel.hasPartialProgress,
                isLoading: viewModel.isSubmitting,
                onPressed: _submit,
              ),
            ),
          ),
          body: viewModel.isLoading
              ? PicktoryAsyncState.loading()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    if (viewModel.mission != null)
                      MissionShareHeroCard(mission: viewModel.mission!),
                    const SizedBox(height: PicktorySpacing.lg),
                    const MissionFormSectionLabel(
                      label: '카테고리',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    MissionCategoryChips(
                      options: MissionShareViewModel.categoryOptions,
                      selected: viewModel.selectedCategory,
                      onSelected: viewModel.selectCategory,
                    ),
                    const SizedBox(height: PicktorySpacing.lg),
                    const MissionFormSectionLabel(
                      label: '프로그램 · 회차',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    ProgramEpisodePickerSplit(
                      selection: viewModel.programEpisode,
                      tvProgramRepository:
                          ServiceLocator.instance.tvProgramRepository,
                      onChanged: viewModel.selectProgramEpisode,
                    ),
                    const SizedBox(height: PicktorySpacing.lg),
                    const MissionFormSectionLabel(
                      label: '내용',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    MissionOutlineTextField(
                      controller: _contentController,
                      hintText: '내 의견에 대한 건의를 공유해보세요!',
                      onChanged: viewModel.updateContent,
                      maxLines: 5,
                      maxLength: MissionShareViewModel.maxContentLength,
                      counterText:
                          '${viewModel.contentLength}/${MissionShareViewModel.maxContentLength}',
                    ),
                    if (viewModel.errorMessage != null) ...[
                      const SizedBox(height: PicktorySpacing.sm),
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: MissionTheme.countdown),
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }
}
