import Foundation
import CoreData

@objc(Place)
public class Place: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var providerId: String?
    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var category: String?
    @NSManaged public var isSaved: Bool
    @NSManaged public var personalNote: String?
    @NSManaged public var wifiObservation: String?
    @NSManaged public var powerObservation: String?
    @NSManaged public var noiseObservation: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var sessions: NSSet?
    
    public var safeId: UUID {
        id ?? UUID()
    }
    
    public var safeName: String {
        name ?? "Unnamed Spot"
    }
    
    public var safeAddress: String {
        address ?? ""
    }
    
    public var safeCategory: String {
        category ?? "Library"
    }
    
    public var safeSessionsArray: [StudySession] {
        let set = sessions as? Set<StudySession> ?? []
        return set.sorted { ($0.completedAt ?? Date.distantPast) > ($1.completedAt ?? Date.distantPast) }
    }
    
    public func toDTO(isDemo: Bool = false) -> PlaceDTO {
        PlaceDTO(
            id: safeId,
            providerId: providerId,
            name: safeName,
            address: safeAddress,
            latitude: latitude,
            longitude: longitude,
            category: safeCategory,
            isSaved: isSaved,
            isDemoPlace: isDemo,
            personalNote: personalNote,
            wifiObservation: WiFiObservation(rawValue: wifiObservation ?? "") ?? .unknown,
            powerObservation: PowerObservation(rawValue: powerObservation ?? "") ?? .unknown,
            noiseObservation: NoiseObservation(rawValue: noiseObservation ?? "") ?? .unknown,
            createdAt: createdAt ?? Date(),
            updatedAt: updatedAt ?? Date()
        )
    }
}

// MARK: - Generated accessors for sessions
extension Place {
    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: StudySession)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: StudySession)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSSet)
}

extension Place: Identifiable {}
