# SE4041 - Mobile Application Design and Development
## Assignment 02 - Swift (Part A: Advanced iOS App)
# Individual Project Report: StudySpot

**Student Name:** Abhilash K A T W  
**Student ID:** IT22081698  
**Module Code:** SE4041 - MADD  
**Degree Programme:** BSc (Hons) in Information Technology / Software Engineering  
**Academic Institution:** Sri Lanka Institute of Information Technology (SLIIT)  
**Submission Date:** November 2026  

---

## Executive Summary

Finding a focused and distraction-free study space is a frequent struggle for undergraduate and postgraduate students. Standard location discovery tools, such as generic commercial map applications, prioritize reviews, commercial advertisements, and food photos over student-specific study requirements. Consequently, students frequently commute to venues only to discover inadequate Wi-Fi, absent power outlets, or excessive ambient noise levels.

**StudySpot** is an individual native iOS application engineered in Swift and SwiftUI, targeting iOS 17.0+. The application combines Apple's native **MapKit** framework for geographic venue discovery with durable **Core Data** local persistence and interactive study session tracking. By allowing students to record personal suitability observations (Wi-Fi availability, power socket density, and noise level) alongside actual logged study sessions (duration and focus ratings), StudySpot provides an innovative, private platform for students to discover, evaluate, and track their personal study environments.

This report documents the architectural design, software implementation, accessibility conformance, automated testing methodology, and engineering trade-offs made during the development of StudySpot.

---

## 1. Problem Statement & Student Needs Analysis

### 1.1 The Student Study Space Dilemma
Contemporary students require a variety of study settings tailored to their changing academic tasks. Deep individual revision demands quiet libraries or silent study halls, whereas group projects require lively cafes with accessible electrical power. Conventional commercial directories fail to answer three fundamental questions:
1. *Is this location actually quiet enough for sustained academic concentration?*
2. *Can I reliably charge my laptop or tablet during a 3-hour study block?*
3. *How effective and focused was my historical study time at this specific place compared to others?*

### 1.2 Target Audience & User Persona
- **Primary Users:** University students, researchers, and independent learners.
- **Key Pain Points:** Unreliable venue information, battery anxiety due to unknown outlet availability, and lack of correlation between study environments and academic focus.
- **Product Proposition:** A private, zero-account utility that turns public venue discovery into a personalized, data-driven study companion.

---

## 2. Innovative Scope: Connecting Observations to Study Progress

Unlike passive directories that display crowdsourced or fabricated venue attributes, StudySpot enforces an **honest personal data model**:
- **Objective Public Data:** MapKit supplies verified geographical locations, coordinates, and physical addresses.
- **Subjective Personal Observations:** Wi-Fi availability, power outlet adequacy, and noise levels are initialized to `Unknown` and updated exclusively by the student.
- **The Innovation Link:** Completed study sessions (recording duration in minutes and a 1–5 focus rating) are linked via a Core Data relational schema to the study place. Students can directly review their cumulative study time and average focus rating for each spot, objectively revealing which spaces foster their greatest academic productivity.

---

## 3. System Architecture & Design Patterns

### 3.1 Architectural Overview (MVVM + Repository)
StudySpot strictly adheres to Apple's modern SwiftUI architecture:
- **Model Layer:** Encapsulates the Core Data managed objects (`Place`, `StudySession`) and lightweight immutable value types (`PlaceDTO`, `StudySessionDTO`, `StudySessionDraft`).
- **Persistence Layer:** `PersistenceController` manages an SQLite-backed store with automatic lightweight migration support, while `PlaceRepository` and `SessionRepository` isolate data operations.
- **Service Layer:** Protocol-oriented networking abstractions (`PlaceSearchServiceProtocol`, `LocationServiceProtocol`) wrap `MKLocalSearch` and `CLLocationManager`.
- **ViewModel Layer:** Observable classes (`ExploreViewModel`, `MapViewModel`, `PlaceDetailsViewModel`, `SavedPlacesViewModel`, `ProgressViewModel`) coordinate UI state updates safely on the `@MainActor`.
- **View Layer:** Declarative SwiftUI views with high component reusability (`StudyPlaceCard`, `PrimaryButtonStyle`, `ObservationChip`, `ProgressStatCard`, `EmptyStateView`).

### 3.2 Five Main Screens Navigation Flow
1. **Explore (Tab 0):** Brand identity, search area selection (Colombo default), keyword search, category chips, warm study banner, and discovery cards.
2. **Map (Tab 1):** Real interactive SwiftUI Map, custom category markers, "Search this area" bounding-box queries, "Near Me" location centering, and bottom selection preview card.
3. **Place Details (Pushed Destination):** Banner illustration, Save/Saved toggle, Apple Maps directions handoff, personal observation chips, latest session summary, "+ Log study session" action, and permanent deletion menu.
4. **Saved Places (Tab 2):** Filtered saved list, custom note previews, swipe-to-unsave, quick note editing, and privacy reminder banner.
5. **My Progress (Tab 3):** Time period picker (This week / This month / All time), hero study time card, sessions and average focus metrics, 7-day weekly bar chart, and recent session CRUD list.

---

## 4. Implementation Details & Apple Framework Integration

### 4.1 MapKit Local Search & Region Queries
`MKLocalSearch` was chosen as the primary advanced framework integration. Unlike static maps, StudySpot dynamically queries Apple's Point of Interest index for libraries and cafes within the user's visible map region:
- **Debounced Search Execution:** Real-time search input is debounced by 350ms to prevent rapid query dispatching and respect Apple API rate limits.
- **Cancellation of Obsolete Requests:** In-flight `MKLocalSearch` requests are explicitly cancelled when a user types a new letter or pans the camera, ensuring stale completions never overwrite current search results.
- **Apple Maps Walking Handoff:** Uses `MKMapItem.openInMaps(...)` to transfer navigation smoothly to the system navigation app.

### 4.2 Core Location Privacy & On-Demand Permissions
In compliance with Apple's App Review Guidelines and user privacy best practices:
- Location tracking is **never initiated automatically**.
- Permission (`requestWhenInUseAuthorization`) is requested **only when the student taps "Near Me"**.
- The app bundle defines a descriptive `NSLocationWhenInUseUsageDescription`.
- If permission is denied or restricted, manual region selection and map panning remain 100% operational without error dialogs or crashes.

### 4.3 Core Data Entity Relationships & Deletion Rules
- **Deduplication:** Repeated saves of a venue from search results do not create redundant database rows. Deduplication evaluates `providerId` first, falling back to a normalized name comparison within `±0.001` degrees (~100m).
- **Safe Unfavourite:** Setting `isSaved = false` removes the place from the Saved tab but retains the underlying `Place` record and its child `StudySession` entities.
- **Explicit Permanent Deletion:** When a user explicitly deletes a local place, an iOS confirmation dialog discloses the exact count of linked sessions that will be removed before triggering a cascade deletion.

---

## 5. Visual Design, Accessibility & Adaptive Layout

### 5.1 Color Identity & Aesthetic Execution
The application was designed following the provided five-screen concept board:
- **Light Theme:** Cream background (`#F6F7F2`), white surface cards (`#FFFFFF`), deep teal primary (`#176459`), and warm accent (`#EBC77A`).
- **Dark Theme:** High-contrast semantic dark mode (`#111817` background, `#1B2423` surfaces, `#359183` accent).
- **Vector Artwork:** Polished native vector illustrations for the Study Banner, Cafe Interior, Library Shelves, and the Book & Pin logo mark.

### 5.2 Accessibility Conformance
- **VoiceOver:** Every interactive button, custom chip, and chart element is equipped with descriptive `.accessibilityLabel` and `.accessibilityHint` modifiers.
- **Dynamic Type:** All typography scales with user-selected system font sizes.
- **Touch Targets:** All interactive touch zones enforce a minimum height of 44 pt.
- **Reduce Motion:** Button tap animations and transitions respect the system's `accessibilityReduceMotion` setting.

---

## 6. Testing Strategy & Verification Methodology

### 6.1 Automated Unit & UI Testing (XCTest)
Seven comprehensive unit test suites were implemented:
1. `PlaceValidationTests`: Validates duration (1–240m), focus (1–5 stars), coordinates, and note bounds.
2. `PlaceDeduplicationTests`: Validates deduplication by provider identifier and spatial proximity.
3. `StudySessionCRUDTests`: Confirms Create, Read, Update, and Delete operations for sessions.
4. `RelationshipCascadeTests`: Proves safe unfavourite preserves sessions; verifies permanent cascade delete.
5. `ProgressAggregationTests`: Validates date range filtering and aggregate metric computation.
6. `SearchCancellationTests`: Verifies async task cancellation and simulated network error handling.
7. `StoreReopeningTests`: Proves data survival across complete container teardowns and relaunches.
- In addition, `StudySpotFlowUITests` automates the end-to-end user journey from Explore to Details, Bookmarking, Logging a Session, and verifying Progress metrics.

### 6.2 Environment & Build Gate Separation
- **Windows Authoring:** Structural XML verification, Swift syntax checks, asset catalog compilation checks, and project configuration consistency.
- **Mac Handoff:** Compilation in Xcode, iOS Simulator execution, and performance testing are delegated to the Mac testing environment via `Scripts/verify_macos.sh`. Execution status is honestly tracked as **NOT RUN** until verified on macOS.

---

## 7. Critical Challenges & Engineering Solutions

| Challenge | Root Cause | Engineering Solution |
|---|---|---|
| **Stale Search Overwriting** | Async search completions returning out of sequence when typing rapidly. | Implemented active cancellation of in-flight `MKLocalSearch` instances coupled with a 350ms Combine debounce pipeline. |
| **Duplicate Place Rows** | Users re-saving venues found in different search queries or map regions. | Devised a two-tier deduplication algorithm matching Apple provider IDs first, then normalized names within 100m proximity. |
| **Accidental Data Loss on Unsave** | Standard Core Data cascade rules would erase session history if a place were deleted when unfavourited. | Decoupled the bookmark flag (`isSaved = false`) from database row deletion. Unsaving leaves the place entity and its sessions intact. |
| **Demo Mode Pollution** | Testing demo data could corrupt the user's real academic study statistics. | Created an isolated demo SQLite store (`StudySpot_Demo.sqlite`) activated only when Demo Mode is explicitly enabled. |

---

## 8. Academic Reflections & Viva Readiness

Building StudySpot provided invaluable practical experience in native iOS application design. Key technical takeaways include:
- The importance of decoupling SwiftUI views from `NSManagedObject` lifecycle issues through immutable value DTOs.
- Structuring asynchronous network and location services behind protocols to enable deterministic testing without mock servers.
- The necessity of designing honest software: avoiding the temptation to fabricate venue suitability data and instead empowering users to record their own observations.

The complete codebase, documentation, and Git version history reflect an individual, disciplined engineering effort aligned with all SE4041 learning outcomes.
