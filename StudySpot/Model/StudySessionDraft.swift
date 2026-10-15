import Foundation

/// Form state and validation rules for logging or editing a study session.
public struct StudySessionDraft: Identifiable, Hashable {
    public let id: UUID
    public var sessionId: UUID?
    public var placeId: UUID
    public var placeName: String
    public var completedAt: Date
    public var durationMinutes: Int
    public var focusRating: Int
    public var note: String
    
    public init(
        sessionId: UUID? = nil,
        placeId: UUID,
        placeName: String,
        completedAt: Date = Date(),
        durationMinutes: Int = 45,
        focusRating: Int = 4,
        note: String = ""
    ) {
        self.id = UUID()
        self.sessionId = sessionId
        self.placeId = placeId
        self.placeName = placeName
        self.completedAt = completedAt
        self.durationMinutes = durationMinutes
        self.focusRating = focusRating
        self.note = note
    }
    
    public enum ValidationError: LocalizedError, Equatable {
        case invalidDuration
        case invalidRating
        case noteTooLong
        
        public var errorDescription: String? {
            switch self {
            case .invalidDuration:
                return "Study duration must be between 1 and 240 minutes."
            case .invalidRating:
                return "Focus rating must be between 1 and 5 stars."
            case .noteTooLong:
                return "Notes cannot exceed 500 characters."
            }
        }
    }
    
    public func validate() -> Result<Void, ValidationError> {
        guard durationMinutes >= 1 && durationMinutes <= 240 else {
            return .failure(.invalidDuration)
        }
        guard focusRating >= 1 && focusRating <= 5 else {
            return .failure(.invalidRating)
        }
        guard note.count <= 500 else {
            return .failure(.noteTooLong)
        }
        return .success(())
    }
    
    public var isValid: Bool {
        switch validate() {
        case .success: return true
        case .failure: return false
        }
    }
    
    public var validationErrorMessage: String? {
        switch validate() {
        case .success: return nil
        case .failure(let error): return error.errorDescription
        }
    }
}

/// Value type representing a saved study session for display and aggregation
public struct StudySessionDTO: Identifiable, Hashable, Codable {
    public let id: UUID
    public let placeId: UUID
    public let placeName: String
    public let placeCategory: String
    public let completedAt: Date
    public let durationMinutes: Int
    public let focusRating: Int
    public let note: String?
    
    public init(
        id: UUID = UUID(),
        placeId: UUID,
        placeName: String,
        placeCategory: String = "Library",
        completedAt: Date = Date(),
        durationMinutes: Int = 45,
        focusRating: Int = 4,
        note: String? = nil
    ) {
        self.id = id
        self.placeId = placeId
        self.placeName = placeName
        self.placeCategory = placeCategory
        self.completedAt = completedAt
        self.durationMinutes = durationMinutes
        self.focusRating = focusRating
        self.note = note
    }
    
    public var durationFormatted: String {
        let hours = durationMinutes / 60
        let mins = durationMinutes % 60
        if hours > 0 && mins > 0 {
            return "\(hours)h \(mins)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(mins) min"
        }
    }
    
    public var focusSummary: String {
        "\(durationFormatted) · Focus \(focusRating)/5"
    }
}
