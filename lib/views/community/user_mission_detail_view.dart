import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/user_mission_detail_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';

class UserMissionDetailView extends StatefulWidget {
  const UserMissionDetailView({super.key, required this.viewModel});

  final UserMissionDetailViewModel viewModel;

  @override
  State<UserMissionDetailView> createState() => _UserMissionDetailViewState();
}

class _UserMissionDetailViewState extends State<UserMissionDetailView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.mission?.isMissionType == true
              ? '미션형 상세'
              : '투표형 상세',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              final id = viewModel.mission?.id;
              if (id != null) {
                context.push(
                  AppRoute.communityReportPath(
                    targetType: 'userMission',
                    targetId: id,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }
          final mission = viewModel.mission;
          if (mission == null) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mission.programLabel),
                const SizedBox(height: 8),
                Text(
                  mission.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(mission.description),
                if (mission.remainingLabel != null) ...[
                  const SizedBox(height: 8),
                  Text(mission.remainingLabel!),
                ],
                if (mission.isMissionType) ...[
                  const SizedBox(height: 8),
                  Text('${mission.pointCost}포인트'),
                ],
                const SizedBox(height: 16),
                ...mission.choices.map(
                  (choice) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: WireframeButton(
                      label: choice,
                      onPressed: () {},
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '♡ ${mission.likeCount}  □ ${mission.commentCount}  👁 ${mission.viewCount}',
                ),
                const SizedBox(height: 8),
                Text('👤 유저가 만든 미션 · 부적절한 내용은 신고'),
              ],
            ),
          );
        },
      ),
    );
  }
}
