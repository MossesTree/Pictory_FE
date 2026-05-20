import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/reset_password_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key, required this.viewModel});

  final ResetPasswordViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeScaffold(
          title: viewModel.title,
          showBackButton: true,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildStep(context),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (viewModel.step) {
      case ResetPasswordStep.email:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('가입 시 사용한 이메일을\n입력해주세요'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: '이메일'),
              onChanged: viewModel.updateEmail,
            ),
            const Spacer(),
            WireframeButton(
              label: '인증코드 발송',
              enabled: viewModel.canSendCode,
              onPressed: () => viewModel.sendVerificationCode(),
            ),
          ],
        );
      case ResetPasswordStep.verify:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${viewModel.email} 으로\n발송된 6자리 코드 입력'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: '인증코드'),
              onChanged: viewModel.updateVerificationCode,
            ),
            const SizedBox(height: 8),
            Text('남은 시간 ${viewModel.remainingTime}'),
            TextButton(
              onPressed: () {},
              child: const Text('코드 재발송'),
            ),
            if (viewModel.errorMessage != null)
              Text(
                viewModel.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const Spacer(),
            WireframeButton(
              label: '다음',
              enabled: viewModel.canVerify,
              onPressed: () => viewModel.verifyCode(),
            ),
          ],
        );
      case ResetPasswordStep.newPassword:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('새로 사용할 비밀번호를\n입력해주세요'),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: '새 비밀번호'),
              onChanged: viewModel.updateNewPassword,
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호 확인'),
              onChanged: viewModel.updateConfirmPassword,
            ),
            const SizedBox(height: 8),
            const Text('✓ 영문 포함\n✓ 숫자 포함\n✓ 8자 이상'),
            const Spacer(),
            WireframeButton(
              label: '변경하기',
              enabled: viewModel.canChangePassword,
              onPressed: () => viewModel.changePassword(),
            ),
          ],
        );
      case ResetPasswordStep.done:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✓', style: TextStyle(fontSize: 40)),
            const Text('비밀번호 변경 완료'),
            const Text('새 비밀번호로\n로그인할 수 있습니다'),
            const SizedBox(height: 24),
            WireframeButton(
              label: '로그인하기',
              onPressed: () => context.go(AppRoute.login.path),
            ),
          ],
        );
    }
  }
}
