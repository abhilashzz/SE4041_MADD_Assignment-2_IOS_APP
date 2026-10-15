import XCTest
import CoreData
@testable import StudySpot

final class PlaceDeduplicationTests: XCTestCase {
    var persistence: PersistenceController!
    var repository: PlaceRepository!
    
    override func setUp() {
        super.setUp()
        persistence = PersistenceController(inMemory: true)
        repository = PlaceRepository(context: persistence.container.viewContext)
    }
    
    override func tearDown() {
        persistence = nil
        repository = nil
        super.tearDown()
    }
    
    func testDeduplicationByProviderId() throws {
        let placeA = PlaceDTO(
            id: UUID(),
            providerId: "provider-12345",
            name: "Leaf & Latte",
            address: "Colombo 03",
            latitude: 6.8973,
            longitude: 79.8550,
            category: "Cafés"
        )
        
        _ = try repository.savePlace(dto: placeA)
        let initialCount = try repository.fetchAllPlaces().count
        XCTAssertEqual(initialCount, 1)
        
        // Save again with same providerId but slightly updated address/category
        let placeB = PlaceDTO(
            id: UUID(), // different temporary UUID
            providerId: "provider-12345",
            name: "Leaf & Latte Updated",
            address: "Alfred House Gardens, Colombo 03",
            latitude: 6.8973,
            longitude: 79.8550,
            category: "Cafés"
        )
        
        _ = try repository.savePlace(dto: placeB)
        let updatedPlaces = try repository.fetchAllPlaces()
        
        XCTAssertEqual(updatedPlaces.count, 1, "Duplicate record must not be created when providerId matches")
        XCTAssertEqual(updatedPlaces.first?.name, "Leaf & Latte Updated", "Existing record should be updated with new details")
    }
    
    func testDeduplicationByNameAndProximity() throws {
        let place1 = PlaceDTO(
            name: "Quiet Corner Library",
            address: "Independence Ave",
            latitude: 6.9042,
            longitude: 79.8698,
            category: "Libraries"
        )
        
        _ = try repository.savePlace(dto: place1)
        XCTAssertEqual(try repository.fetchAllPlaces().count, 1)
        
        // Similar place with case difference and very close coordinates (~10 meters apart)
        let place2 = PlaceDTO(
            name: "quiet corner library",
            address: "Independence Avenue, Colombo 07",
            latitude: 6.90422,
            longitude: 79.86981,
            category: "Libraries"
        )
        
        _ = try repository.savePlace(dto: place2)
        let places = try repository.fetchAllPlaces()
        
        XCTAssertEqual(places.count, 1, "Places with same normalized name and proximity must be deduplicated")
    }
}
