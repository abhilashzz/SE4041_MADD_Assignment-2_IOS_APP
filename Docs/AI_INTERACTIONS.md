# AI Assistance & Interaction Record

**Module:** SE4041 - Mobile Application Design and Development  
**Assignment:** Assignment 02 - Swift (Part A: Advanced iOS App)  
**Student:** Abhilash K A T W (IT22081698)  
**Tool / Assistant:** Google Antigravity (Powered by Gemini 3.8 Flash High)  
**Primary Interaction Date:** October 15, 2026  

---

## Academic Integrity Statement
In compliance with SLIIT assessment regulations and course guidelines for SE4041, all AI assistance utilized during the scoping, architecture, authoring, and documentation of StudySpot is fully disclosed below. No proprietary or pre-compiled third-party binaries were introduced; all code was authored specifically for this project in native Swift and SwiftUI.

---

## Interaction Log

### Entry 1: Architecture & Project Scaffolding
- **Date / Time:** 2026-10-15 14:52:30 IST
- **Purpose:** Analyze assignment requirements, parse reference UI design image, establish native project structure, and author Core Data model schema.
- **Prompt Summary:**
  > *"Build StudySpot, my complete native iOS assignment app, from the attached five-screen UI design through functional implementation, documentation, Git commits and GitHub push. Student: Abhilash K A T W, ID: IT22081698, Module: SE4041. Use Swift, SwiftUI, iOS 17+, MVVM, MapKit, Core Location, Core Data. Deliver a real StudySpot.xcodeproj with shared scheme, unit/UI test targets, assets, Info settings and complete CRUD."*
- **Assistant Actions & Response:**
  - Preserved original design reference board under `Design/StudySpot_UI_5_Screens.png`.
  - Created directory architecture separating `App`, `Model`, `Persistence`, `Services`, `ViewModels`, `Views`, `Components`, `Theme`, `Resources`, `Tests`, `UITests`, `Scripts`, and `Docs`.
  - Authored valid Core Data model schema `StudySpot.xcdatamodeld` with `Place` and `StudySession` entities, setting `codeGenerationType="manual"` to avoid duplicate class collisions.
  - Generated `project.pbxproj` and `StudySpot.xcscheme` targets.
- **Files Accepted:** All scaffolded directories, `contents` Core Data XML, `project.pbxproj`, `StudySpot.xcscheme`.
- **Modifications / Corrections:**
  - Initially, Windows command line length limit truncated `project.pbxproj` when executed via shell echo; corrected by utilizing direct file write tooling.
  - Enforced `codeGenerationType="manual"` explicitly so Xcode would not automatically generate hidden Swift classes conflicting with explicit `Place.swift` and `StudySession.swift`.
- **What Was Learned:** Understanding how Xcode's `.pbxproj` manages build phases (Sources, Frameworks, Resources) and how manual Core Data code generation prevents duplicated class symbols at link time.

---

### Entry 2: Data Persistence & Complete CRUD Implementation
- **Date / Time:** 2026-10-15 15:05:00 IST
- **Purpose:** Implement Core Data entities, repositories, deduplication rules, and safe unfavourite semantics.
- **Prompt Focus:** Ensuring that saving a place repeatedly does not duplicate records, that unfavouriting preserves completed sessions, and that invalid session values (duration/rating) are rejected.
- **Assistant Actions & Response:**
  - Implemented `Place.swift` and `StudySession.swift` subclasses with `toDTO()` mapping functions.
  - Authored `PlaceRepository.swift` with two-tier deduplication (by `providerId` first, then normalized name and coordinates within ~100m).
  - Authored `SessionRepository.swift` enforcing duration bounds (1...240 min) and focus rating (1...5 stars).
  - Implemented `StudyProgressAggregate.swift` with date range filtering (`This week`, `This month`, `All time`) and daily bar chart breakdown.
- **Files Accepted:** `Place.swift`, `StudySession.swift`, `PlaceRepository.swift`, `SessionRepository.swift`, `Observations.swift`, `PlaceDTO.swift`, `StudySessionDraft.swift`, `StudyProgressAggregate.swift`.
- **What Was Learned:** Why decoupling UI state through immutable DTO structs (`PlaceDTO`, `StudySessionDTO`) prevents SwiftUI view crashes from managed object faulting and background thread context races.

---

### Entry 3: MapKit Discovery & Core Location Privacy
- **Date / Time:** 2026-10-15 15:07:30 IST
- **Purpose:** Integrate real `MKLocalSearch`, interactive SwiftUI Map, visible region search, and user-initiated "Near Me" location authorization.
- **Prompt Focus:** Avoid inventing venue suitability data; ensure live search does not overwrite with stale requests when typing rapidly; handle offline and denied location states gracefully.
- **Assistant Actions & Response:**
  - Authored `MapKitSearchService.swift` with task cancellation and Combine debouncing.
  - Authored `CoreLocationService.swift` requesting `requestWhenInUseAuthorization()` only when the user explicitly taps "Near Me".
  - Created `MockPlaceSearchService.swift` and isolated demo database `StudySpot_Demo.sqlite` for deterministic testing and preview rendering.
- **Files Accepted:** `PlaceSearchServiceProtocol.swift`, `MapKitSearchService.swift`, `MockPlaceSearchService.swift`, `LocationServiceProtocol.swift`, `CoreLocationService.swift`, `MockLocationService.swift`.
- **What Was Learned:** How asynchronous `MKLocalSearch` instances can return out-of-order, and how cancellation tokens combined with debouncing prevent UI flickering and race conditions.

---

### Entry 4: Five Screens UI & Custom Components
- **Date / Time:** 2026-10-15 15:10:00 IST
- **Purpose:** Construct declarative SwiftUI views matching the attached five-screen cream/teal design identity.
- **Prompt Focus:** Follow the five screens strictly: Explore, Map, Place Details (pushed destination), Saved Places, My Progress. Provide native vector artwork, dynamic colors, VoiceOver accessibility, and minimum 44 pt touch targets.
- **Assistant Actions & Response:**
  - Implemented `StudySpotTheme.swift` with dynamic light/dark mode color palettes and spacing tokens.
  - Authored custom components: `StudyPlaceCard`, `PrimaryButtonStyle`, `ObservationChip`, `ProgressStatCard`, `EmptyStateView`, and vector `StudyIllustrationView`.
  - Built all five main screens and sheets (`ExploreView`, `StudyMapView`, `PlaceDetailsView`, `SavedPlacesView`, `ProgressView`, `AboutView`, `EditNotesSheet`, `LogSessionSheet`, `AreaPickerSheet`).
  - Rendered a high-resolution 1024x1024 universal `AppIcon.png` with book and pin mark.
- **Files Accepted:** All view and component files under `Views/`, `Components/`, `Theme/`, and `Resources/`.
- **What Was Learned:** How `NavigationStack` manages hierarchical navigation independently within tabs, and how semantic SwiftUI color definitions automatically respond to system light/dark mode changes.

---

### Entry 5: Automated Testing & Verification
- **Date / Time:** 2026-10-15 15:16:00 IST
- **Purpose:** Author unit tests, UI tests, and the Mac verification script.
- **Assistant Actions & Response:**
  - Implemented 7 unit test suites in `Tests/StudySpotTests/` covering validation, deduplication, CRUD, cascade rules, date aggregation, cancellation, and store reopening.
  - Implemented UI tests in `UITests/StudySpotUITests/StudySpotFlowUITests.swift`.
  - Created `Scripts/verify_macos.sh` to automate Xcode detection, destination discovery, compilation, and test execution on macOS.
- **Files Accepted:** All test files and shell verification script.
- **What Was Learned:** How unit tests using an in-memory Core Data store (`/dev/null`) run orders of magnitude faster while maintaining database isolation across test runs.
