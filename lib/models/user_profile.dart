import 'package:picktory/models/gender.dart';

class UserProfile {
  const UserProfile({
    this.nickname = '',
    this.gender,
    this.birthDate = '',
    this.profileImageUrl,
  });

  final String nickname;
  final Gender? gender;
  final String birthDate;
  final String? profileImageUrl;

  bool get isComplete =>
      nickname.isNotEmpty && gender != null && birthDate.isNotEmpty;

  UserProfile copyWith({
    String? nickname,
    Gender? gender,
    String? birthDate,
    String? profileImageUrl,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
