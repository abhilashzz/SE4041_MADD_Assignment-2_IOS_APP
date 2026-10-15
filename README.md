# StudySpot - iOS Study Space & Session Tracking App

An iOS application built for students to discover productive study spots (libraries, quiet cafés), view them on an interactive map, save favorite venues, and track study sessions with progress statistics.

---

### Student & Project Information
- **Student Name:** Abhilash K A T W
- **Student ID:** IT22081698
- **Module:** SE4041 - Mobile Application Design and Development
- **App Name:** StudySpot
- **Bundle Identifier:** `com.abhilashzz.studyspot`
- **Platform:** iOS 17.0+ | Swift 5.9+ | SwiftUI | Core Data | MapKit

---

## What the App Does

StudySpot solves the problem of finding productive study spaces and keeping track of academic habits:

1. **Explore Study Spots:**
   - Search and discover quiet cafés and libraries.
   - Filter by category (Libraries, Cafés, Study Hubs) and amenities (Wi-Fi, Power Outlets, Quiet, Coffee).

2. **Interactive Map (MapKit):**
   - Visualize study locations on an interactive Apple Map.
   - Custom map pins for libraries and cafés.
   - One-tap directions handoff to Apple Maps.

3. **Place Details & Observations:**
   - View detailed venue info, opening hours, and address.
   - Record personal observations for Wi-Fi availability, power sockets, and noise levels.
   - Add private personal study notes for each spot.

4. **Saved Places (Core Data Offline Persistence):**
   - Save favorite spots for quick offline access.
   - Safe un-saving retains logged study history even if a bookmark is removed.

5. **Study Sessions & Progress Tracking:**
   - Log completed study sessions (duration in minutes and 1–5 star focus rating).
   - View aggregate analytics (total study time, session count, average focus rating).
   - Visual weekly study chart to monitor study habits.

---

## Project Folder Structure

```text
StudySpot/
├── App/
│   ├── StudySpotApp.swift          # App entry point (@main)
│   └── AppState.swift              # Global navigation and tab coordination
├── Model/
│   ├── Place.swift                 # Core Data NSManagedObject entity
│   ├── StudySession.swift          # Core Data NSManagedObject entity
│   ├── PlaceDTO.swift              # Transfer object for UI and MapKit search
│   ├── StudySessionDraft.swift     # Form draft model for logging sessions
│   ├── StudyPlaceCategory.swift    # Category enum (Café, Library, etc.)
│   ├── Observations.swift          # Wi-Fi, Power, and Noise rating models
│   └── StudyProgressAggregate.swift# Summary analytics and chart data models
├── Persistence/
│   ├── PersistenceController.swift # Core Data NSPersistentContainer setup
│   ├── PlaceRepository.swift       # Place CRUD, deduplication & safe unfavourite
│   ├── SessionRepository.swift     # Session CRUD, validation & aggregate stats
│   └── StudySpot.xcdatamodeld/     # Core Data schema model definition
├── Services/
│   ├── MapKitSearchService.swift   # Apple MKLocalSearch integration with debouncing
│   ├── CoreLocationService.swift   # On-demand GPS location service
│   ├── MockPlaceSearchService.swift# Offline and fallback search provider
│   └── MockLocationService.swift   # Deterministic location provider for testing
├── ViewModels/
│   ├── ExploreViewModel.swift      # Search, filter, and discovery logic
│   ├── MapViewModel.swift          # Map region, camera, and selection logic
│   ├── PlaceDetailsViewModel.swift # Venue details, notes editing, and session creation
│   ├── SavedPlacesViewModel.swift  # Saved bookmarks list and search
│   └── ProgressViewModel.swift     # Time period filtering and progress analytics
├── Views/
│   ├── MainTabView.swift           # Root 4-tab bar coordinator
│   ├── Explore/                    # Explore screen and area selector sheet
│   ├── Map/                        # MapKit interactive map screen
│   ├── Details/                    # Place details, notes sheet, log session sheet
│   ├── Saved/                      # Saved places bookmarks screen
│   ├── Progress/                   # Study statistics and progress chart screen
│   └── Settings/                   # About screen
├── Components/
│   ├── StudyPlaceCard.swift        # Reusable place card component
│   ├── PrimaryButtonStyle.swift    # Custom branded button styles
│   ├── ObservationChip.swift       # Amenity indicator chips
│   ├── ProgressStatCard.swift      # Analytics metric cards
│   ├── EmptyStateView.swift        # Empty & error state placeholder views
│   └── StudyIllustrationView.swift # Native vector banner illustrations
├── Theme/
│   └── StudySpotTheme.swift        # Brand colors, typography tokens & dark mode
└── Resources/
    ├── Assets.xcassets/            # AppIcon and AccentColor assets
    └── Info.plist                  # Location permissions configuration

StudySpot.xcodeproj/                # Xcode project configuration and shared scheme
Tests/
└── StudySpotTests/                 # XCTest Unit test suites
UITests/
└── StudySpotUITests/               # XCTest UI automation test suite
```

---

## How to Run the Project

### Requirements
- Mac with macOS 14.0 (Sonoma) or newer
- Xcode 15.0 or newer
- iOS 17.0+ Simulator or physical iPhone

### Steps
1. Open the project in Xcode:
   Double-click `StudySpot.xcodeproj` or run:
   ```bash
   open StudySpot.xcodeproj
   ```
2. In the top toolbar, select the **StudySpot** scheme.
3. Choose your target (e.g., **iPhone 15 Pro** simulator).
4. Press **Cmd + R** to Build and Run the app.
5. Press **Cmd + U** to execute all Unit and UI test suites.
