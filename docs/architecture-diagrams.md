# Picktory 아키텍처 다이어그램 (현재 구현 기준)

> **기준:** `lib/` 175개 Dart 파일 · MVVM + `ChangeNotifier` + `go_router` + `ServiceLocator`  
> **데이터:** Phase 3 전 `Dummy*Repository` 더미 구현

---

## 1. 레이어 구조도 (Class Diagram 유사)

```mermaid
classDiagram
    direction TB

    class PicktoryApp {
        +createRouter()
    }
    class ServiceLocator {
        +init()
        Repositories
        Shell ViewModels
    }
    class AppRouter {
        +rootNavigatorKey
        +routeObserver
        +create() GoRouter
    }
    class AppRoute {
        <<enumeration>>
        32 routes
    }

    PicktoryApp --> AppRouter
    AppRouter --> AppRoute
    AppRouter --> ServiceLocator

    namespace Models {
        class UserProfile
        class UserPreference
        class HomeFeed
        class Mission
        class MissionDetail
        class MissionParticipationResult
        class CommunityPost
        class CommunityComment
        class UserMission
        class RankingFeed
        class MyPageSummary
        class NotificationSettings
        class AuthSession
        class SignupDraft
        class TvProgram
    }

    namespace Services_Abstract {
        class AuthRepository
        class SignupRepository
        class UserPreferenceRepository
        class HomeRepository
        class MissionRepository
        class CommunityRepository
        class RankingRepository
        class MyRepository
        class NotificationRepository
        class StoryRepository
        class TvProgramRepository
    }

    namespace Services_Dummy {
        class DummyAuthRepository
        class DummySignupRepository
        class DummyUserPreferenceRepository
        class DummyHomeRepository
        class DummyMissionRepository
        class DummyCommunityRepository
        class DummyRankingRepository
        class DummyMyRepository
        class DummyNotificationRepository
        class DummyStoryRepository
        class DummyTvProgramRepository
        class DummyDataProvider
        class DummyCommunityData
        class DummyRankingData
    }

    namespace ViewModels {
        class SplashViewModel
        class LoginViewModel
        class HomeViewModel
        class MissionDetailViewModel
        class CommunityFeedViewModel
        class RankingViewModel
        class MyViewModel
    }

    namespace Views {
        class MainShellView
        class HomeView
        class MissionDetailView
        class CommunityFeedView
        class RankingView
        class MyView
    }

    AuthRepository <|.. DummyAuthRepository
    SignupRepository <|.. DummySignupRepository
    UserPreferenceRepository <|.. DummyUserPreferenceRepository
    HomeRepository <|.. DummyHomeRepository
    MissionRepository <|.. DummyMissionRepository
    CommunityRepository <|.. DummyCommunityRepository
    RankingRepository <|.. DummyRankingRepository
    MyRepository <|.. DummyMyRepository
    NotificationRepository <|.. DummyNotificationRepository
    StoryRepository <|.. DummyStoryRepository
    TvProgramRepository <|.. DummyTvProgramRepository

    ServiceLocator --> Services_Abstract
    ServiceLocator --> ViewModels

    SplashViewModel --> AuthRepository
    HomeViewModel --> HomeRepository
    HomeViewModel --> UserPreferenceRepository
    MissionDetailViewModel --> MissionRepository
    CommunityFeedViewModel --> CommunityRepository
    RankingViewModel --> RankingRepository
    MyViewModel --> MyRepository

    HomeView --> HomeViewModel
    MissionDetailView --> MissionDetailViewModel
    CommunityFeedView --> CommunityFeedViewModel
    RankingView --> RankingViewModel
    MyView --> MyViewModel

    HomeViewModel ..> HomeFeed
    MissionDetailViewModel ..> MissionDetail
    CommunityFeedViewModel ..> CommunityPost
    MyViewModel ..> MyPageSummary
```



---

## 2. 패키지·폴더 구조도

```mermaid
flowchart TB
    subgraph lib["lib/ (175 files)"]
        main["main.dart"]
        subgraph app["app/ (2)"]
            PA["picktory_app.dart"]
            SL["di/service_locator.dart"]
        end
        subgraph core["core/navigation/ (3)"]
            AR["app_route.dart"]
            ARO["app_router.dart"]
            SD["splash_destination.dart"]
        end
        subgraph models["models/ (36)"]
            M1["auth · user · home · mission"]
            M2["community · ranking · my"]
        end
        subgraph services["services/ (25)"]
            SA["11 × *Repository abstract"]
            SDU["dummy/ 14 implementations + data"]
        end
        subgraph vm["viewmodels/ (30)"]
            VM1["auth · onboarding · home"]
            VM2["mission · community · ranking · my"]
        end
        subgraph views["views/ (78)"]
            V1["shell · splash · login · signup"]
            V2["home · mission · community"]
            V3["ranking · my · notification"]
        end
    end
    main --> PA --> SL
    PA --> ARO
    ARO --> views
    views --> vm
    vm --> services
    services --> models
```




| 레이어                | 역할                                        | 파일 수 |
| ------------------ | ----------------------------------------- | ---- |
| `models/`          | 도메인 데이터·enum                              | 36   |
| `services/`        | Repository 인터페이스 + Dummy                  | 25   |
| `viewmodels/`      | `ChangeNotifier` 상태·비즈니스                  | 30   |
| `views/`           | UI (`StatelessWidget` / `StatefulWidget`) | 78   |
| `core/navigation/` | `go_router` 라우트 정의                        | 3    |


---

## 3. ServiceLocator 의존성 맵

```mermaid
flowchart LR
    subgraph SL["ServiceLocator.init()"]
        AR[AuthRepository]
        UPR[UserPreferenceRepository]
        SR[SignupRepository]
        CR[CommunityRepository]
        HR[HomeRepository]
        RR[RankingRepository]
        MR[MissionRepository]
        NR[NotificationRepository]
        STR[StoryRepository]
        TVR[TvProgramRepository]
        MYR[MyRepository]
    end

  subgraph ShellVM["탭 싱글톤 ViewModel"]
        HVM[HomeViewModel]
        CFVM[CommunityFeedViewModel]
        RVM[RankingViewModel]
        RGVM[RankingGrowthViewModel]
        MVM[MyViewModel]
    end

    SR --> UPR
    HR --> UPR
    MYR --> UPR
    HVM --> HR
    HVM --> UPR
    CFVM --> CR
    RVM --> RR
    RGVM --> RR
    MVM --> MYR
```



**라우터에서 화면별 생성 (비싱글톤):**  
`SplashViewModel`, `LoginViewModel`, `MissionDetailViewModel`, `CommunityPostDetailViewModel`, `MyPickHistoryViewModel` 등 — `app_router.dart` `builder` 내부

---

## 4. ViewModel ↔ Repository 전체 매핑

```mermaid
flowchart TB
    subgraph Auth_Onboarding
        SplashVM --> AuthRepo
        LoginVM --> AuthRepo
        TermsVM --> SignupRepo
        ProfileVM --> SignupRepo
        ProgramVM --> SignupRepo
        ProgramVM --> TvProgramRepo
        InviteVM --> SignupRepo
        CompleteVM --> SignupRepo
        CompleteVM --> AuthRepo
    end

    subgraph Home_Mission
        HomeVM --> HomeRepo
        HomeVM --> UserPrefRepo
        MissionDetailVM --> MissionRepo
        MissionResultVM --> MissionRepo
        MissionShareVM --> MissionRepo
        NotifVM --> NotifRepo
    end

    subgraph Community
        FeedVM --> CommunityRepo
        ComposeVM --> CommunityRepo
        PostDetailVM --> CommunityRepo
        ReportVM --> CommunityRepo
        SuggestVM --> CommunityRepo
        UMCreateVM --> CommunityRepo
        UMDetailVM --> CommunityRepo
    end

    subgraph Ranking
        RankingVM --> RankingRepo
        GrowthVM --> RankingRepo
    end

    subgraph My
        MyVM --> MyRepo
        PickHistVM --> MyRepo
        CommActVM --> MyRepo
        BadgesVM --> MyRepo
        NotifSetVM --> MyRepo
        InterestVM --> UserPrefRepo
        InterestVM --> TvProgramRepo
    end

    AuthRepo[AuthRepository]
    SignupRepo[SignupRepository]
    UserPrefRepo[UserPreferenceRepository]
    HomeRepo[HomeRepository]
    MissionRepo[MissionRepository]
    CommunityRepo[CommunityRepository]
    RankingRepo[RankingRepository]
    MyRepo[MyRepository]
    NotifRepo[NotificationRepository]
    TvProgramRepo[TvProgramRepository]
```



---

## 5. Activity Diagram — 앱 시작·인증·온보딩

```mermaid
flowchart TD
    Start([앱 실행]) --> Splash["SplashView<br/>SplashViewModel"]
    Splash --> Resolve["resolveDestination()<br/>AuthRepository.getSession()"]
    Resolve --> Wait["최소 1.5초 대기"]

    Wait --> C1{세션 유효<br/>+ 온보딩 완료?}
    C1 -->|Yes| Home["go /home<br/>MainShellView"]

    Wait --> C2{세션 유효<br/>온보딩 미완?}
    C2 -->|Yes| Terms["/signup/terms"]

    Wait --> C3{세션 없음}
    C3 -->|Yes| Login["/login<br/>LoginView"]

    Login --> L1{로그인 성공?}
    L1 -->|완료 사용자| Home
    L1 -->|신규/미완료| Terms
    L1 -->|회원가입| Terms

    Terms --> Profile["/signup/profile"]
    Profile --> Programs["/signup/programs<br/>TvProgramRepository"]
    Programs --> Invite["/signup/invite<br/>PICK1 검증"]
    Invite --> Complete["/signup/complete<br/>200코인"]
    Complete --> Save["SignupRepository.completeSignup<br/>UserPreferenceRepository.save"]
    Save --> Home

    Login -.-> FindId["/account/find-id<br/>(라우트만)"]
    Login -.-> ResetPw["/account/reset-password<br/>(라우트만)"]
```



---

## 6. Activity Diagram — 메인 셸·하단 탭

```mermaid
flowchart TD
    HomeTab["/home 진입"] --> Shell["MainShellView<br/>StatefulShellRoute.indexedStack"]

    Shell --> Nav["AppBottomNavBar<br/>goBranch(index)"]

    Nav --> T0["index 0: /ranking<br/>RankingView + RankingViewModel"]
    Nav --> T1["index 1: /community<br/>CommunityFeedView + FeedViewModel"]
    Nav --> T2["index 2: /home<br/>HomeView + HomeViewModel"]
    Nav --> T3["index 3: /benefits<br/>PlaceholderTabView"]
    Nav --> T4["index 4: /my<br/>MyView + MyViewModel"]

    T0 --> PushGrowth["push /ranking/growth<br/>RankingGrowthRecordView"]
    T1 --> PushSub["서브 화면 push<br/>rootNavigatorKey"]
    T2 --> PushSub
    T4 --> PushSub
```



---

## 7. Activity Diagram — 홈 & 미션 플로우 (H-1, M-1~M-5, N-1)

```mermaid
flowchart TD
    Enter["HomeView 진입"] --> Load["HomeViewModel.loadFeed()<br/>HomeRepository.fetchFeed()<br/>UserPreferenceRepository.load()"]

    Load --> UI["광고 · 헤더 · 히어로카드<br/>카테고리칩 · 미션카드 · 결과카드"]

    UI --> Bell["알림 벨 탭"]
    Bell --> N1["push /notifications<br/>NotificationView"]

    UI --> Hero["히어로 참여하기 / 미션카드"]
    Hero --> M1["push /mission/:id<br/>MissionDetailView"]

    M1 --> LoadM["MissionDetailViewModel.load()<br/>MissionRepository.fetchMissionDetail()"]
    LoadM --> Select["선택지 A~D 선택"]
    Select --> Submit["선택 후 N포인트 차감"]
    Submit --> RepoSubmit["MissionRepository.submitChoice()"]
    RepoSubmit --> Sheet["MissionConfirmSheet<br/>바텀시트"]

    Sheet --> ShareBtn["스레드에 공유하기"]
    ShareBtn --> M5["push /mission/:id/share<br/>MissionShareView"]

    Sheet --> HomeBtn["홈으로 돌아가기"]
    HomeBtn --> GoHome["go /home"]

    UI --> ResultCard["결과공개 카드 탭"]
    ResultCard --> M4["push /mission/:id/result<br/>MissionResultView"]
    M4 --> M5

    N1 --> Empty{알림 없음?}
    Empty -->|Yes| GoMission["미션 보러가기 → /home"]
```



---

## 8. Activity Diagram — 커뮤니티 (C-1~C-5, 스레드 상세, UM)

```mermaid
flowchart TD
    Enter["CommunityFeedView"] --> Load["CommunityFeedViewModel.load()"]

    Load --> Tabs{"탭 선택"}
    Tabs --> All["전체: 전체 게시물"]
    Tabs --> Thread["스레드: 카테고리 캐러셀 필터"]
    Tabs --> UM["유저 미션: 필터칩 + 캐러셀"]

    All --> PostCard["게시물 카드 탭"]
    Thread --> PostCard
    PostCard --> Detail["push /community/post/:id<br/>CommunityPostDetailView"]

    Detail --> Comment["댓글 작성 · 전송<br/>addComment()"]
    Detail --> Like["좋아요 togglePostLike()"]
    Detail --> More["··· 메뉴"]
    More --> Edit["수정 → /community/compose?editId"]
    More --> Report["신고 → /community/report"]
    More --> MissionLink["미션공유 → /mission/:id"]

    UM --> UMCard["유저미션 카드"]
    UMCard --> UMDetail["push /community/user-missions/:id"]
    UMDetail --> Participate["선택 → participateUserMission()<br/>투표형: 즉시 결과 막대"]

    Enter --> FAB["FAB +"]
    FAB --> C5["showCommunityCreateSheet"]
    C5 --> C3["글 작성 → /community/compose"]
    C5 --> C4["미션 건의 → /community/mission-suggest"]

    C5 -.-> UMCreate["/community/user-missions/create<br/>(라우트만, FAB 미연결)"]
```



---

## 9. Activity Diagram — 랭킹 (R-1, R-2)

```mermaid
flowchart TD
    Enter["RankingView"] --> Load["RankingViewModel.load()<br/>RankingRepository.fetchRanking()"]

    Load --> MainTabs["시즌 / 커뮤니티 / 전체 탭"]
    MainTabs --> Period["기간 선택<br/>RankingPeriodSelector"]
    MainTabs --> Podium["TOP3 포디움"]
    MainTabs --> List["랭킹 리스트"]
    MainTabs --> MyBar["하단 내 순위 바"]

    List --> ProfileTap["프로필 탭"]
    ProfileTap --> Sheet["RankingProfileSheet<br/>fetchProfilePreview()"]

    Enter --> GrowthBtn["성장 기록"]
    GrowthBtn --> R2["push /ranking/growth<br/>RankingGrowthViewModel.load()"]
```



---

## 10. Activity Diagram — 마이페이지·환경설정

```mermaid
flowchart TD
    Enter["MyView"] --> Load["MyViewModel.load()<br/>MyRepository.fetchSummary()"]

    Load --> Profile["프로필 영역 탭"]
    Profile --> Sheet["MyProfileEditSheet<br/>updateNickname() → UserPreference"]

    Load --> Settings["⚙ → /settings"]
    Settings --> NotifSet["알림 설정 → /settings/notifications<br/>NotificationSettingsViewModel"]
    NotifSet --> Toggle["Switch 토글<br/>MyRepository.saveNotificationSettings()"]
    Settings --> Logout["로그아웃<br/>AuthRepository.clearSession() → /login"]

    Load --> Pick["내 픽 기록 → /my/pick-history"]
    Pick --> Filter["필터: 전체/미션/커뮤니티/기타<br/>fetchPickHistory()"]

    Load --> Comm["내 커뮤니티 활동"]
    Comm --> CommAct["/my/community-activity<br/>글/댓글 탭"]

    Load --> Badge["스페셜 뱃지 → /my/badges"]
    Load --> Interest["관심 프로그램 → /my/interested-programs"]

    Interest --> Search["프로그램 검색<br/>TvProgramRepository.fetchPrograms()"]
    Interest --> Chips["선택 칩 추가/삭제"]
    Interest --> Save["저장 확인 다이얼로그<br/>UserPreferenceRepository.save()"]
```



---

## 11. 화면–ViewModel–Route 매트릭스


| 화면 ID    | View                       | ViewModel                       | Route                          | Repository                     |
| -------- | -------------------------- | ------------------------------- | ------------------------------ | ------------------------------ |
| Splash   | `SplashView`               | `SplashViewModel`               | `/`                            | `AuthRepository`               |
| Login    | `LoginView`                | `LoginViewModel`                | `/login`                       | `AuthRepository`               |
| O-2~O-7  | `TermsView` 등              | 각 VM                            | `/signup/*`                    | `SignupRepository`             |
| H-1      | `HomeView`                 | `HomeViewModel` ★               | `/home`                        | `HomeRepository`               |
| N-1      | `NotificationView`         | `NotificationViewModel`         | `/notifications`               | `NotificationRepository`       |
| M-1      | `MissionDetailView`        | `MissionDetailViewModel`        | `/mission/:id`                 | `MissionRepository`            |
| M-4      | `MissionResultView`        | `MissionResultViewModel`        | `/mission/:id/result`          | `MissionRepository`            |
| M-5      | `MissionShareView`         | `MissionShareViewModel`         | `/mission/:id/share`           | `MissionRepository`            |
| C-1      | `CommunityFeedView`        | `CommunityFeedViewModel` ★      | `/community`                   | `CommunityRepository`          |
| C-2      | `CommunityPostDetailView`  | `CommunityPostDetailViewModel`  | `/community/post/:id`          | `CommunityRepository`          |
| C-3      | `CommunityComposeView`     | `CommunityComposeViewModel`     | `/community/compose`           | `CommunityRepository`          |
| C-4      | `MissionSuggestView`       | `MissionSuggestViewModel`       | `/community/mission-suggest`   | `CommunityRepository`          |
| UM-4     | `UserMissionDetailView`    | `UserMissionDetailViewModel`    | `/community/user-missions/:id` | `CommunityRepository`          |
| R-1      | `RankingView`              | `RankingViewModel` ★            | `/ranking`                     | `RankingRepository`            |
| R-2      | `RankingGrowthRecordView`  | `RankingGrowthViewModel` ★      | `/ranking/growth`              | `RankingRepository`            |
| My       | `MyView`                   | `MyViewModel` ★                 | `/my`                          | `MyRepository`                 |
| Settings | `SettingsView`             | —                               | `/settings`                    | `AuthRepository` (logout)      |
| 관심 프로그램  | `MyInterestedProgramsView` | `MyInterestedProgramsViewModel` | `/my/interested-programs`      | `UserPreference` + `TvProgram` |


★ = `ServiceLocator` 싱글톤 (탭 또는 공유 VM)

---

## 12. 네비게이션 트리 (push vs tab)

```mermaid
flowchart TB
    subgraph Root["rootNavigatorKey (전체 화면 push)"]
        Onboard["/signup/* · /login · /account/*"]
        Mission["/mission/:id · /result · /share"]
        CommPush["/community/post · /compose · /report · /user-missions/*"]
        MyPush["/my/* · /settings · /settings/notifications"]
        Notif["/notifications"]
        Growth["/ranking/growth"]
    end

    subgraph Shell["StatefulShellRoute (탭, NoTransitionPage)"]
        T0["/ranking"]
        T1["/community"]
        T2["/home"]
        T3["/benefits"]
        T4["/my"]
    end

    Onboard --> Shell
    Shell --> Root
```



---

## 13. 데이터 구조도 — 도메인 개요

`lib/models/` **36개 파일** · 엔티티 클래스 **약 45개** · enum **약 20개**

```mermaid
flowchart TB
    subgraph Auth_User["인증 · 사용자"]
        AuthSession
        SignupDraft
        UserProfile
        UserPreference
        TermsConsent
        TvProgram
    end

    subgraph Home_Mission["홈 · 공식 미션"]
        HomeFeed
        Mission
        MissionChoice
        MissionDetail
        MissionParticipationResult
        MissionResult
        AdBanner
    end

    subgraph Community["커뮤니티"]
        CommunityPost
        CommunityComment
        CommunityCategory
        UserMission
        UserMissionChoiceStat
    end

    subgraph Ranking["랭킹"]
        RankingFeed
        RankingEntry
        RankingPodiumEntry
        RankingMySummary
        RankingGrowthRecord
    end

    subgraph My_Settings["마이 · 설정"]
        MyPageSummary
        PickHistoryItem
        SpecialBadge
        NotificationSettings
        MyCommunityPostItem
    end

    subgraph System["시스템 · 기타"]
        AppNotification
        ReportReason
        StoryItem
    end

    UserPreference --> UserProfile
    UserPreference --> TvProgram
    SignupDraft --> UserProfile
    SignupDraft --> TermsConsent

    HomeFeed --> Mission
    HomeFeed --> MissionResult
    HomeFeed --> AdBanner
    MissionDetail --> Mission
    MissionDetail --> MissionChoice
    MissionParticipationResult --> MissionChoice

    CommunityPost --> CommunityComment
    CommunityPost -.->|linkedMissionId| Mission
    UserMission --> UserMissionChoiceStat

    RankingFeed --> RankingEntry
    RankingFeed --> RankingMySummary
```

---

## 14. 개념 ER 다이어그램 (관계)

> 로컬 더미 저장 구조 기준. 실제 DB 스키마는 아님.

```mermaid
erDiagram
    UserPreference ||--o| UserProfile : profile
    UserPreference }o--o{ TvProgram : "selectedProgramIds"

    SignupDraft ||--o| TermsConsent : terms
    SignupDraft ||--o| UserProfile : profile
    SignupDraft }o--o{ TvProgram : selectedProgramIds

    AuthSession {
        string accessToken
        bool isOnboardingCompleted
    }

    Mission ||--o{ MissionChoice : "options (detail)"
    Mission {
        string id PK
        string programLabel
        string title
        int pointCost
        string category
    }

    MissionChoice {
        string id
        string label
    }

    CommunityPost ||--o{ CommunityComment : "postId"
    CommunityPost }o--o| Mission : "linkedMissionId"

    CommunityPost {
        string id PK
        string authorNickname
        string title
        string content
        bool isMissionShare
        string linkedMissionId FK
    }

    CommunityComment {
        string id PK
        string postId FK
        string content
    }

    UserMission {
        string id PK
        string authorNickname
        enum type
        enum status
    }

    RankingEntry {
        string userId
        int rank
        enum badge
        int score
    }

    AppNotification {
        string id PK
        enum type
        bool isRead
    }
```

### ID 참조 맵 (화면 간 연결)

| From | Field | To | 용도 |
|------|-------|-----|------|
| `CommunityPost` | `linkedMissionId` | `Mission.id` | 미션 공유 글 → 미션 상세 |
| `CommunityComment` | `postId` | `CommunityPost.id` | 댓글 소속 |
| `MissionParticipationResult` | `missionId` | `Mission.id` | 참여 결과 조회 |
| `UserPreference` | `selectedProgramIds` | `TvProgram.id` | 관심 프로그램 |
| `SignupDraft` | `selectedProgramIds` | `TvProgram.id` | 가입 시 선택 |
| `StoryItem` | `id` | `Mission.id` 등 | 레거시 (동일 id 재사용) |

---

## 15. 클래스 상세 — 인증 · 사용자

```mermaid
classDiagram
    class AuthSession {
        +String accessToken
        +bool isOnboardingCompleted
        +bool isValid
    }

    class SignupDraft {
        +TermsConsent? terms
        +UserProfile? profile
        +Set~String~ selectedProgramIds
        +String? inviteCode
        +bool inviteBonusApplied
        +copyWith()
    }

    class TermsConsent {
        +bool isOver14
        +bool agreedToTerms
        +bool agreedToPrivacy
        +bool agreedToMarketing
        +bool agreedToNightPush
        +bool requiredAgreed
        +bool allAgreed
    }

    class UserProfile {
        +String nickname
        +Gender? gender
        +String birthDate
        +String? profileImageUrl
        +bool isComplete
        +copyWith()
    }

    class UserPreference {
        +UserProfile? profile
        +Set~String~ selectedProgramIds
        +bool isOnboardingCompleted
        +bool hasProgramSelection
        +copyWith()
    }

    class TvProgram {
        +String id
        +String title
        +String channel
        +String category
    }

    class Gender {
        <<enumeration>>
        male
        female
    }

    SignupDraft --> TermsConsent
    SignupDraft --> UserProfile
    UserPreference --> UserProfile
    UserProfile --> Gender
```

| 모델 | 파일 | Repository |
|------|------|------------|
| `AuthSession` | `auth_session.dart` | `AuthRepository` |
| `SignupDraft` | `signup_draft.dart` | `SignupRepository` (메모리) |
| `UserPreference` | `user_preference.dart` | `UserPreferenceRepository` |
| `TvProgram` | `tv_program.dart` | `TvProgramRepository` |

---

## 16. 클래스 상세 — 홈 · 공식 미션

```mermaid
classDiagram
    class HomeFeed {
        +String nickname
        +int points
        +bool hasUnreadNotifications
        +List~AdBanner~ adBanners
        +List~Mission~ heroMissions
        +List~Mission~ activeMissions
        +List~MissionResult~ results
        +bool hasInterestPrograms
        +List~String~ categories
        +String? inlineAdTitle
    }

    class Mission {
        +String id
        +String programLabel
        +String title
        +int pointCost
        +String remainingLabel
        +int participantCount
        +List~MissionChoice~ choices
        +bool isUrgent
        +String category
    }

    class MissionChoice {
        +String id
        +String label
    }

    class MissionDetail {
        +Mission mission
        +List~MissionChoice~ options
        +int totalPointPool
        +List~Mission~ relatedMissions
        +List~String~ relatedThreadTitles
    }

    class MissionParticipationResult {
        +String missionId
        +String programLabel
        +String title
        +MissionChoice userChoice
        +MissionChoice correctChoice
        +int earnedPoints
        +List~MissionChoiceStat~ choiceStats
        +List~Mission~ relatedMissions
        +List~String~ relatedThreadTitles
        +bool isCorrect
    }

    class MissionChoiceStat {
        +MissionChoice choice
        +int percent
        +bool isCorrect
        +bool isUserChoice
    }

    class MissionResult {
        +String id
        +String programLabel
        +String title
        +String userChoiceLabel
        +bool isCorrect
        +int rewardPoints
        +int participantCount
        +String resultLabel
    }

    class AdBanner {
        +String id
        +String title
        +String subtitle
    }

    HomeFeed *-- Mission
    HomeFeed *-- MissionResult
    HomeFeed *-- AdBanner
    MissionDetail *-- Mission
    MissionDetail *-- MissionChoice
    Mission *-- MissionChoice
    MissionParticipationResult *-- MissionChoiceStat
    MissionChoiceStat --> MissionChoice
```

| 응답 DTO | 구성 | 생성 |
|----------|------|------|
| `HomeFeed` | 피드 집계 | `HomeRepository.fetchFeed()` |
| `MissionDetail` | 상세 + 선택지 4개 | `MissionRepository.fetchMissionDetail()` |
| `MissionParticipationResult` | 참여·결과 | `MissionRepository.submitChoice()` / `fetchParticipationResult()` |

---

## 17. 클래스 상세 — 커뮤니티

```mermaid
classDiagram
    class CommunityCategory {
        +String id
        +String label
    }

    class CommunityPost {
        +String id
        +String authorNickname
        +String? authorBadge
        +String programLabel
        +String title
        +String content
        +int likeCount
        +int commentCount
        +int viewCount
        +String createdAtLabel
        +bool isMine
        +bool isAnonymous
        +bool isMissionShare
        +String? linkedMissionLabel
        +String? linkedMissionId
        +String categoryId
        +String? broadcastDate
        +bool hasPoll
        +List~String~ pollOptions
        +String displayAuthor
        +String headerLabel
    }

    class CommunityComment {
        +String id
        +String postId
        +String authorNickname
        +String? authorBadge
        +String content
        +String createdAtLabel
        +int likeCount
        +bool isMine
        +bool isAnonymous
        +bool isEdited
        +bool isDeleted
    }

    class UserMission {
        +String id
        +UserMissionType type
        +String title
        +String authorNickname
        +String programLabel
        +UserMissionStatus status
        +String? remainingLabel
        +int pointCost
        +int likeCount
        +int commentCount
        +int viewCount
        +int participantCount
        +List~String~ choices
        +String description
        +String categoryId
        +List~UserMissionChoiceStat~ choiceStats
        +bool hasParticipated
        +String? userSelectedChoice
    }

    class UserMissionChoiceStat {
        +String label
        +int percent
        +bool isUserChoice
    }

    class ReportTargetType {
        <<enumeration>>
        post
        comment
        userMission
    }

    class ReportReason {
        <<enumeration>>
        spam abuse inappropriate falseInfo other
    }

    CommunityPost "1" --> "0..*" CommunityComment : postId
    CommunityPost ..> Mission : linkedMissionId
    UserMission *-- UserMissionChoiceStat
```

### 커뮤니티 enum

| Enum | 값 | 용도 |
|------|-----|------|
| `UserMissionType` | `mission`, `poll` | UM-4a / UM-4b |
| `UserMissionStatus` | `active`, `closed` | 목록 필터 |
| `UserMissionFilter` | `all`, `active`, `closed`, `mine` | 칩 필터 |
| `UserMissionSort` | `latest`, `popular`, `participants`, `views` | 정렬 |
| `CommunityFeedTab` | `all`, `thread`, `userMission` | C-1 탭 (ViewModel) |

### Dummy 저장 구조 (`DummyCommunityRepository`)

```
_posts: List<CommunityPost>
_comments: Map<postId, List<CommunityComment>>
_userMissions: List<UserMission>
_likedPosts: Set<postId>
_likedComments: Set<commentId>
_blockedUsers: Set<nickname>
```

---

## 18. 클래스 상세 — 랭킹

```mermaid
classDiagram
    class RankingFeed {
        +List~RankingPodiumEntry~ podium
        +List~RankingEntry~ entries
        +RankingMySummary mySummary
        +List~RankingPeriodOption~ periodOptions
        +String selectedPeriodId
        +bool hasMore
        +String? infoBannerMessage
    }

    class RankingPodiumEntry {
        +int rank
        +String userId
        +String nickname
        +RankingBadge badge
        +int score
        +bool isFirst
        +String? communityTitle
    }

    class RankingEntry {
        +int rank
        +String userId
        +String nickname
        +RankingBadge badge
        +int score
        +RankingRankChange rankChange
        +bool isCurrentUser
    }

    class RankingMySummary {
        +int rank
        +String nickname
        +RankingBadge badge
        +int score
        +RankingRankChange rankChange
        +String? currentTierName
        +int? tierProgressCurrent
        +int? tierProgressMax
        +String? activitySummaryLabel
    }

    class RankingGrowthRecord {
        +String currentTierName
        +int currentPoints
        +int tierMinPoints
        +int tierMaxPoints
        +List~GrowthTierStep~ steps
        +double tierProgress
    }

    class GrowthTierStep {
        +String name
        +int minPoints
        +int? maxPoints
        +GrowthTierStatus status
    }

    class RankingProfilePreview {
        +String userId
        +String nickname
        +int knowledgePoints
        +int activityPoints
        +int accuracyPercent
    }

  class RankingRankChange {
        <<sealed>>
    }
    class RankingRankChangeUp
    class RankingRankChangeDown
    class RankingRankChangeNone

    RankingFeed *-- RankingPodiumEntry
    RankingFeed *-- RankingEntry
    RankingFeed *-- RankingMySummary
    RankingGrowthRecord *-- GrowthTierStep
    RankingRankChange <|-- RankingRankChangeUp
    RankingRankChange <|-- RankingRankChangeDown
    RankingRankChange <|-- RankingRankChangeNone
```

| Enum | 값 |
|------|-----|
| `RankingMainTab` | `season`, `community`, `overall` |
| `RankingBadge` | `bronze`, `silver`, `gold`, `master`, `legend` |
| `RankingSpecialBadge` | `legend`, `accuracyKing`, `seasonComplete` |
| `GrowthTierStatus` | `completed`, `inProgress`, `locked` |

---

## 19. 클래스 상세 — 마이 · 알림 · 기타

```mermaid
classDiagram
    class MyPageSummary {
        +String nickname
        +String tierLabel
        +int totalRanking
        +int communityRanking
        +int missionRanking
        +int accumulatedPoints
        +int currentPoints
        +int ticketCount
    }

    class PickHistoryItem {
        +String id
        +String title
        +String timeLabel
        +int points
        +PickHistoryType type
        +bool isCompleted
    }

    class SpecialBadge {
        +String id
        +String label
        +String iconEmoji
        +bool isEarned
    }

    class NotificationSettings {
        +bool missionResult
        +bool pointReward
        +bool interestedProgram
        +bool comment
        +bool like
        +bool rankingChange
        +bool specialBadge
        +bool growthBadgeLevelUp
        +bool eventNotice
        +bool appUpdate
        +copyWith()
    }

    class MyCommunityPostItem {
        +String id
        +String title
        +String timeLabel
        +int likeCount
        +int commentCount
    }

    class MyCommunityCommentItem {
        +String id
        +String postTitle
        +String content
        +String timeLabel
        +int likeCount
    }

    class AppNotification {
        +String id
        +AppNotificationType type
        +String title
        +String body
        +String timeLabel
        +bool isRead
    }

    class StoryItem {
        +String id
        +String title
        +String summary
        +Genre genre
        +String body
    }

    PickHistoryItem --> PickHistoryType
    AppNotification --> AppNotificationType
```

| Enum | 값 |
|------|-----|
| `PickHistoryFilter` | `all`, `mission`, `community`, `other` |
| `PickHistoryType` | `mission`, `community`, `other` |
| `AppNotificationType` | `result`, `mission`, `reward`, `ranking` |
| `Genre` | `fantasy`, `romance`, `mystery`, `sf`, `horror`, `daily` |

---

## 20. Aggregate vs Entity 구분

| 유형 | 모델 | 설명 |
|------|------|------|
| **Entity** | `Mission`, `CommunityPost`, `UserMission`, `TvProgram` | 단일 도메인 객체, CRUD 대상 |
| **Value** | `MissionChoice`, `AdBanner`, `CommunityCategory` | 불변 값, ID만으로 식별 |
| **Aggregate Response** | `HomeFeed`, `MissionDetail`, `RankingFeed`, `MyPageSummary` | API/Repository 응답용 조합 |
| **View DTO** | `MyCommunityPostItem`, `RankingProfilePreview` | 화면 전용 축약 모델 |
| **Settings** | `NotificationSettings`, `TermsConsent` | 플래그 묶음, `copyWith` 지원 |
| **Sealed** | `RankingRankChange` | 변형별 순위 변동 표현 |

```mermaid
flowchart LR
    subgraph Entity
        M[Mission]
        P[CommunityPost]
        UM[UserMission]
    end

    subgraph Aggregate
        HF[HomeFeed]
        MD[MissionDetail]
        RF[RankingFeed]
    end

    subgraph ViewDTO
        MCP[MyCommunityPostItem]
        RPP[RankingProfilePreview]
    end

    HF --> M
    MD --> M
    RF --> RankingEntry
```

---

## 21. Repository ↔ 모델 매핑表

| Repository | 주요 반환/입력 모델 |
|------------|-------------------|
| `AuthRepository` | `AuthSession` |
| `SignupRepository` | `SignupDraft`, `TermsConsent`, `UserProfile` |
| `UserPreferenceRepository` | `UserPreference`, `UserProfile` |
| `TvProgramRepository` | `List<TvProgram>` |
| `HomeRepository` | `HomeFeed` → `Mission`, `MissionResult`, `AdBanner` |
| `MissionRepository` | `MissionDetail`, `MissionParticipationResult` |
| `CommunityRepository` | `CommunityPost`, `CommunityComment`, `UserMission`, `CommunityCategory` |
| `RankingRepository` | `RankingFeed`, `RankingProfilePreview`, `RankingGrowthRecord` |
| `MyRepository` | `MyPageSummary`, `PickHistoryItem`, `SpecialBadge`, `NotificationSettings`, `MyCommunity*` |
| `NotificationRepository` | `List<AppNotification>` |
| `StoryRepository` | `StoryItem` |

---

## 22. 구현 상태 요약


| 영역             | 와이어프레임 | 구현도         | 비고                   |
| -------------- | ------ | ----------- | -------------------- |
| 온보딩 O-1~O-7    | ✅      | 완료          | 소셜 로그인 UI            |
| 홈 H-1 + 미션 M/N | ✅      | 완료          | 다크 테마                |
| 커뮤니티 C-1~C-5   | ✅      | 완료          | UM 생성 FAB 미연결        |
| 랭킹 R-1/R-2     | ✅      | 완료          |                      |
| 마이 + 설정        | ✅      | 완료          |                      |
| 혜택 탭           | —      | Placeholder | `PlaceholderTabView` |
| Story 상세       | 레거시    | 라우트만        | `/story/:id`         |


---

## 23. 전체 화면 흐름도 (IA 기준 Screen Flow)

> IA 섹션별로 색상 코딩한 전체 화면 흐름. 32개 라우트 + 주요 모달/시트 포함.
>
> - **Auth/Onboarding(O)** = 네이비
> - **Home/Mission(H/M)** = 블루
> - **Notification(N)** = 보라
> - **Community(C/UM)** = 핑크
> - **Ranking(R)** = 레드
> - **Benefits(B)** = 옐로우
> - **My/Settings(MY/S)** = 틸
> - **Modal/Sheet** = 라이트 핑크 (점선 연결)

### 23-1. 전체 흐름 — Bird's-eye view

```mermaid
flowchart LR
    classDef auth fill:#1F2A44,stroke:#0D1424,color:#FFFFFF,font-weight:bold
    classDef home fill:#2D6CDF,stroke:#1B4DA3,color:#FFFFFF
    classDef notif fill:#7C4DFF,stroke:#5A35CC,color:#FFFFFF
    classDef community fill:#F0608C,stroke:#C03A66,color:#FFFFFF
    classDef ranking fill:#E63946,stroke:#A8202C,color:#FFFFFF
    classDef benefits fill:#F4A93C,stroke:#C0801C,color:#1A1A1A
    classDef my fill:#2EBFA5,stroke:#1B8C77,color:#FFFFFF
    classDef settings fill:#3F4756,stroke:#1F2530,color:#FFFFFF
    classDef modal fill:#FFD8E2,stroke:#C03A66,color:#1A1A1A,stroke-dasharray:4 3
    classDef hub fill:#FFFFFF,stroke:#1A1A1A,color:#1A1A1A,font-weight:bold,stroke-width:2px

    %% =================== Auth / Onboarding ===================
    Splash["O-1<br/>Splash"]:::auth
    Login["O-2<br/>Login<br/>(카카오/구글/애플)"]:::auth
    Terms["O-3<br/>약관 동의"]:::auth
    TermsDoc(["약관 전문 팝업"]):::modal
    Profile["O-4<br/>프로필 + 초대코드"]:::auth
    Programs["O-5<br/>관심 프로그램"]:::auth
    Complete["O-6<br/>가입 완료"]:::auth
    FindId(("Find ID")):::modal
    ResetPw(("Reset PW")):::modal

    Splash --> Login
    Login -.->|기존| MainHub
    Login -->|신규| Terms
    Login -.-> FindId
    Login -.-> ResetPw
    Terms -.-> TermsDoc
    Terms --> Profile
    Profile --> Programs
    Programs --> Complete
    Complete --> MainHub

    %% =================== Main Shell (5 Tabs) ===================
    MainHub{{"MainShellView<br/>BottomNav 5탭"}}:::hub

    R1["R-1<br/>Ranking"]:::ranking
    C1["C-1<br/>Community Feed"]:::community
    H1["H-1<br/>Home Feed"]:::home
    B1["B-1<br/>Benefits"]:::benefits
    MY1["MY-1<br/>My Page"]:::my

    MainHub --- R1
    MainHub --- C1
    MainHub --- H1
    MainHub --- B1
    MainHub --- MY1

    %% =================== Home / Mission / Notification ===================
    Search(["검색 모달"]):::modal
    NoticeBanner(["공지 배너 시트"]):::modal
    Suggest["미션 건의<br/>= C-4"]:::community

    N1["N-1<br/>알림 목록"]:::notif
    M1["M-1<br/>Mission Detail"]:::home
    MConfirm(["M-2<br/>참여 확인 시트"]):::modal
    M4["M-4<br/>Mission Result"]:::home
    M5["M-5<br/>Mission Share"]:::home
    MShare(["공유 시트"]):::modal

    H1 --> N1
    H1 -.-> Search
    H1 -.-> NoticeBanner
    H1 --> M1
    H1 --> Suggest
    H1 --> B1
    M1 --> MConfirm
    MConfirm --> M5
    MConfirm --> H1
    H1 --> M4
    M4 --> M5
    M5 -.-> MShare
    N1 --> M4
    N1 --> M1
    N1 --> C2
    N1 --> B1

    %% =================== Community ===================
    C2["C-2<br/>Post Detail"]:::community
    C3["C-3<br/>Compose<br/>(thread/UM/poll)"]:::community
    C4["C-4<br/>Mission Suggest"]:::community
    CReport["C-Report<br/>신고"]:::community
    UM4["UM-4<br/>User Mission Detail"]:::community
    CMore(["··· 메뉴 시트"]):::modal
    CFab(["FAB Create Sheet"]):::modal

    C1 -.-> CFab
    CFab --> C3
    CFab --> C4
    C1 --> C2
    C1 --> UM4
    C2 -.-> CMore
    CMore --> C3
    CMore --> CReport
    CMore --> M1
    UM4 --> C2

    %% =================== Benefits ===================
    B2(["B-2<br/>출석 완료 모달"]):::modal
    B4["B-4<br/>광고 전체화면"]:::benefits
    B5["B-5<br/>미니게임 목록"]:::benefits

    B1 -.-> B2
    B1 --> B4
    B1 --> B5

    %% =================== Ranking ===================
    R2(["R-2<br/>유저 프로필 팝업"]):::modal
    R3["R-3<br/>성장 뱃지 맵"]:::ranking

    R1 -.-> R2
    R1 --> R3

    %% =================== My Page ===================
    MY2["MY-2<br/>내 픽 기록"]:::my
    MY3["MY-3<br/>커뮤니티 활동"]:::my
    MY4["MY-4<br/>스페셜 뱃지"]:::my
    MY5["MY-5<br/>관심 프로그램"]:::my
    MYEdit(["프로필 수정 시트"]):::modal

    MY1 -.-> MYEdit
    MY1 --> MY2
    MY1 --> MY3
    MY1 --> MY4
    MY1 --> MY5
    MY1 --> S1
    MY1 -->|충전 ›| B1
    MY1 -->|성장 기록 ›| R3
    MY1 -->|랭킹 카드| R1
    MY2 --> M4
    MY3 --> C2

    %% =================== Settings ===================
    S1["S-1<br/>환경설정"]:::settings
    S2["S-2<br/>알림 설정<br/>(10토글)"]:::settings
    SNotices(["공지사항"]):::modal
    SInquiry(["문의하기"]):::modal
    STerms(["이용약관"]):::modal
    SPrivacy(["개인정보처리방침"]):::modal
    SLogout(["로그아웃 확인"]):::modal
    SWithdraw(["탈퇴 2단계 확인"]):::modal

    S1 --> S2
    S1 -.-> SNotices
    S1 -.-> SInquiry
    S1 -.-> STerms
    S1 -.-> SPrivacy
    S1 -.-> SLogout
    S1 -.-> SWithdraw
    SLogout --> Login
    SWithdraw --> Login
```

---

### 23-2. Auth / Onboarding 상세 (O-1 ~ O-6)

```mermaid
flowchart LR
    classDef auth fill:#1F2A44,stroke:#0D1424,color:#FFFFFF,font-weight:bold
    classDef shell fill:#2D6CDF,stroke:#1B4DA3,color:#FFFFFF,font-weight:bold
    classDef modal fill:#FFD8E2,stroke:#C03A66,color:#1A1A1A,stroke-dasharray:4 3
    classDef decision fill:#FFFFFF,stroke:#1A1A1A,color:#1A1A1A

    A([앱 실행]) --> O1["O-1<br/>Splash<br/>1.5s"]:::auth
    O1 --> D1{세션?}:::decision
    D1 -->|valid + 완료| HOME["MainShell<br/>/home"]:::shell
    D1 -->|valid + 미완| O3
    D1 -->|없음| O2["O-2<br/>Social Login"]:::auth

    O2 --> O2K["카카오로 계속하기"]:::auth
    O2 --> O2G["구글로 계속하기"]:::auth
    O2 --> O2A["애플로 계속하기"]:::auth
    O2 -.-> O2Find(["Find ID / Reset PW"]):::modal

    O2K --> D2{신규?}:::decision
    O2G --> D2
    O2A --> D2
    D2 -->|기존| HOME
    D2 -->|신규| O3

    O3["O-3<br/>약관 동의<br/>(전체 + 필수3 + 선택2)"]:::auth
    O3 -.-> O3Doc(["보기 → 약관 전문<br/>fullscreenDialog"]):::modal
    O3 --> O4

    O4["O-4<br/>프로필 + 초대코드<br/>(사진/닉네임/성별/생일/코드)"]:::auth
    O4 -.-> O4Pic(["프로필 사진<br/>카메라/앨범"]):::modal
    O4 -.-> O4Nick(["닉네임 중복확인"]):::modal
    O4 -.-> O4Code(["초대코드 검증"]):::modal
    O4 --> O5

    O5["O-5<br/>관심 프로그램<br/>(검색 + 필터 + 카드)"]:::auth
    O5 --> O6

    O6["O-6<br/>가입 완료<br/>닉네임 환영<br/>+100 Pick (+100 보너스)"]:::auth
    O6 --> HOME
```

---

### 23-3. Home / Mission / Notification 상세 (H-1, M-1~M-5, N-1)

```mermaid
flowchart LR
    classDef home fill:#2D6CDF,stroke:#1B4DA3,color:#FFFFFF
    classDef notif fill:#7C4DFF,stroke:#5A35CC,color:#FFFFFF
    classDef community fill:#F0608C,stroke:#C03A66,color:#FFFFFF
    classDef benefits fill:#F4A93C,stroke:#C0801C,color:#1A1A1A
    classDef modal fill:#FFD8E2,stroke:#C03A66,color:#1A1A1A,stroke-dasharray:4 3
    classDef extern fill:#E0E7F1,stroke:#5A6B82,color:#1A1A1A

    subgraph H["Home (H-1)"]
        H1["H-1<br/>홈 메인"]:::home
        HBell(["벨 아이콘"]):::modal
        HSearch(["🔍 검색"]):::modal
        HHero["히어로 슬라이드<br/>최대 4개"]:::home
        HCard["미션 카드"]:::home
        HResult["결과 공개 카드"]:::home
        HNotice["공지 배너"]:::modal
        HSuggest["새 미션 건의<br/>점선 카드"]:::home
        HPick["Pick 잔고 칩"]:::home

        H1 --- HBell
        H1 --- HSearch
        H1 --- HHero
        H1 --- HCard
        H1 --- HResult
        H1 --- HNotice
        H1 --- HSuggest
        H1 --- HPick
    end

    HBell --> N1["N-1<br/>알림 목록<br/>(8가지 타입)"]:::notif
    HPick --> BENE["B-1<br/>혜택 탭"]:::benefits
    HNotice --> BENE
    HSuggest --> C4["C-4<br/>미션 건의"]:::community

    HHero --> M1
    HCard --> M1
    HResult --> M4

    M1["M-1<br/>Mission Detail<br/>선택지 A~D"]:::home
    M1 --> M2(["M-2<br/>참여 확인 시트<br/>· 스레드 공유<br/>· 홈으로 돌아가기"]):::modal
    M2 --> M5["M-5<br/>Mission Share<br/>(미션 미리보기 +<br/>카테고리 + 콘텐츠)"]:::home
    M2 --> H1

    M4["M-4<br/>Mission Result<br/>참여율 막대"]:::home
    M4 --> M5
    M5 -.-> M5Share(["공유 시트<br/>링크/카톡/인스타"]):::modal
    M5 --> C2["C-2<br/>Post Detail"]:::community

    N1 -->|결과/마감/신미션| M4
    N1 -->|댓글| C2
    N1 -->|보상/이벤트| BENE
    N1 -->|랭킹| RANK["R-1<br/>Ranking"]:::extern
    N1 -->|출석 리마인드| BENE
```

---

### 23-4. Community 상세 (C-1 ~ C-5, UM-1 ~ UM-4)

```mermaid
flowchart LR
    classDef community fill:#F0608C,stroke:#C03A66,color:#FFFFFF
    classDef modal fill:#FFD8E2,stroke:#C03A66,color:#1A1A1A,stroke-dasharray:4 3
    classDef extern fill:#E0E7F1,stroke:#5A6B82,color:#1A1A1A

    subgraph CMain["Community Feed (C-1)"]
        C1["C-1<br/>피드 메인"]:::community
        CTab1["전체"]:::community
        CTab2["스레드<br/>+ 카테고리 캐러셀"]:::community
        CTab3["유저 미션<br/>+ 필터칩"]:::community
        CFab(["+ FAB<br/>Create Sheet"]):::modal
        C1 --- CTab1
        C1 --- CTab2
        C1 --- CTab3
        C1 --- CFab
    end

    CFab --> C3["C-3<br/>Compose<br/>(스레드/유저미션/유저투표)"]:::community
    CFab --> C4["C-4<br/>미션 건의"]:::community

    CTab1 --> C2
    CTab2 --> C2
    CTab3 --> UM4

    C2["C-2<br/>Post Detail<br/>댓글 · 좋아요"]:::community
    C2 -.-> CMore(["··· 메뉴 시트"]):::modal
    CMore --> C3
    CMore --> CReport["C-Report<br/>신고"]:::community
    CMore --> CMission["원본 미션 보기<br/>→ M-1"]:::extern

    UM4["UM-4<br/>User Mission Detail<br/>선택지 → 즉시 결과 막대"]:::community
    UM4 --> C2

    C3 -->|작성 완료| C2
    C4 -->|건의 완료| C1
```

---

### 23-5. Benefits / Ranking 상세 (B-1 ~ B-5, R-1 ~ R-3)

```mermaid
flowchart LR
    classDef benefits fill:#F4A93C,stroke:#C0801C,color:#1A1A1A
    classDef ranking fill:#E63946,stroke:#A8202C,color:#FFFFFF
    classDef modal fill:#FFD8E2,stroke:#C03A66,color:#1A1A1A,stroke-dasharray:4 3

    subgraph Bsec["Benefits"]
        B1["B-1<br/>혜택 메인<br/>출석·광고·미니게임"]:::benefits
        B1Att["출석체크 카드<br/>7일 + 🔥 연속"]:::benefits
        B1Ad["광고 카드<br/>잔여 3회"]:::benefits
        B1Game["미니게임 카드<br/>Coming Soon"]:::benefits
        B1 --- B1Att
        B1 --- B1Ad
        B1 --- B1Game
    end

    B1Att --> B2(["B-2<br/>출석 완료 모달<br/>+N Pick · 7일 달력"]):::modal
    B1Ad --> B4["B-4<br/>광고 전체화면<br/>(진행바 + 스킵 타이머)"]:::benefits
    B1Game --> B5["B-5<br/>미니게임 목록<br/>Coming Soon 안내"]:::benefits
    B4 -->|완료| B1

    subgraph Rsec["Ranking"]
        R1["R-1<br/>랭킹 메인<br/>시즌·커뮤니티·전체 탭"]:::ranking
        R1Top["TOP3 포디움"]:::ranking
        R1List["순위 리스트"]:::ranking
        R1Bar["내 순위 바<br/>하단 고정"]:::ranking
        R1 --- R1Top
        R1 --- R1List
        R1 --- R1Bar
    end

    R1List --> R2(["R-2<br/>유저 프로필 팝업<br/>· 뱃지단계+현재순위<br/>· 시즌/전체/정답률<br/>· 스페셜 뱃지<br/>· 딤 탭 닫기"]):::modal
    R1Bar --> R3["R-3<br/>성장 뱃지 맵<br/>9단계 × 3레벨"]:::ranking
```

---

### 23-6. My Page / Settings 상세 (MY-1 ~ MY-5, S-1 ~ S-2)

```mermaid
flowchart LR
    classDef my fill:#2EBFA5,stroke:#1B8C77,color:#FFFFFF
    classDef settings fill:#3F4756,stroke:#1F2530,color:#FFFFFF
    classDef modal fill:#FFD8E2,stroke:#C03A66,color:#1A1A1A,stroke-dasharray:4 3
    classDef extern fill:#E0E7F1,stroke:#5A6B82,color:#1A1A1A
    classDef danger fill:#E63946,stroke:#A8202C,color:#FFFFFF

    subgraph MYsec["My Page (MY-1)"]
        MY1["MY-1<br/>마이 메인"]:::my
        MY1Set["⚙ 환경설정"]:::my
        MY1Pic["프로필 + ✏ 편집"]:::my
        MY1Rank["랭킹 3종 카드<br/>시즌/전체/커뮤니티"]:::my
        MY1Pick["보유 픽 + 충전 ›"]:::my
        MY1Grow["성장 바 + 성장 기록 ›"]:::my
        MY1Code["내 초대코드 + 복사"]:::my
        MY1Menu["메뉴 4종"]:::my
        MY1 --- MY1Set
        MY1 --- MY1Pic
        MY1 --- MY1Rank
        MY1 --- MY1Pick
        MY1 --- MY1Grow
        MY1 --- MY1Code
        MY1 --- MY1Menu
    end

    MY1Pic -.-> MYEdit(["프로필 수정 시트<br/>닉네임 변경"]):::modal
    MY1Rank --> RANK["R-1<br/>랭킹"]:::extern
    MY1Pick --> BENE["B-1<br/>혜택"]:::extern
    MY1Grow --> RANK_G["R-3<br/>성장 뱃지 맵"]:::extern
    MY1Code -.-> MYCopy(["초대코드가<br/>복사됐어요! 토스트"]):::modal
    MY1Set --> S1

    MY1Menu --> MY2["MY-2<br/>내 픽 기록<br/>전체/정답/오답/대기"]:::my
    MY1Menu --> MY3["MY-3<br/>커뮤니티 활동<br/>글·댓글 탭"]:::my
    MY1Menu --> MY4["MY-4<br/>스페셜 뱃지<br/>획득/미획득 그리드"]:::my
    MY1Menu --> MY5["MY-5<br/>관심 프로그램<br/>검색 + 칩"]:::my

    MY2 --> MissionResult["미션 결과<br/>→ M-4"]:::extern
    MY3 --> PostDetail["글 상세<br/>→ C-2"]:::extern

    subgraph Ssec["Settings"]
        S1["S-1<br/>환경설정"]:::settings
        S1Acc["연결 계정<br/>(카카오/구글/애플)"]:::settings
        S1Ver["앱 버전"]:::settings
        S1 --- S1Acc
        S1 --- S1Ver
    end

    S1 --> S2["S-2<br/>알림 설정<br/>10토글"]:::settings
    S1 -.-> SDocs(["공지/문의/약관/<br/>처리방침"]):::modal
    S1 -.-> SLogout(["로그아웃 확인"]):::modal
    S1 -.-> SWith(["탈퇴 2단계 확인"]):::danger

    SLogout --> AUTH["/login<br/>O-2"]:::extern
    SWith --> AUTH
```

---

### 23-7. 라우팅 스택 분류 (push vs tab)

```mermaid
flowchart TB
    classDef tab fill:#2EBFA5,stroke:#1B8C77,color:#FFFFFF,font-weight:bold
    classDef push fill:#F0608C,stroke:#C03A66,color:#FFFFFF
    classDef root fill:#1F2A44,stroke:#0D1424,color:#FFFFFF,font-weight:bold

    Root[["rootNavigatorKey<br/>전체 화면 push"]]:::root

    subgraph Tabs["StatefulShellRoute · BottomNav 5탭<br/>(NoTransitionPage)"]
        TR["/ranking"]:::tab
        TC["/community"]:::tab
        TH["/home"]:::tab
        TB["/benefits"]:::tab
        TM["/my"]:::tab
    end

    subgraph PushPages["push (rootNavigatorKey)"]
        PAuth["/login · /signup/* · /account/*"]:::push
        PMission["/mission/:id<br/>/result · /share"]:::push
        PComm["/community/post/:id<br/>compose · report<br/>user-missions/:id"]:::push
        PNotif["/notifications"]:::push
        PRank["/ranking/growth"]:::push
        PBenefits["/benefits/ad-watch<br/>/benefits/mini-games"]:::push
        PMy["/my/pick-history<br/>/community-activity<br/>/badges · /interested-programs"]:::push
        PSettings["/settings<br/>/settings/notifications<br/>/settings/notices · inquiry<br/>· terms · privacy"]:::push
    end

    Root --> Tabs
    Root --> PushPages

    Tabs -.->|push| PushPages
```

---

*생성일: 구현 스냅샷 기준 · Mermaid는 GitHub / VS Code / Cursor에서 미리보기 가능*