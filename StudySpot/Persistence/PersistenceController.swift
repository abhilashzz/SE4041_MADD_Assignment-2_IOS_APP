import Foundation
import CoreData

/// Manages Core Data persistent stores for production, demo mode, and unit tests.
public final class PersistenceController: ObservableObject {
    public static let shared = PersistenceController()

    /// In-memory controller for SwiftUI previews and unit testing
    public static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        controller.seedSampleData(context: context)
        return controller
    }()
    
    /// Dedicated demo controller so demo mode never pollutes user production database
    public static let demo = PersistenceController(isDemoStore: true)

    public static let model: NSManagedObjectModel = {
        if let url = Bundle.main.url(forResource: "StudySpot", withExtension: "momd") ??
                     Bundle(for: PersistenceController.self).url(forResource: "StudySpot", withExtension: "momd"),
           let m = NSManagedObjectModel(contentsOf: url) {
            return m
        }
        return NSPersistentContainer(name: "StudySpot").managedObjectModel
    }()

    public let container: NSPersistentContainer
    @Published public var loadError: Error?

    public init(inMemory: Bool = false, isDemoStore: Bool = false) {
        container = NSPersistentContainer(name: "StudySpot", managedObjectModel: PersistenceController.model)
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to find persistent store description for StudySpot.")
        }
        
        // Enable lightweight migration
        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        } else if isDemoStore {
            let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let demoUrl = appSupport.appendingPathComponent("StudySpot_Demo.sqlite")
            description.url = demoUrl
        }
        
        container.loadPersistentStores { [weak self] (_, error) in
            if let error = error {
                print("Core Data failed to load store: \(error.localizedDescription)")
                self?.loadError = error
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Safely saves changes in the viewContext if changes exist
    @MainActor
    public func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    /// Seeds initial sample data for preview or demo mode
    public func seedSampleData(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        // Only seed if empty
        let fetch: NSFetchRequest<Place> = Place.fetchRequest()
        if (try? context.count(for: fetch)) == 0 {
            // Leaf & Latte
            let place1 = Place(context: context)
            place1.id = UUID(uuidString: "11111111-1111-1111-1111-111111111111")
            place1.name = "Leaf & Latte"
            place1.address = "Alfred House Gardens, Colombo 03"
            place1.category = "Cafés"
            place1.latitude = 6.8973
            place1.longitude = 79.8550
            place1.isSaved = true
            place1.personalNote = "Best for reading and solo work."
            place1.wifiObservation = WiFiObservation.yes.rawValue
            place1.powerObservation = PowerObservation.yes.rawValue
            place1.noiseObservation = NoiseObservation.quiet.rawValue
            place1.createdAt = Date().addingTimeInterval(-86400 * 5)
            place1.updatedAt = Date().addingTimeInterval(-86400 * 5)
            
            let session1 = StudySession(context: context)
            session1.id = UUID()
            session1.completedAt = Date().addingTimeInterval(-3600 * 2)
            session1.durationMinutes = 45
            session1.focusRating = 4
            session1.note = "Read Chapter 4 of Mobile Architecture"
            session1.place = place1
            
            // Quiet Corner Library
            let place2 = Place(context: context)
            place2.id = UUID(uuidString: "22222222-2222-2222-2222-222222222222")
            place2.name = "Quiet Corner Library"
            place2.address = "Independence Avenue, Colombo 07"
            place2.category = "Libraries"
            place2.latitude = 6.9042
            place2.longitude = 79.8698
            place2.isSaved = true
            place2.personalNote = "Great for deep study and reference books."
            place2.wifiObservation = WiFiObservation.yes.rawValue
            place2.powerObservation = PowerObservation.limited.rawValue
            place2.noiseObservation = NoiseObservation.quiet.rawValue
            place2.createdAt = Date().addingTimeInterval(-86400 * 4)
            place2.updatedAt = Date().addingTimeInterval(-86400 * 4)
            
            let session2 = StudySession(context: context)
            session2.id = UUID()
            session2.completedAt = Date().addingTimeInterval(-86400 * 1)
            session2.durationMinutes = 60
            session2.focusRating = 5
            session2.note = "Prepared viva questions"
            session2.place = place2
            
            // Campus Commons
            let place3 = Place(context: context)
            place3.id = UUID(uuidString: "33333333-3333-3333-3333-333333333333")
            place3.name = "Campus Commons"
            place3.address = "Reid Avenue, Colombo 07"
            place3.category = "Libraries"
            place3.latitude = 6.9015
            place3.longitude = 79.8606
            place3.isSaved = true
            place3.personalNote = "Group study space."
            place3.wifiObservation = WiFiObservation.yes.rawValue
            place3.powerObservation = PowerObservation.yes.rawValue
            place3.noiseObservation = NoiseObservation.moderate.rawValue
            place3.createdAt = Date().addingTimeInterval(-86400 * 3)
            place3.updatedAt = Date().addingTimeInterval(-86400 * 3)
            
            let session3 = StudySession(context: context)
            session3.id = UUID()
            session3.completedAt = Date().addingTimeInterval(-86400 * 2)
            session3.durationMinutes = 90
            session3.focusRating = 4
            session3.note = "Team discussion for assignment"
            session3.place = place3
            
            // Additional sessions to populate the progress chart (matching ~3h 30m total)
            let session4 = StudySession(context: context)
            session4.id = UUID()
            session4.completedAt = Date().addingTimeInterval(-86400 * 3)
            session4.durationMinutes = 15
            session4.focusRating = 3
            session4.note = "Quick review"
            session4.place = place1
            
            try? context.save()
        }
    }
}
typealias NSManagedContext = NSManagedObjectContext
