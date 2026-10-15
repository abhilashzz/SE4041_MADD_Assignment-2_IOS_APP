import XCTest
@testable import StudySpot

final class PlaceValidationTests: XCTestCase {
    
    func testValidPlaceDTO() {
        let place = PlaceDTO(
            name: "Leaf & Latte",
            address: "Alfred House Gardens, Colombo 03",
            latitude: 6.8973,
            longitude: 79.8550,
            category: "Cafés"
        )
        XCTAssertTrue(place.isValid, "Valid place should pass validation")
    }
    
    func testEmptyPlaceNameRejected() {
        let place = PlaceDTO(
            name: "   ",
            address: "Colombo",
            latitude: 6.9,
            longitude: 79.8
        )
        XCTAssertFalse(place.isValid, "Empty place name must be invalid")
    }
    
    func testInvalidLatitudeRejected() {
        let placeHigh = PlaceDTO(name: "High Spot", address: "North", latitude: 91.0, longitude: 79.8)
        let placeLow = PlaceDTO(name: "Low Spot", address: "South", latitude: -95.0, longitude: 79.8)
        XCTAssertFalse(placeHigh.isValid, "Latitude > 90 must be invalid")
        XCTAssertFalse(placeLow.isValid, "Latitude < -90 must be invalid")
    }
    
    func testInvalidLongitudeRejected() {
        let placeEast = PlaceDTO(name: "East Spot", address: "Far East", latitude: 6.9, longitude: 181.0)
        let placeWest = PlaceDTO(name: "West Spot", address: "Far West", latitude: 6.9, longitude: -185.0)
        XCTAssertFalse(placeEast.isValid, "Longitude > 180 must be invalid")
        XCTAssertFalse(placeWest.isValid, "Longitude < -180 must be invalid")
    }
    
    func testValidStudySessionDraft() {
        let draft = StudySessionDraft(
            placeId: UUID(),
            placeName: "Quiet Corner Library",
            durationMinutes: 45,
            focusRating: 4,
            note: "Study session for exams"
        )
        XCTAssertTrue(draft.isValid)
        XCTAssertNil(draft.validationErrorMessage)
    }
    
    func testStudySessionDurationBounds() {
        var draft = StudySessionDraft(placeId: UUID(), placeName: "Test", durationMinutes: 0)
        XCTAssertFalse(draft.isValid, "0 minutes must be invalid (minimum 1)")
        
        draft.durationMinutes = 241
        XCTAssertFalse(draft.isValid, "241 minutes must be invalid (maximum 240)")
        
        draft.durationMinutes = 1
        XCTAssertTrue(draft.isValid, "1 minute must be valid")
        
        draft.durationMinutes = 240
        XCTAssertTrue(draft.isValid, "240 minutes must be valid")
    }
    
    func testStudySessionRatingBounds() {
        var draft = StudySessionDraft(placeId: UUID(), placeName: "Test", focusRating: 0)
        XCTAssertFalse(draft.isValid, "0 stars must be invalid")
        
        draft.focusRating = 6
        XCTAssertFalse(draft.isValid, "6 stars must be invalid")
        
        draft.focusRating = 1
        XCTAssertTrue(draft.isValid, "1 star must be valid")
        
        draft.focusRating = 5
        XCTAssertTrue(draft.isValid, "5 stars must be valid")
    }
    
    func testStudySessionNoteLengthLimit() {
        let longNote = String(repeating: "A", count: 501)
        let draft = StudySessionDraft(placeId: UUID(), placeName: "Test", note: longNote)
        XCTAssertFalse(draft.isValid, "Notes over 500 characters must be rejected")
    }
}
