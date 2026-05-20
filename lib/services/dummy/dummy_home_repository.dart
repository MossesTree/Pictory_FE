import 'package:picktory/models/home_feed.dart';
import 'package:picktory/services/dummy/dummy_data_provider.dart';
import 'package:picktory/services/home_repository.dart';
import 'package:picktory/services/user_preference_repository.dart';

class DummyHomeRepository implements HomeRepository {
  DummyHomeRepository({
    required UserPreferenceRepository userPreferenceRepository,
  }) : _userPreferenceRepository = userPreferenceRepository;

  final UserPreferenceRepository _userPreferenceRepository;

  @override
  Future<HomeFeed> fetchFeed({Set<String>? programIds}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final preference = await _userPreferenceRepository.load();
    final ids = programIds ?? preference.selectedProgramIds;
    final nickname = preference.profile?.nickname ?? '강아지';
    final displayName = '$nickname#123';

    if (ids.isEmpty) {
      return HomeFeed(
        nickname: displayName,
        points: 0,
        hasUnreadNotifications: false,
        adBanners: DummyDataProvider.adBanners,
        heroMissions: const [],
        activeMissions: const [],
        results: const [],
        hasInterestPrograms: false,
      );
    }

    return HomeFeed(
      nickname: displayName,
      points: 2450,
      hasUnreadNotifications: true,
      adBanners: DummyDataProvider.adBanners,
      heroMissions: DummyDataProvider.heroMissions,
      activeMissions: DummyDataProvider.activeMissions,
      results: DummyDataProvider.missionResults,
      hasInterestPrograms: true,
      inlineAdTitle: '트로트스타 LOL 1위',
    );
  }
}
