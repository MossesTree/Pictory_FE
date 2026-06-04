import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/community_post_kind.dart';
import 'package:picktory/models/report_reason.dart';
import 'package:picktory/viewmodels/benefit_ad_watch_view_model.dart';
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
import 'package:picktory/viewmodels/mission_detail_view_model.dart';
import 'package:picktory/viewmodels/mission_result_view_model.dart';
import 'package:picktory/viewmodels/mission_share_view_model.dart';
import 'package:picktory/viewmodels/my_community_activity_view_model.dart';
import 'package:picktory/viewmodels/my_interested_programs_view_model.dart';
import 'package:picktory/viewmodels/my_pick_history_view_model.dart';
import 'package:picktory/viewmodels/my_special_badges_view_model.dart';
import 'package:picktory/viewmodels/notification_settings_view_model.dart';
import 'package:picktory/viewmodels/notification_view_model.dart';
import 'package:picktory/viewmodels/story_detail_view_model.dart';
import 'package:picktory/viewmodels/user_mission_detail_view_model.dart';
import 'package:picktory/views/account/find_id_view.dart';
import 'package:picktory/views/account/reset_password_view.dart';
import 'package:picktory/views/community/community_compose_view.dart';
import 'package:picktory/views/community/community_feed_view.dart';
import 'package:picktory/views/community/community_post_detail_view.dart';
import 'package:picktory/views/community/community_report_view.dart';
import 'package:picktory/views/community/mission_suggest_view.dart';
import 'package:picktory/views/community/user_mission_detail_view.dart';
import 'package:picktory/views/home/home_view.dart';
import 'package:picktory/views/login/login_view.dart';
import 'package:picktory/views/shell/main_shell_view.dart';
import 'package:picktory/views/ranking/ranking_growth_record_view.dart';
import 'package:picktory/views/ranking/ranking_view.dart';
import 'package:picktory/views/benefits/benefit_ad_watch_view.dart';
import 'package:picktory/views/benefits/benefit_mini_games_view.dart';
import 'package:picktory/views/benefits/benefits_view.dart';
import 'package:picktory/views/signup/complete_view.dart';
import 'package:picktory/views/signup/invite_code_view.dart';
import 'package:picktory/views/signup/profile_setup_view.dart';
import 'package:picktory/views/signup/program_selection_view.dart';
import 'package:picktory/views/signup/terms_view.dart';
import 'package:picktory/views/splash/splash_view.dart';
import 'package:picktory/views/mission/mission_detail_view.dart';
import 'package:picktory/views/mission/mission_result_view.dart';
import 'package:picktory/views/mission/mission_share_complete_view.dart';
import 'package:picktory/views/mission/mission_share_view.dart';
import 'package:picktory/views/my/my_community_activity_view.dart';
import 'package:picktory/views/my/my_interested_programs_view.dart';
import 'package:picktory/views/my/my_pick_history_view.dart';
import 'package:picktory/views/my/my_special_badges_view.dart';
import 'package:picktory/views/my/my_view.dart';
import 'package:picktory/views/my/notification_settings_view.dart';
import 'package:picktory/views/my/settings_view.dart';
import 'package:picktory/views/my/widgets/static_document_view.dart';
import 'package:picktory/views/notification/notification_view.dart';
import 'package:picktory/views/story_detail/story_detail_view.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final RouteObserver<PageRoute<void>> routeObserver =
      RouteObserver<PageRoute<void>>();

  static GoRouter create() {
    final locator = ServiceLocator.instance;

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
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShellView(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.home.path,
                  pageBuilder: (context, state) => _tabPage(
                    state: state,
                    child: HomeView(viewModel: locator.homeViewModel),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.ranking.path,
                  pageBuilder: (context, state) => _tabPage(
                    state: state,
                    child: RankingView(viewModel: locator.rankingViewModel),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.community.path,
                  pageBuilder: (context, state) => _tabPage(
                    state: state,
                    child: CommunityFeedView(
                      viewModel: locator.communityFeedViewModel,
                    ),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.benefits.path,
                  pageBuilder: (context, state) => _tabPage(
                    state: state,
                    child: BenefitsView(viewModel: locator.benefitViewModel),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.my.path,
                  pageBuilder: (context, state) => _tabPage(
                    state: state,
                    child: MyView(viewModel: locator.myViewModel),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoute.communityPost.path,
          parentNavigatorKey: rootNavigatorKey,
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
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final editId = state.uri.queryParameters['editId'];
            final kindParam = state.uri.queryParameters['kind'];
            final initialKind = CommunityPostKind.values.firstWhere(
              (k) => k.name == kindParam,
              orElse: () => CommunityPostKind.thread,
            );
            return CommunityComposeView(
              viewModel: CommunityComposeViewModel(
                communityRepository: locator.communityRepository,
                editPostId: editId,
                initialKind: initialKind,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.communityMissionSuggest.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => MissionSuggestView(
            viewModel: MissionSuggestViewModel(
              communityRepository: locator.communityRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.communityReport.path,
          parentNavigatorKey: rootNavigatorKey,
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
        // IA C-5: 유저미션 생성은 통합 글 작성 화면을 userMission 종류로 진입
        GoRoute(
          path: AppRoute.userMissionCreate.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => CommunityComposeView(
            viewModel: CommunityComposeViewModel(
              communityRepository: locator.communityRepository,
              initialKind: CommunityPostKind.userMission,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.userMissionDetail.path,
          parentNavigatorKey: rootNavigatorKey,
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
          parentNavigatorKey: rootNavigatorKey,
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
        GoRoute(
          path: AppRoute.missionDetail.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final missionId = state.pathParameters['id']!;
            return MissionDetailView(
              viewModel: MissionDetailViewModel(
                missionId: missionId,
                missionRepository: locator.missionRepository,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.missionResult.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final missionId = state.pathParameters['id']!;
            return MissionResultView(
              viewModel: MissionResultViewModel(
                missionId: missionId,
                missionRepository: locator.missionRepository,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.missionShare.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final missionId = state.pathParameters['id']!;
            return MissionShareView(
              viewModel: MissionShareViewModel(
                missionId: missionId,
                missionRepository: locator.missionRepository,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.missionShareComplete.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final missionId = state.pathParameters['id'];
            return MissionShareCompleteView(missionId: missionId);
          },
        ),
        GoRoute(
          path: AppRoute.notifications.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => NotificationView(
            viewModel: NotificationViewModel(
              notificationRepository: locator.notificationRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.benefitsAdWatch.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final rewardPicks = state.extra is int ? state.extra! as int : 3;
            return BenefitAdWatchView(
              viewModel: BenefitAdWatchViewModel(rewardPicks: rewardPicks),
              rewardPicks: rewardPicks,
            );
          },
        ),
        GoRoute(
          path: AppRoute.benefitsMiniGames.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const BenefitMiniGamesView(),
        ),
        GoRoute(
          path: AppRoute.rankingGrowth.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => RankingGrowthRecordView(
            viewModel: locator.rankingGrowthViewModel,
          ),
        ),
        GoRoute(
          path: AppRoute.myPickHistory.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => MyPickHistoryView(
            viewModel: MyPickHistoryViewModel(
              myRepository: locator.myRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.myCommunityActivity.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => MyCommunityActivityView(
            viewModel: MyCommunityActivityViewModel(
              myRepository: locator.myRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.myBadges.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => MySpecialBadgesView(
            viewModel: MySpecialBadgesViewModel(
              myRepository: locator.myRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.myInterestedPrograms.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => MyInterestedProgramsView(
            viewModel: MyInterestedProgramsViewModel(
              userPreferenceRepository: locator.userPreferenceRepository,
              tvProgramRepository: locator.tvProgramRepository,
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.settings.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const SettingsView(),
        ),
        GoRoute(
          path: AppRoute.notificationSettings.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => NotificationSettingsView(
            viewModel: NotificationSettingsViewModel(
              myRepository: locator.myRepository,
            ),
          ),
        ),
        // IA S-1 정적 페이지들 (공지/문의/약관/처리방침)
        GoRoute(
          path: AppRoute.settingsNotices.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const StaticDocumentView(
            title: '공지사항',
            sections: [
              StaticDocumentSection(
                heading: '시즌 1 오픈 안내',
                body: '픽토리 시즌 1이 오픈되었어요. 매주 새 미션과 결과 공개가 이루어집니다.',
              ),
              StaticDocumentSection(
                heading: '이벤트 진행 중',
                body: '시즌 1 랭킹 이벤트가 진행 중입니다. 1등에게 100,000 Pick이 지급됩니다.',
              ),
            ],
          ),
        ),
        GoRoute(
          path: AppRoute.settingsInquiry.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const StaticDocumentView(
            title: '문의하기',
            sections: [
              StaticDocumentSection(
                heading: '문의 채널',
                body: '서비스 이용 중 불편 사항이나 제안은 아래로 보내주세요.\n\nE-mail: support@picktory.app',
              ),
              StaticDocumentSection(
                heading: '응답 시간',
                body: '평일 09:00 ~ 18:00 (주말·공휴일 제외) 영업일 기준 2일 내 답변드립니다.',
              ),
            ],
          ),
        ),
        GoRoute(
          path: AppRoute.settingsTerms.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const StaticDocumentView(
            title: '서비스 이용약관',
            sections: [
              StaticDocumentSection(
                heading: '제1조 목적',
                body: '본 약관은 픽토리(이하 "서비스")의 이용과 관련하여 회사와 회원 간의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.',
              ),
              StaticDocumentSection(
                heading: '제2조 용어 정의',
                body: '"회원"이라 함은 본 약관에 동의하고 서비스를 이용하는 자를 의미합니다.',
              ),
            ],
          ),
        ),
        GoRoute(
          path: AppRoute.settingsPrivacy.path,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const StaticDocumentView(
            title: '개인정보 처리방침',
            sections: [
              StaticDocumentSection(
                heading: '수집 항목',
                body: '소셜 로그인 식별자, 닉네임, 프로필 이미지, 성별, 생년월일을 수집합니다.',
              ),
              StaticDocumentSection(
                heading: '이용 목적',
                body: '회원 식별, 서비스 제공, 통계 분석, 부정 이용 방지에 활용됩니다.',
              ),
              StaticDocumentSection(
                heading: '보관 기간',
                body: '회원 탈퇴 시 즉시 파기됩니다. 단, 관련 법령에 의거 일정 기간 보관이 필요한 정보는 해당 법령에 따릅니다.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  static NoTransitionPage<void> _tabPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: child,
    );
  }
}
