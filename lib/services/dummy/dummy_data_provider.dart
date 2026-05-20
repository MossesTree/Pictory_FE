import 'package:picktory/models/ad_banner.dart';
import 'package:picktory/models/gender.dart';
import 'package:picktory/models/genre.dart';
import 'package:picktory/models/user_profile.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/models/mission_choice.dart';
import 'package:picktory/models/mission_result.dart';
import 'package:picktory/models/story_item.dart';
import 'package:picktory/models/tv_program.dart';
import 'package:picktory/models/user_preference.dart';

class DummyDataProvider {
  static const UserPreference defaultPreference = UserPreference(
    profile: UserProfile(
      nickname: '강아지',
      gender: Gender.female,
      birthDate: '1995.03.22',
    ),
    selectedProgramIds: {'prog-1', 'prog-2'},
    isOnboardingCompleted: true,
  );

  static const List<AdBanner> adBanners = [
    AdBanner(
      id: 'ad-1',
      title: '브랜드 광고 배너',
      subtitle: '클릭 시 외부 링크 이동',
    ),
    AdBanner(
      id: 'ad-2',
      title: '브랜드 광고 배너',
      subtitle: '클릭 시 외부 링크 이동',
    ),
  ];

  static const List<Mission> heroMissions = [
    Mission(
      id: 'mission-hero-1',
      programLabel: '환승연애4 5회',
      title: '마지막 커플은 누구?',
      pointCost: 10,
      remainingLabel: '02:34:12',
      participantCount: 4321,
      isUrgent: true,
      category: '예능',
    ),
  ];

  static const List<Mission> activeMissions = [
    Mission(
      id: 'mission-1',
      programLabel: '나솔16기 10회',
      title: '최종 커플은?',
      pointCost: 10,
      remainingLabel: '11:22:00',
      participantCount: 2341,
      category: '예능',
      choices: [
        MissionChoice(id: 'a', label: 'A. 상철 & 현숙'),
        MissionChoice(id: 'b', label: 'B. 영철 & 영자'),
      ],
    ),
    Mission(
      id: 'mission-2',
      programLabel: '환승연애4 5회',
      title: '마지막 커플은?',
      pointCost: 10,
      remainingLabel: '02:34:12',
      participantCount: 4321,
      category: '예능',
      choices: [
        MissionChoice(id: 'a', label: 'A. 수지 & 민호'),
        MissionChoice(id: 'b', label: 'B. 민희 & 태환'),
      ],
    ),
    Mission(
      id: 'mission-3',
      programLabel: '흑백요리사2',
      title: '최종 우승자는?',
      pointCost: 10,
      remainingLabel: '1일 05:00',
      participantCount: 1890,
      category: '예능',
      choices: [
        MissionChoice(id: 'a', label: 'A. 백수저'),
        MissionChoice(id: 'b', label: 'B. 흑수저'),
      ],
    ),
  ];

  static const List<MissionResult> missionResults = [
    MissionResult(
      id: 'result-1',
      programLabel: '프로듀서101 · 6화 1위',
      title: '프로듀서101 · 6화 1위',
      userChoiceLabel: '김하준',
      isCorrect: true,
      rewardPoints: 80,
      participantCount: 6102,
    ),
  ];

  static const List<TvProgram> programs = [
    TvProgram(
      id: 'prog-0',
      title: '환승연애3',
      channel: 'TVING · 시즌3',
      category: '연애예능',
    ),
    TvProgram(
      id: 'prog-1',
      title: '환승연애4',
      channel: 'ENA · 시즌4',
      category: '연애예능',
    ),
    TvProgram(
      id: 'prog-2',
      title: '나는 솔로',
      channel: 'SBS · 10기',
      category: '연애예능',
    ),
    TvProgram(
      id: 'prog-3',
      title: '프로듀스101',
      channel: 'Mnet · 시즌5',
      category: 'K-pop',
    ),
    TvProgram(
      id: 'prog-4',
      title: '흑백요리사2',
      channel: 'Netflix',
      category: '서바이벌',
    ),
    TvProgram(
      id: 'prog-5',
      title: '쇼미더머니',
      channel: 'Mnet',
      category: 'K-pop',
    ),
  ];

  static const List<String> programCategories = [
    '전체',
    '연애예능',
    '서바이벌',
    'K-pop',
  ];

  static const List<StoryItem> stories = [
    StoryItem(
      id: 'mission-hero-1',
      title: '환승연애4 5화',
      summary: '마지막 커플은 누구?',
      genre: Genre.romance,
      body: 'Phase 1 더미 본문: 마지막 커플 예측 미션.',
    ),
    StoryItem(
      id: 'mission-1',
      title: '나는솔로 · 10기',
      summary: '최종 커플 1호는?',
      genre: Genre.romance,
      body: 'Phase 1 더미 본문: 최종 커플 선택 미션.',
    ),
    StoryItem(
      id: 'mission-2',
      title: '환승연애4 · 5화',
      summary: '마지막 커플은?',
      genre: Genre.romance,
      body: 'Phase 1 더미 본문: 커플 예측 미션.',
    ),
    StoryItem(
      id: 'result-1',
      title: '프로듀서101 · 6화 1위',
      summary: '결과 공개',
      genre: Genre.sf,
      body: 'Phase 1 더미 본문: 결과 상세.',
    ),
  ];
}
