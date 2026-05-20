import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/gender.dart';
import 'package:picktory/viewmodels/profile_setup_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_primary_button.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_scaffold.dart';

class ProfileSetupView extends StatelessWidget {
  const ProfileSetupView({super.key, required this.viewModel});

  final ProfileSetupViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final profile = viewModel.profile;
        return OnboardingScaffold(
          title: viewModel.title,
          subtitle: viewModel.subtitle,
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, size: 48, color: Colors.grey),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: OnboardingTheme.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text('닉네임*', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '닉네임을 입력해 주세요',
                        helperText: viewModel.nicknameHint,
                      ),
                      onChanged: viewModel.updateNickname,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: viewModel.checkNicknameDuplicate,
                      child: const Text('중복확인'),
                    ),
                  ),
                ],
              ),
              if (viewModel.isNicknameChecked)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    '사용 가능한 닉네임입니다',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 20),
              const Text('성별*', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SegmentedButton<Gender>(
                segments: Gender.values
                    .map((g) => ButtonSegment(value: g, label: Text(g.label)))
                    .toList(),
                selected: profile.gender != null ? {profile.gender!} : {},
                emptySelectionAllowed: true,
                onSelectionChanged: (selected) {
                  if (selected.isNotEmpty) {
                    viewModel.selectGender(selected.first);
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text('생년월일*', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(hintText: 'YYYY.MM.DD'),
                keyboardType: TextInputType.datetime,
                onChanged: viewModel.updateBirthDate,
              ),
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    viewModel.errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
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
              context.go(AppRoute.signupPrograms.path);
            },
          ),
        );
      },
    );
  }
}
