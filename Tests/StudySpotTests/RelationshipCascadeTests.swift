import XCTest
import CoreData
@testable import StudySpot

final class RelationshipCascadeTests: XCTestCase {
    var persistence: PersistenceController!
    var placeRepository: PlaceRepository!
    var sessionRepository: SessionRepository!
    
    override func setUp() {
        super.setUp()
        persistence = PersistenceController(inMemory: true)
        placeRepository = PlaceRepository(context: persistence.container.viewContext)
        sessionRepository = SessionRepository(context: persistence.container.viewContext, placeRepository: placeRepository)
    }
    
    override func tearDown() {
        persistence = nil
        placeRepository = nil
        sessionRepository = nil
        super.tearDown()
    }
    
    func testUnsavingPlacePreservesSessionHistory() throws {
        // Save place
        let place = PlaceDTO(name: "Quiet Corner Library", address: "Independence Ave", latitude: 6.9042, longitude: 79.8698, isSaved: true)
        let saved = try placeRepository.savePlace(dto: place)
        
        // Log 2 study sessions
        let draft1 = StudySessionDraft(placeId: saved.id, placeName: saved.name, durationMinutes: 45, focusRating: 4)
        let draft2 = StudySessionDraft(placeId: saved.id, placeName: saved.name, durationMinutes: 60, focusRating: 5)
        _ = try sessionRepository.logSession(draft: draft1, placeDTO: saved)
        _ = try sessionRepository.logSession(draft: draft2, placeDTO: saved)
        
        XCTAssertEqual(try sessionRepository.fetchSessions(forPlaceId: saved.id).count, 2)
        XCTAssertEqual(try placeRepository.fetchSavedPlaces().count, 1)
        
        // Unsave place
        try placeRepository.unsavePlace(id: saved.id)
        
        // Verify place is no longer in saved list
        let savedList = try placeRepository.fetchSavedPlaces()
        XCTAssertEqual(savedList.count, 0, "Place should no longer be marked as saved")
        
        // CRITICAL: Session history must NOT be destroyed!
        let preservedSessions = try sessionRepository.fetchSessions(forPlaceId: saved.id)
        XCTAssertEqual(preservedSessions.count, 2, "Sessions must remain preserved even after unsaving place")
        
        // All sessions query must also retain them
        let allSessions = try sessionRepository.fetchAllSessions()
        XCTAssertEqual(allSessions.count, 2, "All sessions must include preserved sessions")
    }
    
    func testPermanentPlaceDeletionCascadesToSessions() throws {
        let place = PlaceDTO(name: "Temporary Spot", address: "Galle Road", latitude: 6.89, longitude: 79.85, isSaved: true)
        let saved = try placeRepository.savePlace(dto: place)
        
        let draft = StudySessionDraft(placeId: saved.id, placeName: saved.name, durationMinutes: 30, focusRating: 3)
        _ = try sessionRepository.logSession(draft: draft, placeDTO: saved)
        
        XCTAssertEqual(try sessionRepository.fetchSessions(forPlaceId: saved.id).count, 1)
        
        // Explicit permanent deletion
        try placeRepository.deletePlacePermanently(id: saved.id)
        
        // Verify place is deleted
        let placeEntity = try placeRepository.fetchPlaceDTO(byId: saved.id)
        XCTAssertNil(placeEntity, "Place should be deleted permanently")
        
        // Verify cascade deletion of sessions
        let remainingSessions = try sessionRepository.fetchAllSessions()
        XCTAssertEqual(remainingSessions.count, 0, "Linked sessions must be deleted on permanent place deletion")
    }
}
