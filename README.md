# StudySpot - Native iOS Application

**Advanced iOS Application for Students to Discover, Note, and Track Completed Study Sessions.**

---

### Academic & Student Metadata
- **Student Name:** Abhilash K A T W
- **Student ID:** IT22081698
- **Module:** SE4041 - Mobile Application Design and Development
- **Assignment:** Assignment 02 - Swift (Part A: Advanced iOS App)
- **Repository:** [https://github.com/abhilashzz/SE4041_MADD_Assignment-2_IOS_APP.git](https://github.com/abhilashzz/SE4041_MADD_Assignment-2_IOS_APP.git)
- **Bundle Identifier:** `com.abhilashzz.studyspot`
- **Target OS:** iOS 17.0+
- **Frameworks:** Swift 5.9, SwiftUI, MapKit, Core Location, Core Data

---

## 1. Project Purpose & Overview

Finding a quiet, productive place to study is a universal challenge for students. Commercial venue listings often advertise crowded social spots and fail to capture whether a location has reliable Wi-Fi, available power outlets, or a quiet atmosphere suited for deep work.

**StudySpot** is a native iOS application built exclusively with Apple frameworks to solve this problem:
1. **Discover Study Spots:** Uses real Apple **MapKit** local search (`MKLocalSearch`) to locate libraries, study spaces, and quiet cafés across any geographic area (defaulting to Colombo, Sri Lanka).
2. **Interactive Map Exploration:** Provides an interactive SwiftUI map with category-specific pins, search within the visible camera region, and location-aware **"Near Me"** discovery using Core Location.
3. **Personal Study Notes & Observations:** Allows students to record and maintain private observations regarding **Wi-Fi availability**, **power outlet access**, and **ambient noise levels**, accompanied by personal study notes.
4. **Directions Handoff:** Directly opens Apple Maps navigation to the destination venue using native public APIs.
5. **Study Session Logging & Aggregate Progress:** Students log completed study sessions (1–240 minutes, 1–5 focus rating). The app dynamically computes total study time, session counts, average focus, and renders an accessible weekly study chart.
6. **Durable Core Data Persistence:** Full CRUD operations backed by a persistent SQLite database with safe unfavourite semantics (removing a bookmark never erases session history).

---

## 2. Five Main Screens & Feature Summary

| # | Screen | Key Actions & Capabilities |
|---|---|---|
| **01** | **Explore** | Brand header, area selector pill ("Colombo v"), live search field, category chips (All, Libraries, Cafés), warm study banner illustration, study place result cards with instant bookmarking, empty/error/loading states. |
| **02** | **Map** | Real SwiftUI Map, custom category markers (library book / cafe cup), "Search this area" button, "Near Me" location button, floating bottom preview card with "View place" navigation. |
| **03** | **Place Details** | Category banner artwork, place metadata, Save/Saved toggle, Directions button (Apple Maps handoff), personal Wi-Fi/Power/Noise observation chips, recent session preview, "+ Log study session" button, permanent deletion menu. |
| **04** | **Saved Places** | "Your saved places" heading, subtitle "Good spaces, kept close.", live filter search bar, saved place cards showing personal notes, swipe-to-unsave, edit notes sheet, private notes information callout. |
| **05** | **My Progress** | Period selector (This week / This month / All time), Hero study time card ("3h 30m"), stat grid (Sessions count, Average focus), weekly study bar chart, recent session cards with edit and delete actions. |

> *Note:* Settings, About, Edit Notes, Area Selection, and Log Session are presented as modal sheets, preserving the clean five-screen core navigation flow.

---

## 3. UI Design Identity & Reference

The visual design follows a warm cream/teal aesthetic inspired by student study cafes:
- **Light Palette:** Background `#F6F7F2`, Surfaces `#FFFFFF`, Deep Teal Primary `#176459`, Main Text `#183B36`, Mint `#E6F0E9`, Muted Text `#70817C`, Separators `#DEE5E0`, Warm Gold Accent `#EBC77A`.
- **Semantic Dark Mode:** Background `#111817`, Surfaces `#1B2423`, Primary `#359183`, Main Text `#E8F0EE`, Mint `#1D332F`.
- **Typography & Layout:** System SF typography with Dynamic Type scaling, 28–32 pt serif headings, 20–24 pt rounded card corners, 44 pt minimum touch targets, and full Reduce Motion support.
- **Visual Assets:** Includes custom native vector illustrations (Warm Study Banner, Cafe Interior, Library Shelves, and Book & Location Pin brand mark) plus a generated 1024x1024 App Icon.
- The original design reference is preserved under [`Design/StudySpot_UI_5_Screens.png`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Design/StudySpot_UI_5_Screens.png).

---

## 4. Architecture & Technical Design

The app follows standard **MVVM (Model-View-ViewModel)** and **Repository Pattern** architectures:

```
StudySpot/
├── App/                      # App entry point & global AppState (MainActor)
├── Model/                    # Entities, DTOs, Enums, Form Drafts, Aggregates
├── Persistence/              # Core Data model (.xcdatamodeld) & Repositories
├── Services/                 # MapKit search, CoreLocation & Mock services
├── ViewModels/               # Observable ViewModels with debounced search
├── Views/                    # SwiftUI screens (Explore, Map, Details, Saved, Progress)
├── Components/               # Reusable UI components (Cards, Chips, Stats, Buttons)
├── Theme/                    # Design tokens & dynamic semantic colors
└── Resources/                # Asset catalogs, AppIcon, Info.plist
```

### Core Data Persistence & CRUD
- **Place Entity:** `id` (UUID), `providerId` (String?), `name` (String), `address` (String), `latitude` (Double), `longitude` (Double), `category` (String), `isSaved` (Bool), `personalNote` (String?), `wifiObservation`, `powerObservation`, `noiseObservation`, `createdAt`, `updatedAt`, `sessions` (To-Many relationship).
- **StudySession Entity:** `id` (UUID), `completedAt` (Date), `durationMinutes` (Int16, 1–240), `focusRating` (Int16, 1–5), `note` (String?), `place` (To-One relationship).
- **Deduplication:** Automatic matching by `providerId` or normalized name and coarse coordinates (~100m) prevents duplicate database records upon repeated saves.
- **Safe Unfavourite:** Setting `isSaved = false` retains the place record and all completed session history.
- **Permanent Deletion:** An explicit action requiring confirmation disclosing the exact number of linked sessions before cascading deletion.

---

## 5. Setup & Running the Project (Mac Tester Handoff)

### Prerequisites
- macOS Sonoma or later
- Xcode 15.0 or later with iOS 17+ Simulator runtime installed
- Git

### Build & Run Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/abhilashzz/SE4041_MADD_Assignment-2_IOS_APP.git
   cd SE4041_MADD_Assignment-2_IOS_APP
   ```
2. Open `StudySpot.xcodeproj` in Xcode:
   ```bash
   open StudySpot.xcodeproj
   ```
3. Select the shared **StudySpot** scheme.
4. Choose an iPhone Simulator (e.g., iPhone 15 or iPhone 16 running iOS 17+).
5. Press **Cmd + R** to build and run the app.
6. Press **Cmd + U** to run all unit tests and UI tests.

### Automated Mac Verification Script
A shell script is provided to verify Xcode, detect an active Simulator, build the project, and run unit tests automatically:
```bash
chmod +x Scripts/verify_macos.sh
./Scripts/verify_macos.sh
```

---

## 6. Verification Status & Known Limitations

- **Windows Static Checks:** **PASSED** (All 58 Swift source files, Core Data schema, shared schemes, assets, and tests verified for structural consistency).
- **Mac Build & Runtime Tests:** **NOT RUN** (Authoring completed on Windows; native compilation, Simulator execution, and VoiceOver audio verification must be conducted on the Mac tester's environment).
- **Offline Capability:** Saved places, personal observations, and completed session history work completely offline. Live map tile rendering and active MapKit venue search require an active internet connection.

---

## 7. Documentation Index

- [`Docs/ASSIGNMENT_COVERAGE.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/ASSIGNMENT_COVERAGE.md) - Complete mapping to assignment requirements.
- [`Docs/USER_GUIDE.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/USER_GUIDE.md) - Step-by-step user instructions.
- [`Docs/TECHNICAL_GUIDE.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/TECHNICAL_GUIDE.md) - Deep-dive architecture and persistence guide.
- [`Docs/REPORT_DRAFT.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/REPORT_DRAFT.md) - Academic assignment report.
- [`Docs/DEMO_SCRIPT.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/DEMO_SCRIPT.md) - 5-minute presentation / video script.
- [`Docs/AI_INTERACTIONS.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/AI_INTERACTIONS.md) - Transparent AI assistance record.
- [`Docs/TEST_RESULTS.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/TEST_RESULTS.md) - Unit/UI test specifications and status.
- [`Docs/BUILD_STATUS.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/BUILD_STATUS.md) - Build integrity matrix.
- [`Docs/MAC_HANDOFF.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/MAC_HANDOFF.md) - Mac testing instructions and return checklist.
- [`Docs/VIVA_GUIDE.md`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Docs/VIVA_GUIDE.md) - Comprehensive viva preparation guide.
