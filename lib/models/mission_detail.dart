import 'package:picktory/models/mission.dart';
import 'package:picktory/models/mission_choice.dart';

class MissionDetail {
  const MissionDetail({
    required this.mission,
    required this.options,
    required this.totalPointPool,
    this.relatedMissions = const [],
    this.relatedThreadTitles = const [],
  });

  final Mission mission;
  final List<MissionChoice> options;
  final int totalPointPool;
  final List<Mission> relatedMissions;
  final List<String> relatedThreadTitles;
}
