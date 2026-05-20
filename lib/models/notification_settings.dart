class NotificationSettings {
  const NotificationSettings({
    this.missionResult = true,
    this.pointReward = true,
    this.interestedProgram = false,
    this.comment = true,
    this.like = false,
    this.rankingChange = true,
    this.specialBadge = true,
    this.growthBadgeLevelUp = false,
    this.eventNotice = true,
    this.appUpdate = false,
  });

  final bool missionResult;
  final bool pointReward;
  final bool interestedProgram;
  final bool comment;
  final bool like;
  final bool rankingChange;
  final bool specialBadge;
  final bool growthBadgeLevelUp;
  final bool eventNotice;
  final bool appUpdate;

  NotificationSettings copyWith({
    bool? missionResult,
    bool? pointReward,
    bool? interestedProgram,
    bool? comment,
    bool? like,
    bool? rankingChange,
    bool? specialBadge,
    bool? growthBadgeLevelUp,
    bool? eventNotice,
    bool? appUpdate,
  }) {
    return NotificationSettings(
      missionResult: missionResult ?? this.missionResult,
      pointReward: pointReward ?? this.pointReward,
      interestedProgram: interestedProgram ?? this.interestedProgram,
      comment: comment ?? this.comment,
      like: like ?? this.like,
      rankingChange: rankingChange ?? this.rankingChange,
      specialBadge: specialBadge ?? this.specialBadge,
      growthBadgeLevelUp: growthBadgeLevelUp ?? this.growthBadgeLevelUp,
      eventNotice: eventNotice ?? this.eventNotice,
      appUpdate: appUpdate ?? this.appUpdate,
    );
  }
}
