import 'package:flutter/foundation.dart';

enum FindIdStep { input, result, error }

class FindIdViewModel extends ChangeNotifier {
  final String title = '아이디(이메일) 찾기';
  final String inputSubtitle = '가입 시 입력한 닉네임과\n생년월일을 입력해주세요';

  String nickname = '';
  String birthDate = '';
  FindIdStep step = FindIdStep.input;
  String? maskedEmail;
  String? joinedAt;
  String? errorMessage;

  bool get canSubmit => nickname.isNotEmpty && birthDate.isNotEmpty;

  void updateNickname(String value) {
    nickname = value;
    errorMessage = null;
    notifyListeners();
  }

  void updateBirthDate(String value) {
    birthDate = value;
    errorMessage = null;
    notifyListeners();
  }

  void submit() {
    if (!canSubmit) {
      return;
    }

    if (nickname == '강아지' && birthDate == '1995.03.22') {
      step = FindIdStep.result;
      maskedEmail = 'hong**@gmail.com';
      joinedAt = '2024.03.15 가입';
      errorMessage = null;
    } else {
      step = FindIdStep.error;
      errorMessage = '일치하는 계정을 찾을 수 없습니다';
      maskedEmail = null;
    }
    notifyListeners();
  }
}
