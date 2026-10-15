import Foundation
import CoreData

@objc(StudySession)
public class StudySession: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudySession> {
        return NSFetchRequest<StudySession>(entityName: "StudySession")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var completedAt: Date?
    @NSManaged public var durationMinutes: Int16
    @NSManaged public var focusRating: Int16
    @NSManaged public var note: String?
    @NSManaged public var place: Place?
    
    public var safeId: UUID {
        id ?? UUID()
    }
    
    public var safeCompletedAt: Date {
        completedAt ?? Date()
    }
    
    public func toDTO() -> StudySessionDTO {
        StudySessionDTO(
            id: safeId,
            placeId: place?.safeId ?? UUID(),
            placeName: place?.safeName ?? "Study Spot",
            placeCategory: place?.safeCategory ?? "Library",
            completedAt: safeCompletedAt,
            durationMinutes: Int(durationMinutes),
            focusRating: Int(focusRating),
            note: note
        )
    }
}

extension StudySession: Identifiable {}
