import 'package:picktory/models/community_post_kind.dart';
import 'package:picktory/models/my_community_activity.dart';
import 'package:picktory/models/my_page_summary.dart';
import 'package:picktory/models/notification_settings.dart';
import 'package:picktory/models/pick_history_item.dart';
import 'package:picktory/models/special_badge.dart';
import 'package:picktory/services/my_repository.dart';
import 'package:picktory/services/user_preference_repository.dart';

class DummyMyRepository implements MyRepository {
  DummyMyRepository({
    required UserPreferenceRepository userPreferenceRepository,
  }) : _userPreferenceRepository = userPreferenceRepository;

  final UserPreferenceRepository _userPreferenceRepository;

  NotificationSettings _notificationSettings = const NotificationSettings();

  /// IA MY-2: 미션 픽 기록 (정답/오답/대기)
  static const _pickHistory = [
    PickHistoryItem(
      id: 'ph-1',
      missionId: 'm-101',
      title: '환승연애4 5회 마지막 커플',
      timeLabel: '05.14 10:30',
      points: 120,
      result: PickHistoryResult.correct,
    ),
    PickHistoryItem(
      id: 'ph-2',
      missionId: 'm-102',
      title: '나는솔로 10기 최종 커플',
      timeLabel: '05.13 18:20',
      points: 80,
      result: PickHistoryResult.correct,
    ),
    PickHistoryItem(
      id: 'ph-3',
      missionId: 'm-103',
      title: '피지컬:100 우승자 예측',
      timeLabel: '05.12 09:00',
      points: 0,
      result: PickHistoryResult.incorrect,
    ),
    PickHistoryItem(
      id: 'ph-4',
      missionId: 'm-104',
      title: '아이돌 서바이벌 TOP3',
      timeLabel: '05.10 21:15',
      points: 0,
      result: PickHistoryResult.pending,
    ),
  ];

  @override
  Future<MyPageSummary> fetchSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final preference = await _userPreferenceRepository.load();
    final nickname = preference.profile?.nickname ?? '나의닉네임';
    return MyPageSummary(
      nickname: nickname,
      tierLabel: '프리티어 2',
      tierEmoji: '🌱',
      tierProgress: 0.42,
      seasonRanking: 24,
      totalRanking: 9,
      communityRanking: 12,
      accumulatedPoints: 12480,
      currentPoints: 520,
      ticketCount: 2,
      inviteCode: 'PCK4F2X',
    );
  }

  @override
  Future<void> updateNickname(String nickname) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final preference = await _userPreferenceRepository.load();
    final profile = preference.profile;
    if (profile == null) {
      return;
    }
    await _userPreferenceRepository.save(
      preference.copyWith(
        profile: profile.copyWith(nickname: nickname),
      ),
    );
  }

  @override
  Future<List<PickHistoryItem>> fetchPickHistory(
    PickHistoryFilter filter,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (filter == PickHistoryFilter.all) {
      return _pickHistory;
    }
    final target = switch (filter) {
      PickHistoryFilter.correct => PickHistoryResult.correct,
      PickHistoryFilter.incorrect => PickHistoryResult.incorrect,
      PickHistoryFilter.pending => PickHistoryResult.pending,
      PickHistoryFilter.all => PickHistoryResult.correct,
    };
    return _pickHistory.where((item) => item.result == target).toList();
  }

  @override
  Future<List<MyCommunityPostItem>> fetchMyPosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const [
      MyCommunityPostItem(
        id: 'post-2',
        title: '공유한 미션: 5화 마지막 커플',
        timeLabel: '5시간 전',
        likeCount: 18,
        commentCount: 3,
        kind: CommunityPostKind.userMission,
      ),
      MyCommunityPostItem(
        id: 'post-mine-1',
        title: '무료코스 시흥2구역 다들 같이 갈래요?',
        timeLabel: '어제',
        likeCount: 7,
        commentCount: 2,
        kind: CommunityPostKind.thread,
      ),
      MyCommunityPostItem(
        id: 'post-mine-2',
        title: '인기 솔로 시즌 우승자 예측',
        timeLabel: '2일 전',
        likeCount: 21,
        commentCount: 9,
        kind: CommunityPostKind.userPoll,
      ),
    ];
  }

  @override
  Future<List<MyCommunityCommentItem>> fetchMyComments() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const [
      MyCommunityCommentItem(
        id: 'cmt-3',
        postId: 'post-3',
        postTitle: '5화 봤어요?? 수지 선택 예상했는데...',
        content: '결과 나오면 공유할게요',
        timeLabel: '1시간 전',
        likeCount: 0,
      ),
      MyCommunityCommentItem(
        id: 'cmt-2',
        postId: 'post-4',
        postTitle: '5화 마지막 커플 예측',
        content: '현준 라인 설득력 있네요',
        timeLabel: '30분 전',
        likeCount: 1,
      ),
    ];
  }

  @override
  Future<List<SpecialBadge>> fetchSpecialBadges() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const [
      SpecialBadge(id: 'b1', label: '열정러', iconEmoji: '🔥', isEarned: true),
      SpecialBadge(id: 'b2', label: '산책러', iconEmoji: '⚡', isEarned: true),
      SpecialBadge(id: 'b3', label: '나눔러', iconEmoji: '🚶', isEarned: true),
      SpecialBadge(
        id: 'b4',
        label: '클린유저',
        iconEmoji: '✓',
        isEarned: false,
      ),
    ];
  }

  @override
  Future<NotificationSettings> fetchNotificationSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _notificationSettings;
  }

  @override
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _notificationSettings = settings;
  }
}
