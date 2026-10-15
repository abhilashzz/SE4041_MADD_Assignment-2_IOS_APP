import XCTest
import CoreData
@testable import StudySpot

final class StudySessionCRUDTests: XCTestCase {
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
    
    func testCreateReadUpdateDeleteSession() throws {
        // 1. Create place
        let placeDTO = PlaceDTO(
            name: "Leaf & Latte",
            address: "Alfred House Gardens",
            latitude: 6.8973,
            longitude: 79.8550,
            category: "Cafés"
        )
        let savedPlace = try placeRepository.savePlace(dto: placeDTO)
        
        // 2. CREATE Session
        let draft = StudySessionDraft(
            placeId: savedPlace.id,
            placeName: savedPlace.name,
            completedAt: Date(),
            durationMinutes: 45,
            focusRating: 4,
            note: "Read swift documentation"
        )
        let session = try sessionRepository.logSession(draft: draft, placeDTO: savedPlace)
        XCTAssertEqual(session.durationMinutes, 45)
        XCTAssertEqual(session.focusRating, 4)
        
        // 3. READ Session
        let fetchedSessions = try sessionRepository.fetchSessions(forPlaceId: savedPlace.id)
        XCTAssertEqual(fetchedSessions.count, 1)
        XCTAssertEqual(fetchedSessions.first?.note, "Read swift documentation")
        
        // 4. UPDATE Session
        var editDraft = StudySessionDraft(
            sessionId: session.id,
            placeId: savedPlace.id,
            placeName: savedPlace.name,
            completedAt: session.completedAt,
            durationMinutes: 60,
            focusRating: 5,
            note: "Extended study to 60 mins"
        )
        let updatedSession = try sessionRepository.updateSession(draft: editDraft)
        XCTAssertEqual(updatedSession.durationMinutes, 60)
        XCTAssertEqual(updatedSession.focusRating, 5)
        XCTAssertEqual(updatedSession.note, "Extended study to 60 mins")
        
        // 5. DELETE Session
        try sessionRepository.deleteSession(id: session.id)
        let remainingSessions = try sessionRepository.fetchSessions(forPlaceId: savedPlace.id)
        XCTAssertEqual(remainingSessions.count, 0, "Session should be deleted from database")
    }
    
    func testInvalidSessionRejectedAtRepositoryLevel() {
        let placeDTO = PlaceDTO(name: "Test Spot", address: "Address", latitude: 6.9, longitude: 79.8)
        let invalidDraft = StudySessionDraft(placeId: placeDTO.id, placeName: placeDTO.name, durationMinutes: 300)
        
        XCTAssertThrowsError(try sessionRepository.logSession(draft: invalidDraft, placeDTO: placeDTO)) { error in
            XCTAssertEqual(error as? StudySessionDraft.ValidationError, .invalidDuration)
        }
    }
}
