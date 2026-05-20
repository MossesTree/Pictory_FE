import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/mission_detail_view_model.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/mission/mission_confirm_sheet.dart';
import 'package:picktory/views/mission/widgets/mission_scaffold.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class MissionDetailView extends StatefulWidget {
  const MissionDetailView({super.key, required this.viewModel});

  final MissionDetailViewModel viewModel;

  @override
  State<MissionDetailView> createState() => _MissionDetailViewState();
}

class _MissionDetailViewState extends State<MissionDetailView> {
  MissionDetailViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  Future<void> _onSubmit() async {
    final result = await viewModel.submitChoice();
    if (!mounted || result == null) {
      return;
    }

    final label = viewModel.selectedChoiceLabel;
    if (label == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return MissionConfirmSheet(
              selectedLabel: label,
              notifyOnResult: viewModel.notifyOnResult,
              onNotifyChanged: viewModel.setNotifyOnResult,
              isSubmitting: viewModel.isSubmitting,
              onShare: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoute.missionSharePath(viewModel.detail!.mission.id));
              },
              onHome: () {
                Navigator.of(sheetContext).pop();
                context.go(AppRoute.home.path);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const MissionScaffold(
            title: '미션 상세',
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final detail = viewModel.detail;
        if (detail == null) {
          return MissionScaffold(
            title: '미션 상세',
            body: Center(
              child: Text(
                viewModel.errorMessage ?? '미션을 찾을 수 없습니다.',
                style: const TextStyle(color: HomeTheme.textSecondary),
              ),
            ),
          );
        }

        final mission = detail.mission;

        return MissionScaffold(
          title: '미션 상세',
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.ios_share_outlined),
            ),
          ],
          bottom: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MissionYellowButton(
                label: viewModel.submitButtonLabel,
                enabled: viewModel.canSubmit,
                onPressed: _onSubmit,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Container(
                  height: 80,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HomeTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '브랜드 광고 배너',
                    style: TextStyle(color: HomeTheme.textSecondary),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.programLabel,
                      style: const TextStyle(color: HomeTheme.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mission.title,
                      style: const TextStyle(
                        color: HomeTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: HomeTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mission.remainingLabel,
                        style: const TextStyle(
                          color: HomeTheme.yellow,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          '참여수 ${mission.participantCount}명',
                          style: const TextStyle(color: HomeTheme.textSecondary),
                        ),
                        const Spacer(),
                        Text(
                          '총 포인트 ${detail.totalPointPool}',
                          style: const TextStyle(color: HomeTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ...detail.options.map((option) {
                      final selected =
                          viewModel.selectedChoiceId == option.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => viewModel.selectChoice(option.id),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selected
                                  ? HomeTheme.yellow.withValues(alpha: 0.15)
                                  : HomeTheme.surface,
                              border: Border.all(
                                color: selected
                                    ? HomeTheme.yellow
                                    : HomeTheme.surfaceLight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              option.label,
                              style: TextStyle(
                                color: HomeTheme.textPrimary,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    const Text(
                      '관련 미션',
                      style: TextStyle(
                        color: HomeTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...detail.relatedMissions.map(
                      (m) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          m.title,
                          style: const TextStyle(color: HomeTheme.textPrimary),
                        ),
                        subtitle: Text(
                          m.programLabel,
                          style: const TextStyle(color: HomeTheme.textSecondary),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: HomeTheme.textSecondary,
                        ),
                        onTap: () =>
                            context.push(AppRoute.missionDetailPath(m.id)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '관련 스레드',
                      style: TextStyle(
                        color: HomeTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ...detail.relatedThreadTitles.map(
                      (title) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          title,
                          style: const TextStyle(color: HomeTheme.textPrimary),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: HomeTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
