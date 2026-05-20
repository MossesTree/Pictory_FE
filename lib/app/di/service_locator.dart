import 'package:picktory/services/auth_repository.dart';
import 'package:picktory/services/community_repository.dart';
import 'package:picktory/services/dummy/dummy_auth_repository.dart';
import 'package:picktory/services/dummy/dummy_community_repository.dart';
import 'package:picktory/services/dummy/dummy_home_repository.dart';
import 'package:picktory/services/dummy/dummy_signup_repository.dart';
import 'package:picktory/services/dummy/dummy_story_repository.dart';
import 'package:picktory/services/dummy/dummy_tv_program_repository.dart';
import 'package:picktory/services/dummy/dummy_user_preference_repository.dart';
import 'package:picktory/services/dummy/dummy_ranking_repository.dart';
import 'package:picktory/services/home_repository.dart';
import 'package:picktory/services/ranking_repository.dart';
import 'package:picktory/services/signup_repository.dart';
import 'package:picktory/services/story_repository.dart';
import 'package:picktory/services/tv_program_repository.dart';
import 'package:picktory/services/user_preference_repository.dart';
import 'package:picktory/viewmodels/community_feed_view_model.dart';
import 'package:picktory/viewmodels/home_view_model.dart';
import 'package:picktory/viewmodels/ranking_view_model.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  late final AuthRepository authRepository;
  late final SignupRepository signupRepository;
  late final CommunityRepository communityRepository;
  late final HomeRepository homeRepository;
  late final RankingRepository rankingRepository;
  late final StoryRepository storyRepository;
  late final TvProgramRepository tvProgramRepository;
  late final UserPreferenceRepository userPreferenceRepository;
  late final HomeViewModel homeViewModel;
  late final CommunityFeedViewModel communityFeedViewModel;
  late final RankingViewModel rankingViewModel;

  void init() {
    authRepository = DummyAuthRepository();
    userPreferenceRepository = DummyUserPreferenceRepository();
    signupRepository = DummySignupRepository(
      userPreferenceRepository: userPreferenceRepository,
    );
    communityRepository = DummyCommunityRepository();
    homeRepository = DummyHomeRepository(
      userPreferenceRepository: userPreferenceRepository,
    );
    rankingRepository = DummyRankingRepository();
    storyRepository = DummyStoryRepository();
    tvProgramRepository = DummyTvProgramRepository();
    homeViewModel = HomeViewModel(
      homeRepository: homeRepository,
      userPreferenceRepository: userPreferenceRepository,
    );
    communityFeedViewModel = CommunityFeedViewModel(
      communityRepository: communityRepository,
    );
    rankingViewModel = RankingViewModel(
      rankingRepository: rankingRepository,
    );
  }
}
