import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/mission_result_view_model.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/mission/widgets/mission_scaffold.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class MissionResultView extends StatefulWidget {
  const MissionResultView({super.key, required this.viewModel});

  final MissionResultViewModel viewModel;

  @override
  State<MissionResultView> createState() => _MissionResultViewState();
}

class _MissionResultViewState extends State<MissionResultView> {
  MissionResultViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const MissionScaffold(
            title: '미션 결과',
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final result = viewModel.result;
        if (result == null) {
          return MissionScaffold(
            title: '미션 결과',
            body: Center(
              child: Text(
                viewModel.errorMessage ?? '결과 없음',
                style: const TextStyle(color: HomeTheme.textSecondary),
              ),
            ),
          );
        }

        return MissionScaffold(
          title: '미션 결과',
          actions: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                result.programLabel,
                style: const TextStyle(color: HomeTheme.textSecondary),
              ),
              Text(
                result.title,
                style: const TextStyle(
                  color: HomeTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: HomeTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.isCorrect ? '정답!' : '오답',
                      style: TextStyle(
                        color: result.isCorrect
                            ? HomeTheme.correct
                            : HomeTheme.wrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '내 선택: ${result.userChoice.label}',
                      style: const TextStyle(color: HomeTheme.textPrimary),
                    ),
                    if (result.earnedPoints > 0)
                      Text(
                        '+${result.earnedPoints} 포인트',
                        style: const TextStyle(
                          color: HomeTheme.yellow,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '참여자 선택 비율',
                style: TextStyle(
                  color: HomeTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...result.choiceStats.map((stat) {
                final barColor = stat.isUserChoice || stat.isCorrect
                    ? HomeTheme.yellow
                    : HomeTheme.surfaceLight;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          stat.choice.label,
                          style: const TextStyle(
                            color: HomeTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: (stat.percent * 1.2).clamp(24, 120),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              '${stat.percent}%',
                              style: TextStyle(
                                color: stat.isUserChoice || stat.isCorrect
                                    ? Colors.black
                                    : HomeTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              MissionYellowButton(
                label: '스레드에 공유하기',
                onPressed: () =>
                    context.push(AppRoute.missionSharePath(result.missionId)),
              ),
              const SizedBox(height: 24),
              const Text(
                '관련 스레드',
                style: TextStyle(
                  color: HomeTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ...result.relatedThreadTitles.map(
                (title) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    title,
                    style: const TextStyle(color: HomeTheme.textPrimary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
