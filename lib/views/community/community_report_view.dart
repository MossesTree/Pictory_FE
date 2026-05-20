import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/models/report_reason.dart';
import 'package:picktory/viewmodels/community_report_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class CommunityReportView extends StatelessWidget {
  const CommunityReportView({super.key, required this.viewModel});

  final CommunityReportViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeScaffold(
          title: '신고하기',
          showBackButton: true,
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              ...ReportReason.values.map(
                (reason) => ListTile(
                  title: Text(reason.label),
                  trailing: viewModel.selectedReason == reason
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => viewModel.selectReason(reason),
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: '추가 설명 (선택)',
                ),
                maxLines: 3,
                onChanged: viewModel.updateDetail,
              ),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
          bottom: WireframeButton(
            label: viewModel.isSubmitting ? '접수 중...' : '신고 접수',
            enabled: viewModel.canSubmit,
            onPressed: () async {
              final ok = await viewModel.submit();
              if (!context.mounted || !ok) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('신고가 접수되었습니다.')),
              );
              context.pop();
            },
          ),
        );
      },
    );
  }
}
