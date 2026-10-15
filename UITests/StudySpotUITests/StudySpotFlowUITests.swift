import XCTest

final class StudySpotFlowUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-demo-mode"]
        app.launch()
    }
    
    func testExploreToDetailsAndSaveFlow() {
        // 1. Verify Explore view elements
        XCTAssertTrue(app.staticTexts["StudySpot"].waitForExistence(timeout: 4.0))
        XCTAssertTrue(app.staticTexts["Find your next\nstudy spot"].exists)
        
        // 2. Tap on "Leaf & Latte" card
        let leafAndLatte = app.staticTexts["Leaf & Latte"]
        XCTAssertTrue(leafAndLatte.waitForExistence(timeout: 3.0))
        leafAndLatte.tap()
        
        // 3. Verify Details Screen
        XCTAssertTrue(app.staticTexts["Your study notes"].waitForExistence(timeout: 3.0))
        XCTAssertTrue(app.buttons["Directions"].exists)
        
        // 4. Tap Save / Saved toggle
        let bookmarkButton = app.buttons["detailsBookmarkButton"]
        if bookmarkButton.waitForExistence(timeout: 3.0) {
            bookmarkButton.tap()
        }
        
        // 5. Navigate back to Explore
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.waitForExistence(timeout: 3.0))
        backButton.tap()
        
        // 6. Navigate to Saved tab
        app.tabBars.buttons["Saved"].tap()
        XCTAssertTrue(app.staticTexts["Your saved places"].waitForExistence(timeout: 3.0))
    }
    
    func testLogSessionAndCheckProgress() {
        // 1. Tap on Quiet Corner Library
        let libraryCard = app.staticTexts["Quiet Corner Library"]
        if libraryCard.waitForExistence(timeout: 3.0) {
            libraryCard.tap()
            
            // 2. Tap "+ Log study session"
            let logButton = app.buttons["Log study session"]
            XCTAssertTrue(logButton.waitForExistence(timeout: 3.0))
            logButton.tap()
            
            // 3. In LogSessionSheet, tap Save
            let saveButton = app.navigationBars.buttons["Save"]
            XCTAssertTrue(saveButton.waitForExistence(timeout: 3.0))
            saveButton.tap()
            
            // 4. Return to home
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        // 5. Switch to Progress tab
        app.tabBars.buttons["Progress"].tap()
        XCTAssertTrue(app.staticTexts["Your study progress"].waitForExistence(timeout: 5.0))
        XCTAssertTrue(app.staticTexts["Study time"].waitForExistence(timeout: 3.0))
        XCTAssertTrue(app.staticTexts["Sessions"].waitForExistence(timeout: 3.0))
    }
}
