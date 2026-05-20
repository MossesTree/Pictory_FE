import 'package:picktory/models/ranking_badge.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/models/ranking_growth_record.dart';
import 'package:picktory/models/ranking_my_summary.dart';
import 'package:picktory/models/ranking_period.dart';
import 'package:picktory/models/ranking_profile_preview.dart';
import 'package:picktory/models/ranking_rank_change.dart';

class DummyRankingData {
  DummyRankingData._();

  static const currentUserId = 'user_me';
  static const currentUserNickname = '나의닉네임';

  static const seasonPeriods = [
    RankingPeriodOption(
      id: 'season_2024_1',
      label: '2024 시즌 1',
      subtitle: '종료까지 14일',
      isDefault: true,
    ),
    RankingPeriodOption(
      id: 'season_2023_4',
      label: '2023 시즌 4',
      subtitle: '종료',
    ),
  ];

  static const overallPeriods = [
    RankingPeriodOption(
      id: 'overall_all',
      label: '누적 전체',
      subtitle: '전체 기간 합산',
      isDefault: true,
    ),
  ];

  static const communityPeriods = [
    RankingPeriodOption(
      id: 'community_this_month',
      label: '이번 달',
      isDefault: true,
    ),
    RankingPeriodOption(id: 'community_last_month', label: '지난달'),
  ];

  static List<RankingPodiumEntry> seasonPodium() => const [
        RankingPodiumEntry(
          rank: 2,
          userId: 'u2',
          nickname: '예능러버88',
          badge: RankingBadge.master,
          score: 1720,
        ),
        RankingPodiumEntry(
          rank: 1,
          userId: 'u1',
          nickname: '메뉴직',
          badge: RankingBadge.legend,
          score: 1820,
          isFirst: true,
        ),
        RankingPodiumEntry(
          rank: 3,
          userId: 'u3',
          nickname: '별빛이용자',
          badge: RankingBadge.gold,
          score: 1680,
        ),
      ];

  static List<RankingEntry> seasonEntriesPage(int page) {
    final all = [
      _entry(4, 'u4', '독점포지', RankingBadge.silver, 1720,
          const RankingRankChangeUp(2)),
      _entry(5, 'u5', '촉녀123', RankingBadge.silver, 1650,
          const RankingRankChangeNone()),
      _entry(6, 'u6', '예능중독자', RankingBadge.bronze, 1580,
          const RankingRankChangeDown(1)),
      _entry(7, 'u7', '드라마퀸', RankingBadge.bronze, 1520,
          const RankingRankChangeUp(1)),
    ];
    const pageSize = 3;
    final start = page * pageSize;
    if (start >= all.length) {
      return [];
    }
    return all.sublist(start, (start + pageSize).clamp(0, all.length));
  }

  static RankingMySummary seasonMySummary() => const RankingMySummary(
        rank: 12,
        nickname: currentUserNickname,
        badge: RankingBadge.gold,
        score: 300,
        rankChange: RankingRankChangeUp(2),
        currentTierName: '꼬마토리 2',
        nextTierName: '꼬마토리 3',
        pointsToNextTier: 15,
        tierProgressCurrent: 280,
        tierProgressMax: 600,
        topPercentile: 11,
        seasonRemainingPoints: 100,
      );

  static List<RankingPodiumEntry> communityPodium() => const [
        RankingPodiumEntry(
          rank: 2,
          userId: 'c2',
          nickname: '댓글왕유저',
          badge: RankingBadge.master,
          score: 320,
          communityTitle: '댓글왕',
          usePointsUnit: false,
        ),
        RankingPodiumEntry(
          rank: 1,
          userId: 'c1',
          nickname: '글쓰기킹',
          badge: RankingBadge.legend,
          score: 450,
          isFirst: true,
          communityTitle: '글쓰기왕',
          usePointsUnit: false,
        ),
        RankingPodiumEntry(
          rank: 3,
          userId: 'c3',
          nickname: '공유마스터',
          badge: RankingBadge.gold,
          score: 280,
          communityTitle: '공유왕',
          usePointsUnit: false,
        ),
      ];

  static List<RankingEntry> communityEntriesPage(int page) {
    final all = [
      _entry(4, 'c4', '미션덕후', RankingBadge.silver, 240,
          const RankingRankChangeUp(3), usePointsUnit: false),
      _entry(5, 'c5', '스포왕', RankingBadge.bronze, 210,
          const RankingRankChangeNone(), usePointsUnit: false),
    ];
    const pageSize = 3;
    final start = page * pageSize;
    if (start >= all.length) {
      return [];
    }
    return all.sublist(start, (start + pageSize).clamp(0, all.length));
  }

  static RankingMySummary communityMySummary() => const RankingMySummary(
        rank: 7,
        nickname: currentUserNickname,
        badge: RankingBadge.gold,
        score: 120,
        rankChange: RankingRankChangeUp(5),
        usePointsUnit: false,
        footerMessage: '내 커뮤니티 순위 · 상위 18%',
        postCount: 3,
        commentCount: 24,
        missionCount: 1,
        activitySummaryLabel: '이번 달 활동',
      );

  static RankingMySummary overallMySummary() => const RankingMySummary(
        rank: 12,
        nickname: currentUserNickname,
        badge: RankingBadge.gold,
        score: 520,
        rankChange: RankingRankChangeUp(1),
        currentTierName: '꼬마토리 2',
        nextTierName: '꼬마토리 3',
        pointsToNextTier: 80,
        tierProgressCurrent: 520,
        tierProgressMax: 600,
      );

  static RankingProfilePreview profileFor(String userId) {
    final isMe = userId == currentUserId;
    return RankingProfilePreview(
      userId: userId,
      nickname: isMe ? currentUserNickname : '메뉴직',
      subtitle: isMe ? '꼬마토리 2 · 시즌 9위' : '부캐릭터리그 시즌 2위',
      knowledgePoints: isMe ? 285 : 1820,
      activityPoints: isMe ? 90 : 4302,
      accuracyPercent: isMe ? 76 : 87,
      isCurrentUser: isMe,
    );
  }

  static RankingGrowthRecord growthRecord() => const RankingGrowthRecord(
        currentTierName: '꼬마토리 2',
        currentPoints: 500,
        tierMinPoints: 300,
        tierMaxPoints: 600,
        steps: [
          GrowthTierStep(
            name: '씨앗토리',
            minPoints: 0,
            maxPoints: 100,
            status: GrowthTierStatus.completed,
          ),
          GrowthTierStep(
            name: '아기토리',
            minPoints: 100,
            maxPoints: 300,
            status: GrowthTierStatus.completed,
          ),
          GrowthTierStep(
            name: '꼬마토리',
            minPoints: 300,
            maxPoints: 600,
            status: GrowthTierStatus.inProgress,
          ),
          GrowthTierStep(
            name: '사춘기토리',
            minPoints: 600,
            maxPoints: 1000,
            status: GrowthTierStatus.locked,
          ),
          GrowthTierStep(
            name: '어른토리',
            minPoints: 1000,
            maxPoints: null,
            status: GrowthTierStatus.locked,
          ),
        ],
      );

  static RankingEntry _entry(
    int rank,
    String userId,
    String nickname,
    RankingBadge badge,
    int score,
    RankingRankChange change, {
    bool usePointsUnit = true,
  }) {
    return RankingEntry(
      rank: rank,
      userId: userId,
      nickname: nickname,
      badge: badge,
      score: score,
      rankChange: change,
      usePointsUnit: usePointsUnit,
    );
  }
}
