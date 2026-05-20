import 'package:flutter/foundation.dart';

enum ResetPasswordStep { email, verify, newPassword, done }

class ResetPasswordViewModel extends ChangeNotifier {
  final String title = '비밀번호 찾기';

  ResetPasswordStep step = ResetPasswordStep.email;
  String email = '';
  String verificationCode = '';
  String newPassword = '';
  String confirmPassword = '';
  String remainingTime = '02:11';
  String? errorMessage;
  bool isSubmitting = false;

  bool get canSendCode => email.contains('@') && !isSubmitting;
  bool get canVerify => verificationCode.length == 6 && !isSubmitting;
  bool get canChangePassword =>
      newPassword.length >= 8 &&
      newPassword == confirmPassword &&
      !isSubmitting;

  void updateEmail(String value) {
    email = value;
    errorMessage = null;
    notifyListeners();
  }

  void updateVerificationCode(String value) {
    verificationCode = value;
    errorMessage = null;
    notifyListeners();
  }

  void updateNewPassword(String value) {
    newPassword = value;
    errorMessage = null;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> sendVerificationCode() async {
    if (!canSendCode) {
      return false;
    }
    isSubmitting = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    step = ResetPasswordStep.verify;
    isSubmitting = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyCode() async {
    if (!canVerify) {
      return false;
    }
    isSubmitting = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (verificationCode == '123456') {
      step = ResetPasswordStep.newPassword;
      errorMessage = null;
    } else {
      errorMessage = '인증코드가 올바르지 않습니다';
    }
    isSubmitting = false;
    notifyListeners();
    return step == ResetPasswordStep.newPassword;
  }

  Future<bool> changePassword() async {
    if (!canChangePassword) {
      return false;
    }
    isSubmitting = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    step = ResetPasswordStep.done;
    isSubmitting = false;
    notifyListeners();
    return true;
  }
}
