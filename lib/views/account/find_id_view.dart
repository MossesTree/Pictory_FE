import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/find_id_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class FindIdView extends StatelessWidget {
  const FindIdView({super.key, required this.viewModel});

  final FindIdViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.step == FindIdStep.result) {
          return WireframeScaffold(
            title: '아이디 확인',
            showBackButton: true,
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('회원님의 가입 이메일을\n확인해주세요'),
                  const SizedBox(height: 24),
                  const Text('가입된 이메일'),
                  Text(
                    viewModel.maskedEmail ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(viewModel.joinedAt ?? ''),
                ],
              ),
            ),
            bottom: WireframeButton(
              label: '로그인하기',
              onPressed: () => context.go(AppRoute.login.path),
            ),
          );
        }

        return WireframeScaffold(
          title: viewModel.title,
          subtitle: viewModel.inputSubtitle,
          showBackButton: true,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: '닉네임'),
                  onChanged: viewModel.updateNickname,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '생년월일',
                    hintText: 'YYYY.MM.DD',
                  ),
                  onChanged: viewModel.updateBirthDate,
                ),
                if (viewModel.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    viewModel.errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
          bottom: WireframeButton(
            label: '다음',
            enabled: viewModel.canSubmit,
            onPressed: viewModel.submit,
          ),
        );
      },
    );
  }
}
