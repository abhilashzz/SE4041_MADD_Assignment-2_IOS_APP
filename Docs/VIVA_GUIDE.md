# StudySpot - Viva & Oral Examination Guide

**Prepared for:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 - Mobile Application Design and Development  
**Assignment:** Assignment 02 - Swift (Part A: Advanced iOS App)  
**App:** StudySpot  

---

## 1. Ten Core Swift & SwiftUI Concepts Explained in Beginner Language

### Q1: What is the difference between `let` and `var`, and what is an Optional?
- **Answer:**
  - `let` defines a **constant** whose value cannot change after being assigned. We use `let` for immutable properties like a place's `id` or creation timestamp (e.g., `let id: UUID`).
  - `var` defines a **variable** whose value can be modified over time, such as `var isSaved: Bool` or `var durationMinutes: Int`.
  - An **Optional** in Swift is a type that can either hold a wrapped value or `nil` (the absence of a value). In `PlaceDTO.swift`, `personalNote: String?` is optional because a student might not have written a note yet.
  - We safely unwrap optionals using `if let` (e.g., `if let note = place.personalNote`), `guard let`, or the nil-coalescing operator `??` (e.g., `place.name ?? "Unnamed Spot"`), preventing null-pointer crashes.

### Q2: What is a SwiftUI `View` and how does its `body` property work?
- **Answer:**
  - In SwiftUI, a `View` is a **struct** conforming to the `View` protocol. Unlike UIKit which manipulated mutable view objects on the screen, a SwiftUI view is a lightweight blueprint describing how the interface should look for a given state.
  - The `body` property returns `some View` (an opaque return type) containing declarative UI components such as `VStack`, `HStack`, `Text`, `Button`, or `List`. Whenever underlying state changes, SwiftUI re-evaluates `body` and efficiently redraws only the modified pixels on screen.

### Q3: What are `@State`, `@StateObject`, `@ObservedObject`, and `@Published`?
- **Answer:**
  - `@State`: Used for private, transient UI state owned by a single view (e.g., `@State private var wifi: WiFiObservation` in `EditNotesSheet.swift`).
  - `@Published`: A property wrapper inside an `ObservableObject` class that announces to observing views when its value changes (e.g., `@Published public var results: [PlaceDTO]` in `ExploreViewModel.swift`).
  - `@StateObject`: Instantiates and maintains ownership of an `ObservableObject` across view redraws. In `StudySpotApp.swift`, `@StateObject private var appState = AppState()` ensures the global coordinator survives throughout the app's life.
  - `@ObservedObject`: Injected into child views to listen to an existing `ObservableObject` owned by an ancestor.

### Q4: What does the ViewModel do in our MVVM architecture?
- **Answer:**
  - The ViewModel acts as a mediator between the raw data models and the SwiftUI views.
  - It handles user actions (e.g., debouncing search typing, triggering MapKit queries, toggling bookmarks, calculating study aggregates) and converts complex data into simple, formatted values for the screen (e.g., formatting 210 minutes as `"3h 30m"`).
  - It keeps business logic and network/database calls out of `View.body`.

### Q5: How does `NavigationStack` work in StudySpot?
- **Answer:**
  - `NavigationStack` manages hierarchical push-and-pop navigation.
  - In StudySpot, each of the main tabs (Explore, Map, Saved, Progress) wraps its content inside its own `NavigationStack`.
  - When a user taps a place card, `NavigationLink(destination: PlaceDetailsView(...))` pushes the details screen onto the navigation stack, providing native iOS back navigation (`< Explore`) automatically. Place Details is a **pushed destination**, not a separate fifth tab!

### Q6: Why does Core Data survive app relaunches while ordinary variables do not?
- **Answer:**
  - Ordinary Swift variables live solely in volatile RAM and are erased when the operating system terminates the process.
  - Core Data is backed by an SQLite relational database stored permanently on the device's flash storage in the app's Application Support sandbox directory (`StudySpot.sqlite`).
  - When the app is closed and relaunched, `PersistenceController` re-attaches to the SQLite file, reloading all committed places and study sessions.

### Q7: What are entity relationships and delete rules in Core Data?
- **Answer:**
  - In `StudySpot.xcdatamodeld`, we define a **One-to-Many** relationship between `Place` and `StudySession` (`Place.sessions <---> StudySession.place`).
  - **Delete Rules:**
    - For `Place.sessions`, the rule is `Cascade`: if a `Place` record is permanently deleted, all of its linked `StudySession` records are deleted as well.
    - For `StudySession.place`, the rule is `Nullify`: deleting a single study session does not destroy the venue.
  - Crucially, when a user simply **unsaves** a place (`isSaved = false`), the place entity is **not deleted**, safely preserving all session history.

### Q8: What is `async/await` and `@MainActor`?
- **Answer:**
  - `async/await` is modern Swift concurrency syntax for writing non-blocking asynchronous code without callback closures. In `MapKitSearchService.swift`, `let response = try await search.start()` suspends execution in the background without freezing the UI.
  - `@MainActor` is a compiler-enforced attribute that guarantees all methods and properties on a class execute on the main thread, where UI updates must occur to prevent race conditions and graphical corruption.

### Q9: How does StudySpot handle errors without crashing?
- **Answer:**
  - StudySpot never calls `fatalError()` or force-unwraps values with `!` in user workflows.
  - Search failures (network offline, empty results, API errors) are caught and displayed via friendly `EmptyStateView` components with retry buttons.
  - Form validations (e.g., entering 300 minutes or 0 stars in `StudySessionDraft.swift`) display clear inline error messages and disable the Save button until valid.

### Q10: What is the difference between Unit Tests, UI Tests, and User Acceptance Tests?
- **Answer:**
  - **Unit Tests:** Automated tests that verify small, isolated pieces of code in memory (e.g., verifying `validate()` rejects duration `0` or that deduplication prevents duplicate rows).
  - **UI Tests:** Automated tests that launch the actual app in a simulator and simulate user taps and gestures on buttons and lists to verify end-to-end user journeys.
  - **User Acceptance Tests (UAT):** Real human students using the application to determine whether the app is intuitive, solves their problem, and feels good to use.

---

## 2. StudySpot Specific Viva Questions

### Q11: Which data comes from MapKit and which data is entered by the user?
- **Answer:**
  - **MapKit supplies:** Venue name, geographic coordinates (latitude, longitude), category tag, and physical street address via `MKLocalSearch` and `MKMapItem`.
  - **The user enters:** Wi-Fi observation, power socket observation, ambient noise level, personal study notes, and logged study session details (duration, focus rating, completion date).
  - MapKit does not guess personal study traits; we label observations as the student's personal notes.

### Q12: Why is MapKit a meaningful advanced framework integration for StudySpot?
- **Answer:**
  - MapKit is central to the user task: students need to discover study spots within walking distance of their campus or home.
  - Rather than a static image or decorative map, StudySpot uses real `MKLocalSearch` point-of-interest discovery, interactive SwiftUI `Map` with custom category pins, "Search this area" bounding-box queries, and seamless walking directions handoff to Apple Maps.

### Q13: How does StudySpot prevent duplicate records when saving places?
- **Answer:**
  - In `PlaceRepository.swift`, the `findOrCreateEntity(for:)` function checks:
    1. Does an entity already exist with the same `providerId`?
    2. If not, does an entity exist with the same normalized lowercase name located within `±0.001` degrees (~100 meters)?
  - If a match is found, it updates the existing record instead of creating a second duplicate row.

### Q14: What happens to completed sessions when a place is unsaved?
- **Answer:**
  - Unsaving merely executes `place.isSaved = false`.
  - The `Place` entity remains in the Core Data database, and all linked `StudySession` child records remain completely intact.
  - The Progress screen continues to include these sessions in the total study hours, session count, and weekly charts. Only explicit permanent deletion removes the record and linked sessions after disclosing the consequence.

### Q15: Why is Demo Mode implemented with a separate store?
- **Answer:**
  - To allow examiners and testers to view sample places (*Leaf & Latte*, *Quiet Corner Library*) and realistic progress metrics without polluting or overwriting real user data.
  - Demo Mode writes to an isolated database (`StudySpot_Demo.sqlite`) so switching between Live Mode and Demo Mode is clean and non-destructive.
