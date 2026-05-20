import 'package:flutter/foundation.dart';
import 'package:picktory/services/signup_repository.dart';

class InviteCodeViewModel extends ChangeNotifier {
  InviteCodeViewModel({required SignupRepository signupRepository})
      : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  final String title = '친구 초대코드';
  final String subtitle = '초대 코드가 있으면 입력해주세요';
  final String rewardHint = '+100코인 즉시 지급!';
  final String codeExample = 'KPICK123';

  String inviteCode = '';
  bool isApplying = false;
  String? errorMessage;
  String? successMessage;

  bool get canApply => inviteCode.length == 8 && !isApplying;

  void updateCode(String value) {
    inviteCode = value.toUpperCase();
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  Future<bool> applyCode() async {
    if (!canApply) {
      return false;
    }

    isApplying = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final valid = await _signupRepository.validateInviteCode(inviteCode);
      if (!valid) {
        errorMessage = '유효하지 않은 초대코드입니다';
        return false;
      }
      final draft = await _signupRepository.loadDraft();
      await _signupRepository.saveDraft(
        draft.copyWith(inviteCode: inviteCode, inviteBonusApplied: true),
      );
      successMessage = '초대코드가 적용되었습니다 (+100코인)';
      return true;
    } catch (_) {
      errorMessage = '코드 적용에 실패했습니다';
      return false;
    } finally {
      isApplying = false;
      notifyListeners();
    }
  }

  Future<bool> skip() async {
    final draft = await _signupRepository.loadDraft();
    await _signupRepository.saveDraft(
      draft.copyWith(inviteCode: null, inviteBonusApplied: false),
    );
    return true;
  }
}
