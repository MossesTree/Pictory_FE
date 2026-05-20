import 'package:picktory/models/community_category.dart';
import 'package:picktory/models/community_comment.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/models/report_reason.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/models/user_mission_choice_stat.dart';
import 'package:picktory/services/community_repository.dart';
import 'package:picktory/services/dummy/dummy_community_data.dart';

class DummyCommunityRepository implements CommunityRepository {
  final List<CommunityPost> _posts =
      List<CommunityPost>.from(DummyCommunityData.posts);
  final Map<String, List<CommunityComment>> _comments = {
    for (final entry in DummyCommunityData.commentsByPost.entries)
      entry.key: List<CommunityComment>.from(entry.value),
  };
  final List<UserMission> _userMissions =
      List<UserMission>.from(DummyCommunityData.userMissions);
  final Set<String> _likedPosts = {};
  final Set<String> _likedComments = {};
  final Set<String> _blockedUsers = {};

  @override
  Future<List<CommunityCategory>> fetchCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return DummyCommunityData.categories;
  }

  @override
  Future<List<CommunityPost>> fetchThreadPosts({String? categoryId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    var results = _posts
        .where((p) => !_blockedUsers.contains(p.authorNickname))
        .toList();
    if (categoryId != null && categoryId != 'all') {
      results = results.where((p) => p.categoryId == categoryId).toList();
    }
    return results;
  }

  @override
  Future<CommunityPost?> fetchPostById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<CommunityComment>> fetchComments(String postId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final list = _comments[postId] ?? [];
    return list
        .where((c) => !_blockedUsers.contains(c.authorNickname))
        .toList();
  }

  @override
  Future<List<UserMission>> fetchUserMissions({
    UserMissionFilter filter = UserMissionFilter.all,
    UserMissionSort sort = UserMissionSort.latest,
    String? categoryId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    var results = List<UserMission>.from(_userMissions);

    if (categoryId != null && categoryId != 'all') {
      results = results.where((m) => m.categoryId == categoryId).toList();
    }

    switch (filter) {
      case UserMissionFilter.active:
        results = results
            .where((m) => m.status == UserMissionStatus.active)
            .toList();
      case UserMissionFilter.closed:
        results = results
            .where((m) => m.status == UserMissionStatus.closed)
            .toList();
      case UserMissionFilter.mine:
        results = results.where((m) => m.isMine).toList();
      case UserMissionFilter.all:
        break;
    }

    switch (sort) {
      case UserMissionSort.popular:
        results.sort(
          (a, b) =>
              (b.likeCount + b.commentCount) - (a.likeCount + a.commentCount),
        );
      case UserMissionSort.participants:
        results.sort((a, b) => b.participantCount - a.participantCount);
      case UserMissionSort.views:
        results.sort((a, b) => b.viewCount - a.viewCount);
      case UserMissionSort.latest:
        break;
    }

    return results;
  }

  @override
  Future<UserMission?> fetchUserMissionById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return _userMissions.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CommunityPost> createPost({
    required String programLabel,
    required String title,
    required String content,
    required bool showNickname,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final post = CommunityPost(
      id: 'post-${DateTime.now().millisecondsSinceEpoch}',
      authorNickname: '강아지#123',
      authorBadge: '미션마스터',
      programLabel: programLabel,
      title: title,
      content: content,
      likeCount: 0,
      commentCount: 0,
      viewCount: 0,
      createdAtLabel: '방금 전',
      isMine: true,
      isAnonymous: !showNickname,
    );
    _posts.insert(0, post);
    _comments[post.id] = [];
    return post;
  }

  @override
  Future<CommunityPost> updatePost({
    required String id,
    required String programLabel,
    required String title,
    required String content,
    required bool showNickname,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _posts.indexWhere((p) => p.id == id);
    if (index < 0) {
      throw StateError('post not found');
    }
    final old = _posts[index];
    final updated = CommunityPost(
      id: id,
      authorNickname: old.authorNickname,
      authorBadge: old.authorBadge,
      programLabel: programLabel,
      title: title,
      content: content,
      likeCount: old.likeCount,
      commentCount: old.commentCount,
      viewCount: old.viewCount,
      createdAtLabel: '${old.createdAtLabel} (수정됨)',
      isMine: true,
      isAnonymous: !showNickname,
      isMissionShare: old.isMissionShare,
      linkedMissionLabel: old.linkedMissionLabel,
      linkedMissionId: old.linkedMissionId,
      categoryId: old.categoryId,
      broadcastDate: old.broadcastDate,
      hasPoll: old.hasPoll,
      pollOptions: old.pollOptions,
    );
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<void> deletePost(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _posts.removeWhere((p) => p.id == id);
    _comments.remove(id);
  }

  @override
  Future<CommunityComment> addComment({
    required String postId,
    required String content,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final comment = CommunityComment(
      id: 'cmt-${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      authorNickname: '강아지#123',
      content: content,
      createdAtLabel: '방금 전',
      likeCount: 0,
      isMine: true,
    );
    _comments.putIfAbsent(postId, () => []).add(comment);
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex >= 0) {
      final post = _posts[postIndex];
      _posts[postIndex] = CommunityPost(
        id: post.id,
        authorNickname: post.authorNickname,
        authorBadge: post.authorBadge,
        programLabel: post.programLabel,
        title: post.title,
        content: post.content,
        likeCount: post.likeCount,
        commentCount: post.commentCount + 1,
        viewCount: post.viewCount,
        createdAtLabel: post.createdAtLabel,
        isMine: post.isMine,
        isAnonymous: post.isAnonymous,
        isMissionShare: post.isMissionShare,
        linkedMissionLabel: post.linkedMissionLabel,
        linkedMissionId: post.linkedMissionId,
        categoryId: post.categoryId,
        broadcastDate: post.broadcastDate,
        hasPoll: post.hasPoll,
        pollOptions: post.pollOptions,
      );
    }
    return comment;
  }

  @override
  Future<void> updateComment({
    required String commentId,
    required String content,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    for (final entry in _comments.entries) {
      final index = entry.value.indexWhere((c) => c.id == commentId);
      if (index >= 0) {
        final old = entry.value[index];
        entry.value[index] = CommunityComment(
          id: old.id,
          postId: old.postId,
          authorNickname: old.authorNickname,
          content: content,
          createdAtLabel: old.createdAtLabel,
          likeCount: old.likeCount,
          isMine: old.isMine,
          isAnonymous: old.isAnonymous,
          isEdited: true,
        );
        return;
      }
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    for (final entry in _comments.entries) {
      final index = entry.value.indexWhere((c) => c.id == commentId);
      if (index >= 0) {
        final old = entry.value[index];
        entry.value[index] = CommunityComment(
          id: old.id,
          postId: old.postId,
          authorNickname: old.authorNickname,
          content: old.content,
          createdAtLabel: old.createdAtLabel,
          likeCount: old.likeCount,
          isMine: old.isMine,
          isAnonymous: old.isAnonymous,
          isDeleted: true,
        );
        return;
      }
    }
  }

  @override
  Future<void> togglePostLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index < 0) {
      return;
    }
    final post = _posts[index];
    final liked = _likedPosts.contains(postId);
    if (liked) {
      _likedPosts.remove(postId);
    } else {
      _likedPosts.add(postId);
    }
    _posts[index] = CommunityPost(
      id: post.id,
      authorNickname: post.authorNickname,
      authorBadge: post.authorBadge,
      programLabel: post.programLabel,
      title: post.title,
      content: post.content,
      likeCount: post.likeCount + (liked ? -1 : 1),
      commentCount: post.commentCount,
      viewCount: post.viewCount,
      createdAtLabel: post.createdAtLabel,
      isMine: post.isMine,
      isAnonymous: post.isAnonymous,
      isMissionShare: post.isMissionShare,
      linkedMissionLabel: post.linkedMissionLabel,
      linkedMissionId: post.linkedMissionId,
      categoryId: post.categoryId,
      broadcastDate: post.broadcastDate,
      hasPoll: post.hasPoll,
      pollOptions: post.pollOptions,
    );
  }

  bool isPostLiked(String postId) => _likedPosts.contains(postId);

  @override
  Future<void> toggleCommentLike(String commentId) async {
    if (_likedComments.contains(commentId)) {
      _likedComments.remove(commentId);
    } else {
      _likedComments.add(commentId);
    }
  }

  @override
  Future<void> blockUser(String nickname) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _blockedUsers.add(nickname);
  }

  @override
  Future<void> submitReport({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? detail,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> submitMissionSuggestion({
    required String title,
    required String programLabel,
    required String episode,
    required String description,
    required List<String> choices,
    String? expectedCloseLabel,
    String? resultSource,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<UserMission> participateUserMission({
    required String missionId,
    required int choiceIndex,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _userMissions.indexWhere((m) => m.id == missionId);
    if (index < 0) {
      throw StateError('mission not found');
    }
    final mission = _userMissions[index];
    if (choiceIndex < 0 || choiceIndex >= mission.choices.length) {
      throw ArgumentError('invalid choice');
    }
    final selected = mission.choices[choiceIndex];

    if (mission.isPollType) {
      final stats = _buildPollStats(mission.choices, choiceIndex);
      final updated = UserMission(
        id: mission.id,
        type: mission.type,
        title: mission.title,
        authorNickname: mission.authorNickname,
        authorBadge: mission.authorBadge,
        programLabel: mission.programLabel,
        status: mission.status,
        remainingLabel: mission.remainingLabel,
        pointCost: mission.pointCost,
        likeCount: mission.likeCount,
        commentCount: mission.commentCount,
        viewCount: mission.viewCount,
        participantCount: mission.participantCount + 1,
        createdAtLabel: mission.createdAtLabel,
        isMine: mission.isMine,
        choices: mission.choices,
        description: mission.description,
        categoryId: mission.categoryId,
        choiceStats: stats,
        userSelectedChoice: selected,
        hasParticipated: true,
      );
      _userMissions[index] = updated;
      return updated;
    }

    final updated = UserMission(
      id: mission.id,
      type: mission.type,
      title: mission.title,
      authorNickname: mission.authorNickname,
      authorBadge: mission.authorBadge,
      programLabel: mission.programLabel,
      status: mission.status,
      remainingLabel: mission.remainingLabel,
      pointCost: mission.pointCost,
      likeCount: mission.likeCount,
      commentCount: mission.commentCount,
      viewCount: mission.viewCount,
      participantCount: mission.participantCount + 1,
      createdAtLabel: mission.createdAtLabel,
      isMine: mission.isMine,
      choices: mission.choices,
      description: mission.description,
      categoryId: mission.categoryId,
      userSelectedChoice: selected,
      hasParticipated: true,
    );
    _userMissions[index] = updated;
    return updated;
  }

  List<UserMissionChoiceStat> _buildPollStats(
    List<String> choices,
    int selectedIndex,
  ) {
    final percents = switch (choices.length) {
      2 => [56, 44],
      3 => [56, 32, 12],
      _ => List<int>.generate(choices.length, (i) => 100 ~/ choices.length),
    };
    return List<UserMissionChoiceStat>.generate(
      choices.length,
      (i) => UserMissionChoiceStat(
        label: choices[i],
        percent: percents[i.clamp(0, percents.length - 1)],
        isUserChoice: i == selectedIndex,
      ),
    );
  }

  @override
  Future<UserMission> createUserMission({
    required UserMissionType type,
    required String title,
    required String programLabel,
    required String description,
    required List<String> choices,
    String? deadlineLabel,
    int pointCost = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final mission = UserMission(
      id: 'um-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      title: title,
      authorNickname: '강아지#123',
      authorBadge: '미션마스터',
      programLabel: programLabel,
      status: UserMissionStatus.active,
      remainingLabel: deadlineLabel,
      pointCost: pointCost,
      likeCount: 0,
      commentCount: 0,
      viewCount: 0,
      participantCount: 0,
      createdAtLabel: '방금 전',
      isMine: true,
      choices: choices,
      description: description,
    );
    _userMissions.insert(0, mission);
    return mission;
  }
}
