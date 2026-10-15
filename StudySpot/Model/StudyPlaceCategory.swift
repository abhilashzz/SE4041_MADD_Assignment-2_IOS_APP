import Foundation
import SwiftUI

/// Categories used for filtering and searching study locations.
public enum StudyPlaceCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case library = "Libraries"
    case cafe = "Cafés"
    
    public var id: String { rawValue }
    
    public var displayName: String { rawValue }
    
    public var singularName: String {
        switch self {
        case .all: return "Study Spot"
        case .library: return "Library"
        case .cafe: return "Café"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .all: return "sparkles"
        case .library: return "books.vertical.fill"
        case .cafe: return "cup.and.saucer.fill"
        }
    }
    
    /// Keywords passed to MKLocalSearch query
    public var searchQuery: String {
        switch self {
        case .all: return "study library cafe"
        case .library: return "library study reading room"
        case .cafe: return "cafe coffee shop"
        }
    }
    
    /// Parses a category string from a stored Place record
    public static func from(storedString: String) -> StudyPlaceCategory {
        let lower = storedString.lowercased()
        if lower.contains("cafe") || lower.contains("café") || lower.contains("coffee") {
            return .cafe
        } else if lower.contains("library") || lower.contains("reading") {
            return .library
        }
        return .all
    }
}
