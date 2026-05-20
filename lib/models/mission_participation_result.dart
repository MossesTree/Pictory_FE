import 'package:picktory/models/mission.dart';
import 'package:picktory/models/mission_choice.dart';

class MissionChoiceStat {
  const MissionChoiceStat({
    required this.choice,
    required this.percent,
    required this.isCorrect,
    required this.isUserChoice,
  });

  final MissionChoice choice;
  final int percent;
  final bool isCorrect;
  final bool isUserChoice;
}

class MissionParticipationResult {
  const MissionParticipationResult({
    required this.missionId,
    required this.programLabel,
    required this.title,
    required this.userChoice,
    required this.correctChoice,
    required this.earnedPoints,
    required this.choiceStats,
    this.relatedMissions = const [],
    this.relatedThreadTitles = const [],
  });

  final String missionId;
  final String programLabel;
  final String title;
  final MissionChoice userChoice;
  final MissionChoice correctChoice;
  final int earnedPoints;
  final List<MissionChoiceStat> choiceStats;
  final List<Mission> relatedMissions;
  final List<String> relatedThreadTitles;

  bool get isCorrect => userChoice.id == correctChoice.id;
}
