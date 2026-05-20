import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/gender.dart';
import 'package:picktory/viewmodels/profile_setup_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class ProfileSetupView extends StatelessWidget {
  const ProfileSetupView({super.key, required this.viewModel});

  final ProfileSetupViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final profile = viewModel.profile;
        return WireframeScaffold(
          title: viewModel.title,
          subtitle: viewModel.subtitle,
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('👤\n+'),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: '닉네임 *',
                  hintText: profile.nickname.isEmpty ? '닉네임 입력' : null,
                  helperText: viewModel.nicknameHint,
                ),
                onChanged: viewModel.updateNickname,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: viewModel.checkNicknameDuplicate,
                child: const Text('중복확인'),
              ),
              if (viewModel.isNicknameChecked)
                const Text('사용 가능한 닉네임입니다'),
              const SizedBox(height: 16),
              const Text('성별*'),
              Wrap(
                spacing: 8,
                children: Gender.values.map((gender) {
                  final selected = profile.gender == gender;
                  return ChoiceChip(
                    label: Text(gender.label),
                    selected: selected,
                    onSelected: (_) => viewModel.selectGender(gender),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: '생년월일*',
                  hintText: 'YYYY.MM.DD',
                ),
                onChanged: viewModel.updateBirthDate,
              ),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
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
              context.go(AppRoute.signupPrograms.path);
            },
          ),
        );
      },
    );
  }
}
