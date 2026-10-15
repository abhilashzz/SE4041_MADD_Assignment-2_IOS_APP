import XCTest
import CoreData
@testable import StudySpot

final class StoreReopeningTests: XCTestCase {
    var tempDirectory: URL!
    var storeURL: URL!
    
    override func setUp() {
        super.setUp()
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        storeURL = tempDirectory.appendingPathComponent("TestReopen.sqlite")
    }
    
    private var openedContainers: [NSPersistentContainer] = []
    
    override func tearDown() {
        for container in openedContainers {
            for store in container.persistentStoreCoordinator.persistentStores {
                try? container.persistentStoreCoordinator.remove(store)
            }
        }
        openedContainers.removeAll()
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }
    
    private func createTestContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "StudySpot", managedObjectModel: PersistenceController.model)
        let desc = NSPersistentStoreDescription(url: storeURL)
        desc.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        desc.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.persistentStoreDescriptions = [desc]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        openedContainers.append(container)
        return container
    }
    
    func testDataSurvivesContainerReopening() throws {
        // Phase 1: Open store, write place & session, save context
        let placeId = UUID()
        do {
            let container1 = createTestContainer()
            let context1 = container1.viewContext
            
            let place = Place(context: context1)
            place.id = placeId
            place.name = "Campus Commons"
            place.address = "Reid Avenue, Colombo 07"
            place.latitude = 6.9015
            place.longitude = 79.8606
            place.category = "Libraries"
            place.isSaved = true
            place.personalNote = "Study table 4"
            place.createdAt = Date()
            place.updatedAt = Date()
            
            let session = StudySession(context: context1)
            session.id = UUID()
            session.completedAt = Date()
            session.durationMinutes = 75
            session.focusRating = 5
            session.note = "Exam preparation"
            session.place = place
            
            try context1.save()
        }
        
        // Phase 2: Create a completely new container pointing to the same store file
        do {
            let container2 = createTestContainer()
            let context2 = container2.viewContext
            
            let request: NSFetchRequest<Place> = Place.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", placeId as CVarArg)
            let loadedPlaces = try context2.fetch(request)
            
            XCTAssertEqual(loadedPlaces.count, 1, "Place must survive store reopening")
            let loaded = loadedPlaces.first!
            XCTAssertEqual(loaded.name, "Campus Commons")
            XCTAssertEqual(loaded.personalNote, "Study table 4")
            XCTAssertTrue(loaded.isSaved)
            
            let sessions = loaded.safeSessionsArray
            XCTAssertEqual(sessions.count, 1, "Session relationship must survive store reopening")
            XCTAssertEqual(sessions.first?.durationMinutes, 75)
            XCTAssertEqual(sessions.first?.focusRating, 5)
        }
    }
}
