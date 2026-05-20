import 'package:picktory/models/ranking_badge.dart';
import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/models/ranking_my_summary.dart';
import 'package:picktory/models/ranking_period.dart';
import 'package:picktory/models/ranking_profile_preview.dart';
import 'package:picktory/models/ranking_rank_change.dart';

class DummyRankingData {
  DummyRankingData._();

  static const currentUserId = 'user_me';
  static const currentUserNickname = '강아지#123';

  static const seasonPeriods = [
    RankingPeriodOption(
      id: 'season_hs4',
      label: '환승연애4 시즌',
      subtitle: '2024.03.01 ~ 04.30 · 종료까지 12일',
      isDefault: true,
    ),
    RankingPeriodOption(
      id: 'season_hs3',
      label: '환승연애3 시즌',
      subtitle: '2023.09.01 ~ 11.30 · 종료',
    ),
    RankingPeriodOption(
      id: 'season_running',
      label: '런닝맨 시즌',
      subtitle: '2024.04.01 ~ 진행 중',
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
    RankingPeriodOption(id: 'community_all', label: '전체 기간'),
  ];

  static const activityScoreFormula =
      '활동 점수: 글 작성 +30 · 댓글 +10 · 미션 생성 +50';

  static List<RankingPodiumEntry> seasonPodium() => const [
        RankingPodiumEntry(
          rank: 2,
          userId: 'u2',
          nickname: '예능러버88',
          badge: RankingBadge.master,
          score: 4820,
        ),
        RankingPodiumEntry(
          rank: 1,
          userId: 'u1',
          nickname: '미션마스터',
          badge: RankingBadge.legend,
          score: 6240,
          isFirst: true,
        ),
        RankingPodiumEntry(
          rank: 3,
          userId: 'u3',
          nickname: '별빛이용자',
          badge: RankingBadge.gold,
          score: 3960,
        ),
      ];

  static List<RankingEntry> seasonEntriesPage(int page) {
    final all = [
      _entry(4, 'u4', 'K드라마덕후', RankingBadge.silver, 3480,
          const RankingRankChangeUp(2)),
      _entry(5, 'u5', '촉녀123', RankingBadge.silver, 3200,
          const RankingRankChangeNone()),
      _entry(6, 'u6', '예능중독자', RankingBadge.bronze, 2940,
          const RankingRankChangeDown(1)),
      _entry(7, 'u7', '드라마퀸', RankingBadge.bronze, 2780,
          const RankingRankChangeUp(1)),
      _entry(8, 'u8', '스포방지', RankingBadge.bronze, 2650,
          const RankingRankChangeNone()),
      _entry(9, 'u9', '예측왕', RankingBadge.bronze, 2510,
          const RankingRankChangeDown(2)),
      _entry(10, 'u10', '팬덤러버', RankingBadge.bronze, 2400,
          const RankingRankChangeUp(3)),
    ];
    const pageSize = 3;
    final start = page * pageSize;
    if (start >= all.length) {
      return [];
    }
    final end = (start + pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }

  static RankingMySummary seasonMySummary() => const RankingMySummary(
        rank: 42,
        nickname: currentUserNickname,
        badge: RankingBadge.gold,
        score: 2240,
        rankChange: RankingRankChangeUp(8),
        topPercentTarget: 10,
        stepsToTopPercent: 8,
        accuracyPercent: 76,
      );

  static List<RankingPodiumEntry> communityPodium() => const [
        RankingPodiumEntry(
          rank: 2,
          userId: 'c2',
          nickname: '커뮤왕123',
          badge: RankingBadge.master,
          score: 2340,
        ),
        RankingPodiumEntry(
          rank: 1,
          userId: 'c1',
          nickname: '예능덕질러',
          badge: RankingBadge.silver,
          score: 3180,
          isFirst: true,
        ),
        RankingPodiumEntry(
          rank: 3,
          userId: 'c3',
          nickname: '글쟁이팬',
          badge: RankingBadge.gold,
          score: 1980,
        ),
      ];

  static List<RankingEntry> communityEntriesPage(int page) {
    final all = [
      _entry(4, 'c4', '미션덕후', RankingBadge.silver, 1740,
          const RankingRankChangeUp(3)),
      _entry(5, 'c5', '스포왕', RankingBadge.bronze, 1520,
          const RankingRankChangeNone()),
      _entry(6, 'c6', '토론왕', RankingBadge.bronze, 1380,
          const RankingRankChangeDown(1)),
    ];
    const pageSize = 3;
    final start = page * pageSize;
    if (start >= all.length) {
      return [];
    }
    final end = (start + pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }

  static RankingMySummary communityMySummary() => const RankingMySummary(
        rank: 28,
        nickname: currentUserNickname,
        badge: RankingBadge.gold,
        score: 890,
        rankChange: RankingRankChangeUp(5),
        postCount: 3,
        commentCount: 24,
        missionCount: 1,
        activitySummaryLabel: '이번 달 활동 내역',
      );

  static RankingProfilePreview profileFor(String userId) {
    final isMe = userId == currentUserId;
    return RankingProfilePreview(
      userId: userId,
      nickname: isMe ? currentUserNickname : '미션마스터',
      highestBadge: RankingBadge.legend,
      seasonRankLabel: isMe ? '시즌 42위' : '시즌 1위',
      overallRankLabel: isMe ? '전체 156위' : '전체 8위',
      accuracyPercent: isMe ? 76 : 96,
      participatedMissionCount: isMe ? 128 : 284,
      seasonScore: isMe ? 2240 : 6240,
      seasonRankDetail: isMe ? '42위 / 4,821명' : '1위 / 4,821명',
      streakLabel: isMe ? '🔥 3연속' : '🔥 8연속',
      rankChangeLabel: isMe ? '↑ 8계단 상승' : '↑ 3계단 상승',
      bestProgramLabel: '환승연애4',
      earnedPointsLabel: isMe ? '+2,480 포인트' : '+12,480 포인트',
      ownedBadges: const [
        RankingSpecialBadge.legend,
        RankingSpecialBadge.accuracyKing,
      ],
      lockedBadges: const [RankingSpecialBadge.seasonComplete],
      isCurrentUser: isMe,
    );
  }

  static RankingEntry _entry(
    int rank,
    String userId,
    String nickname,
    RankingBadge badge,
    int score,
    RankingRankChange change,
  ) {
    return RankingEntry(
      rank: rank,
      userId: userId,
      nickname: nickname,
      badge: badge,
      score: score,
      rankChange: change,
    );
  }
}
