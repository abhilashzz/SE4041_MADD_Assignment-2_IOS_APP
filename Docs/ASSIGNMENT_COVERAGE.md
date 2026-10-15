# Assignment Coverage & Requirements Traceability Matrix

**Module:** SE4041 - Mobile Application Design and Development  
**Assignment:** Assignment 02 - Swift (Part A: Advanced iOS App)  
**Student:** Abhilash K A T W (IT22081698)  
**Application:** StudySpot (`com.abhilashzz.studyspot`)  

---

## 1. Summary of Requirements & Evidence Mapping

| Rubric / Syllabus Area | Brief Requirement | Implementation in StudySpot | File & Evidence Reference |
|---|---|---|---|
| **Purpose & Target Audience** | Advanced iOS app meeting genuine student needs. | Solves study spot discovery, personal observations, and tracking study sessions. | [`README.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/README.md), [`Docs/REPORT_DRAFT.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/REPORT_DRAFT.md) |
| **Advanced UI & Layout** | Five main screens, custom components, responsive layout, animations. | 4 persistent tabs + pushed Place Details, adaptive stack, custom card transitions, Reduce Motion. | [`Views/MainTabView.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Views/MainTabView.swift), [`Theme/StudySpotTheme.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Theme/StudySpotTheme.swift) |
| **Custom SwiftUI Controls** | Tailored UI components with consistent theme tokens. | `StudyPlaceCard`, `PrimaryButtonStyle`, `ObservationChip`, `ProgressStatCard`, `EmptyStateView`, `StudyIllustrationView`. | [`Components/`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Components/) |
| **Architecture & Navigation** | NavigationStack, MVVM, and Dependency Injection. | NavigationStack per tab, @MainActor ViewModels, protocols for search, location, and persistence. | [`App/AppState.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/App/AppState.swift), [`ViewModels/`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/ViewModels/) |
| **Local Persistence** | Durable Core Data storage, entity relationships, complete CRUD. | SQLite-backed `.xcdatamodeld`, explicit `Place` and `StudySession` NSManagedObjects, safe unfavourite, permanent cascade delete. | [`Persistence/StudySpot.xcdatamodeld`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Persistence/StudySpot.xcdatamodeld), [`Persistence/PlaceRepository.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Persistence/PlaceRepository.swift), [`Persistence/SessionRepository.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Persistence/SessionRepository.swift) |
| **Deduplication Strategy** | Practical deduplication to avoid clone records on repeat saves. | Automatic deduplication by `providerId` or normalized name and proximity coordinates (~100m). | [`Persistence/PlaceRepository.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Persistence/PlaceRepository.swift#L66-L108), [`Tests/StudySpotTests/PlaceDeduplicationTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/PlaceDeduplicationTests.swift) |
| **Networking & Search** | Real venue discovery with error states, retry, and cancellation. | `MKLocalSearch` with query debouncing, obsolete request cancellation, offline detection, retry buttons. | [`Services/MapKitSearchService.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Services/MapKitSearchService.swift), [`ViewModels/ExploreViewModel.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/ViewModels/ExploreViewModel.swift) |
| **Advanced Framework Integration** | Meaningful MapKit & Core Location integration permitted by syllabus. | Real SwiftUI Map, category markers, "Search this area", "Near Me" When-In-Use location, Apple Maps directions handoff. | [`Views/Map/StudyMapView.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Views/Map/StudyMapView.swift), [`Services/CoreLocationService.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Services/CoreLocationService.swift) |
| **Data Integrity & Honesty** | No fabricated venue facts (Wi-Fi, quietness, hours) from public maps. | MapKit returns public venue names/locations; personal Wi-Fi/Power/Noise start Unknown and are clearly labelled as private user observations. | [`Model/Observations.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Model/Observations.swift), [`Views/Details/EditNotesSheet.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Views/Details/EditNotesSheet.swift) |
| **Demonstration Mode** | Deterministic fixtures without corrupting real user progress. | Isolated demo SQLite store (`StudySpot_Demo.sqlite`) with Leaf & Latte, Quiet Corner Library, and Campus Commons. | [`Persistence/PersistenceController.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Persistence/PersistenceController.swift#L24-L35), [`Services/MockPlaceSearchService.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Services/MockPlaceSearchService.swift) |
| **Accessibility & Dark Mode** | Dynamic Type, VoiceOver, high contrast, Reduce Motion. | Full semantic light/dark palettes, accessibility labels/traits on all controls, alternative to colour indicators. | [`Theme/StudySpotTheme.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Theme/StudySpotTheme.swift), [`Components/`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/StudySpot/Components/) |
| **Automated Testing** | Comprehensive unit & UI tests for core logic, persistence, and navigation. | 7 unit test suites + UI test suite with temporary in-memory/disk stores. | [`Tests/StudySpotTests/`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/), [`UITests/StudySpotUITests/`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/UITests/StudySpotUITests/) |
| **Documentation & Packaging** | User guide, technical guide, report draft, demo script, AI logs, Mac handoff. | 10 complete markdown documents covering all academic requirements. | [`Docs/`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/) |
| **Version Control & Git** | Real Git commits, feature branch, merge, and remote push. | Feature branch workflow, descriptive atomic commit messages, remote verified on GitHub. | Verified via Git commands and remote reference checks. |

---

## 2. CRUD Operations Acceptance Verification

| CRUD Operation | Target Entity | User Action & Path | Acceptance Criteria Met |
|---|---|---|---|
| **Create** | `Place` | Tap bookmark in Explore / Map, or save observations in Details. | Stored in SQLite via `PlaceRepository.savePlace()`. Deduplicated if previously saved. |
| **Create** | `StudySession` | Tap "+ Log study session" on Details screen. | Validates duration (1–240m) and focus (1–5). Immediately updates Recent Sessions & Progress. |
| **Read** | `Place` | Explore cards, Map markers, Saved Places list, Place Details. | Live fetch or query filtered by text/category. Offline readability guaranteed. |
| **Read** | `StudySession` | Details screen recent preview, Progress hero stats, weekly chart. | Aggregates computed for This week, This month, and All time. |
| **Update** | `Place` | Tap pencil icon next to "Your study notes" on Details / Saved. | Prefilled sheet edits Wi-Fi, Power, Noise, and personal note text. Committed on Save. |
| **Update** | `StudySession` | Tap pencil icon next to recent session on Progress screen. | Prefilled sheet modifies duration, focus rating, date, and note. Totals refresh immediately. |
| **Delete (Unsave)** | `Place` (Bookmark) | Tap bookmark in Explore/Details or swipe Unsave in Saved Places. | Unsets `isSaved = false`. **Retains place and session history!** |
| **Delete (Permanent)** | `Place` (Record) | Tap "..." on Details or context menu in Saved Places. | Discloses number of linked sessions. Permanently deletes place and linked sessions upon confirmation. |
| **Delete** | `StudySession` | Tap "..." -> "Delete Session" on Progress screen. | Deletes session record. Dynamically recalculates total hours, session count, and chart. |
