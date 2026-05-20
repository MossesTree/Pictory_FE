import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/main_tab_navigation.dart';
import 'package:picktory/models/report_reason.dart';
import 'package:picktory/viewmodels/community_compose_view_model.dart';
import 'package:picktory/viewmodels/community_post_detail_view_model.dart';
import 'package:picktory/viewmodels/community_report_view_model.dart';
import 'package:picktory/viewmodels/find_id_view_model.dart';
import 'package:picktory/viewmodels/invite_code_view_model.dart';
import 'package:picktory/viewmodels/login_view_model.dart';
import 'package:picktory/viewmodels/mission_suggest_view_model.dart';
import 'package:picktory/viewmodels/onboarding_complete_view_model.dart';
import 'package:picktory/viewmodels/profile_setup_view_model.dart';
import 'package:picktory/viewmodels/program_selection_view_model.dart';
import 'package:picktory/viewmodels/reset_password_view_model.dart';
import 'package:picktory/viewmodels/splash_view_model.dart';
import 'package:picktory/viewmodels/terms_view_model.dart';
import 'package:picktory/viewmodels/story_detail_view_model.dart';
import 'package:picktory/viewmodels/user_mission_create_view_model.dart';
import 'package:picktory/viewmodels/user_mission_detail_view_model.dart';
import 'package:picktory/views/account/find_id_view.dart';
import 'package:picktory/views/account/reset_password_view.dart';
import 'package:picktory/views/community/community_compose_view.dart';
import 'package:picktory/views/community/community_feed_view.dart';
import 'package:picktory/views/community/community_post_detail_view.dart';
import 'package:picktory/views/community/community_report_view.dart';
import 'package:picktory/views/community/mission_suggest_view.dart';
import 'package:picktory/views/community/user_mission_create_view.dart';
import 'package:picktory/views/community/user_mission_detail_view.dart';
import 'package:picktory/views/home/home_view.dart';
import 'package:picktory/views/login/login_view.dart';
import 'package:picktory/views/shell/main_tab.dart';
import 'package:picktory/views/shell/placeholder_tab_view.dart';
import 'package:picktory/views/signup/complete_view.dart';
import 'package:picktory/views/signup/invite_code_view.dart';
import 'package:picktory/views/signup/profile_setup_view.dart';
import 'package:picktory/views/signup/program_selection_view.dart';
import 'package:picktory/views/signup/terms_view.dart';
import 'package:picktory/views/splash/splash_view.dart';
import 'package:picktory/views/story_detail/story_detail_view.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final RouteObserver<PageRoute<void>> routeObserver =
      RouteObserver<PageRoute<void>>();

  static GoRouter create() {
    final locator = ServiceLocator.instance;

    void onTabSelected(BuildContext context, MainTab tab) {
      navigateMainTab(context, tab);
    }

    return GoRouter(
      navigatorKey: rootNavigatorKey,
      observers: [routeObserver],
      initialLocation: AppRoute.splash.path,
      routes: [
        GoRoute(
          path: AppRoute.splash.path,
          builder: (context, state) => SplashView(
            viewModel: SplashViewModel(
              authRepository: locator.authRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.login.path,
          builder: (context, state) => LoginView(
            viewModel: LoginViewModel(
              authRepository: locator.authRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.signupTerms.path,
          builder: (context, state) => TermsView(
            viewModel: TermsViewModel(
              signupRepository: locator.signupRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.signupProfile.path,
          builder: (context, state) => ProfileSetupView(
            viewModel: ProfileSetupViewModel(
              signupRepository: locator.signupRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.signupPrograms.path,
          builder: (context, state) => ProgramSelectionView(
            viewModel: ProgramSelectionViewModel(
              signupRepository: locator.signupRepository,
              tvProgramRepository: locator.tvProgramRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.signupInvite.path,
          builder: (context, state) => InviteCodeView(
            viewModel: InviteCodeViewModel(
              signupRepository: locator.signupRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.signupComplete.path,
          builder: (context, state) => OnboardingCompleteView(
            viewModel: OnboardingCompleteViewModel(
              signupRepository: locator.signupRepository,
              authRepository: locator.authRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.findId.path,
          builder: (context, state) => FindIdView(
            viewModel: FindIdViewModel(),
          ),
        ),
        GoRoute(
          path: AppRoute.resetPassword.path,
          builder: (context, state) => ResetPasswordView(
            viewModel: ResetPasswordViewModel(),
          ),
        ),
        GoRoute(
          path: AppRoute.home.path,
          builder: (context, state) => HomeView(
            viewModel: locator.homeViewModel,
            onTabSelected: (tab) => onTabSelected(context, tab),
          ),
        ),
        GoRoute(
          path: '/ranking',
          builder: (context, state) => PlaceholderTabView(
            tab: MainTab.ranking,
            onTabSelected: (tab) => onTabSelected(context, tab),
          ),
        ),
        GoRoute(
          path: AppRoute.community.path,
          builder: (context, state) => CommunityFeedView(
            viewModel: locator.communityFeedViewModel,
            onTabSelected: (tab) => onTabSelected(context, tab),
          ),
        ),
        GoRoute(
          path: '/benefits',
          builder: (context, state) => PlaceholderTabView(
            tab: MainTab.benefits,
            onTabSelected: (tab) => onTabSelected(context, tab),
          ),
        ),
        GoRoute(
          path: '/my',
          builder: (context, state) => PlaceholderTabView(
            tab: MainTab.my,
            onTabSelected: (tab) => onTabSelected(context, tab),
          ),
        ),
        GoRoute(
          path: AppRoute.communityPost.path,
          builder: (context, state) {
            final postId = state.pathParameters['id']!;
            return CommunityPostDetailView(
              viewModel: CommunityPostDetailViewModel(
                postId: postId,
                communityRepository: locator.communityRepository,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.communityCompose.path,
          builder: (context, state) {
            final editId = state.uri.queryParameters['editId'];
            return CommunityComposeView(
              viewModel: CommunityComposeViewModel(
                communityRepository: locator.communityRepository,
                editPostId: editId,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.communityMissionSuggest.path,
          builder: (context, state) => MissionSuggestView(
            viewModel: MissionSuggestViewModel(
              communityRepository: locator.communityRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.communityReport.path,
          builder: (context, state) {
            final typeName = state.uri.queryParameters['targetType'] ?? 'post';
            final targetId = state.uri.queryParameters['targetId'] ?? '';
            final targetType = ReportTargetType.values.firstWhere(
              (e) => e.name == typeName,
              orElse: () => ReportTargetType.post,
            );
            return CommunityReportView(
              viewModel: CommunityReportViewModel(
                communityRepository: locator.communityRepository,
                targetType: targetType,
                targetId: targetId,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.userMissionCreate.path,
          builder: (context, state) => UserMissionCreateView(
            viewModel: UserMissionCreateViewModel(
              communityRepository: locator.communityRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.userMissionDetail.path,
          builder: (context, state) {
            final missionId = state.pathParameters['id']!;
            return UserMissionDetailView(
              viewModel: UserMissionDetailViewModel(
                missionId: missionId,
                communityRepository: locator.communityRepository,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.storyDetail.path,
          builder: (context, state) {
            final storyId = state.pathParameters['id']!;
            return StoryDetailView(
              viewModel: StoryDetailViewModel(
                storyId: storyId,
                storyRepository: locator.storyRepository,
              ),
            );
          },
        ),
      ],
    );
  }
}
