import 'package:picktory/models/user_mission_choice_stat.dart';

enum UserMissionType { mission, poll }

enum UserMissionStatus { active, closed }

enum UserMissionFilter { all, active, closed, mine }

enum UserMissionSort { latest, popular, participants, views }

class UserMission {
  const UserMission({
    required this.id,
    required this.type,
    required this.title,
    required this.authorNickname,
    required this.programLabel,
    required this.status,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.participantCount,
    required this.createdAtLabel,
    required this.isMine,
    this.authorBadge,
    this.remainingLabel,
    this.pointCost = 0,
    this.choices = const [],
    this.description = '',
    this.categoryId = 'all',
    this.choiceStats = const [],
    this.userSelectedChoice,
    this.hasParticipated = false,
  });

  final String id;
  final UserMissionType type;
  final String title;
  final String authorNickname;
  final String? authorBadge;
  final String programLabel;
  final UserMissionStatus status;
  final String? remainingLabel;
  final int pointCost;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final int participantCount;
  final String createdAtLabel;
  final bool isMine;
  final List<String> choices;
  final String description;
  final String categoryId;
  final List<UserMissionChoiceStat> choiceStats;
  final String? userSelectedChoice;
  final bool hasParticipated;

  bool get isMissionType => type == UserMissionType.mission;
  bool get isPollType => type == UserMissionType.poll;
  bool get isActive => status == UserMissionStatus.active;
}
