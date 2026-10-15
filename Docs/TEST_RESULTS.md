# StudySpot - Test Results & Verification Plan

**App:** StudySpot  
**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 - MADD  
**Report Date:** October 15, 2026  

---

## 1. Executive Status Summary

| Check Category | Execution Environment | Status | Notes & Verification Scope |
|---|---|---|---|
| **Static Structural Integrity** | Windows 11 (PowerShell) | **PASSED** | 58 project files verified, PBX syntax confirmed, Core Data XML schema validated, assets catalog verified. |
| **Data Model & Schema Check** | Windows 11 (XML validation) | **PASSED** | Validated entities (`Place`, `StudySession`), attributes, inverse relationships, and manual codegen setting. |
| **Native Swift Compilation** | macOS / Xcode 15+ | **NOT RUN** | Windows cannot execute the Apple LLVM/Clang compiler or SwiftUI preview engines. |
| **XCTest Unit Test Execution** | macOS / iPhone Simulator | **NOT RUN** | 7 written test suites ready for Mac execution via `Scripts/verify_macos.sh` or `Cmd+U`. |
| **XCTest UI Test Execution** | macOS / iPhone Simulator | **NOT RUN** | Automated end-to-end user flow test ready for Mac execution. |
| **Physical Device Verification** | iPhone running iOS 17+ | **NOT RUN** | Pending tester access to physical hardware. |

---

## 2. Unit Test Suite Specifications (Ready for Mac Execution)

### Suite 1: `PlaceValidationTests`
- **File:** [`Tests/StudySpotTests/PlaceValidationTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/PlaceValidationTests.swift)
- **Target:** Data integrity validation.
- **Test Cases:**
  1. `testValidPlaceDTO`: Verifies that a place with valid name, address, and coordinates passes validation.
  2. `testEmptyPlaceNameRejected`: Confirms that blank or whitespace-only place names fail validation.
  3. `testInvalidLatitudeRejected`: Confirms latitudes `< -90` or `> 90` are rejected.
  4. `testInvalidLongitudeRejected`: Confirms longitudes `< -180` or `> 180` are rejected.
  5. `testValidStudySessionDraft`: Validates standard draft values (e.g., 45m duration, 4 stars focus).
  6. `testStudySessionDurationBounds`: Confirms duration `0` or `241` are rejected; `1` and `240` pass.
  7. `testStudySessionRatingBounds`: Confirms focus ratings `0` or `6` are rejected; `1` through `5` pass.
  8. `testStudySessionNoteLengthLimit`: Confirms notes exceeding 500 characters are rejected.

### Suite 2: `PlaceDeduplicationTests`
- **File:** [`Tests/StudySpotTests/PlaceDeduplicationTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/PlaceDeduplicationTests.swift)
- **Target:** Prevention of duplicate Core Data place records upon repeat saves.
- **Test Cases:**
  1. `testDeduplicationByProviderId`: Saves a place with `provider-12345`, then saves again with updated name/address. Verifies total place count remains 1 and attributes update.
  2. `testDeduplicationByNameAndProximity`: Saves "Quiet Corner Library", then saves a similar lowercase name within 10 meters. Verifies deduplication prevents clone rows.

### Suite 3: `StudySessionCRUDTests`
- **File:** [`Tests/StudySpotTests/StudySessionCRUDTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/StudySessionCRUDTests.swift)
- **Target:** Complete lifecycle operations for study sessions.
- **Test Cases:**
  1. `testCreateReadUpdateDeleteSession`: Performs full CRUD cycle (Create session -> Read from place -> Update duration to 60m & 5 stars -> Delete session). Verifies store state after each step.
  2. `testInvalidSessionRejectedAtRepositoryLevel`: Confirms repository throws validation error when attempting to insert a 300-minute session.

### Suite 4: `RelationshipCascadeTests`
- **File:** [`Tests/StudySpotTests/RelationshipCascadeTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/RelationshipCascadeTests.swift)
- **Target:** Verifying safe unfavourite semantics and permanent cascade deletion.
- **Test Cases:**
  1. `testUnsavingPlacePreservesSessionHistory`: Saves a place with 2 sessions, sets `isSaved = false`. Verifies place is removed from Saved list, but both sessions remain intact and queryable.
  2. `testPermanentPlaceDeletionCascadesToSessions`: Saves place with 1 session, calls `deletePlacePermanently`. Verifies place and linked session are both deleted.

### Suite 5: `ProgressAggregationTests`
- **File:** [`Tests/StudySpotTests/ProgressAggregationTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/ProgressAggregationTests.swift)
- **Target:** Date range calculations and chart point generation.
- **Test Cases:**
  1. `testHeroTimeFormatting`: Verifies `210` min formats as `"3h 30m"`, `60` min as `"1h"`, `45` min as `"45m"`, and `0` min as `"0m"`.
  2. `testAverageFocusFormatting`: Verifies integer averages format as `"4/5"` and fractional as `"4.3/5"`.
  3. `testDateRangeFiltering`: Compares sessions logged today, yesterday, and 300 days ago across `.thisWeek` and `.allTime` filters.

### Suite 6: `SearchCancellationTests`
- **File:** [`Tests/StudySpotTests/SearchCancellationTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/SearchCancellationTests.swift)
- **Target:** Async search task cancellation and mock error simulation.
- **Test Cases:**
  1. `testMockSearchCategoryFiltering`: Verifies category filtering separates Cafés and Libraries correctly.
  2. `testMockSearchQueryFiltering`: Verifies text search matches venue name.
  3. `testMockSearchErrorSimulation`: Confirms service throws `SearchServiceError.networkUnavailable` when error simulated.
  4. `testCancellation`: Cancels in-flight search task and verifies `SearchServiceError.cancelled` is thrown.

### Suite 7: `StoreReopeningTests`
- **File:** [`Tests/StudySpotTests/StoreReopeningTests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/Tests/StudySpotTests/StoreReopeningTests.swift)
- **Target:** Data survival across persistent SQLite container reinstantiation.
- **Test Cases:**
  1. `testDataSurvivesContainerReopening`: Writes place and session to a temporary SQLite file, deallocates container, instantiates a brand new container, and verifies all records and relationships are intact.

---

## 3. Automated UI Test Specification

### Suite 1: `StudySpotFlowUITests`
- **File:** [`UITests/StudySpotUITests/StudySpotFlowUITests.swift`](file:///d:/SE4041_MADD_Assignment%202_IOS_APP/UITests/StudySpotUITests/StudySpotFlowUITests.swift)
- **Target:** End-to-end user interaction walkthrough.
- **Launch Arguments:** `["-ui-testing", "-demo-mode"]`
- **Test Cases:**
  1. `testExploreToDetailsAndSaveFlow`: Launches app -> verifies Explore header -> taps "Leaf & Latte" -> verifies details and directions button -> toggles save bookmark -> navigates back -> opens Saved tab -> verifies saved card exists.
  2. `testLogSessionAndCheckProgress`: Taps "Quiet Corner Library" -> taps "+ Log study session" -> saves session -> navigates to Progress tab -> verifies updated study time and session count.

---

## 4. User Acceptance Testing (UAT) Protocol

When presenting StudySpot to student participants on a Mac/Simulator, use the following evaluation checklist:

| Participant ID | Task Description | Success (Y/N) | Observed Friction / Feedback |
|---|---|---|---|
| **STU-01** | Find a library in Colombo on the Explore tab and bookmark it. | *Pending live test* | *To be recorded during viva/demo* |
| **STU-02** | Use the Map to locate a cafe near your current location. | *Pending live test* | *To be recorded during viva/demo* |
| **STU-03** | Log a 45-minute study session with a 4-star focus rating. | *Pending live test* | *To be recorded during viva/demo* |
| **STU-04** | Unsave a place and confirm your study history was preserved. | *Pending live test* | *To be recorded during viva/demo* |
| **STU-05** | View your study time chart and edit an earlier session. | *Pending live test* | *To be recorded during viva/demo* |
