import Foundation
import CoreLocation

/// Value type representing a study place across UI views, search results, and map annotations.
/// Decouples SwiftUI views from direct NSManagedObject lifetime issues.
public struct PlaceDTO: Identifiable, Hashable, Codable {
    public let id: UUID
    public let providerId: String?
    public var name: String
    public var address: String
    public var latitude: Double
    public var longitude: Double
    public var category: String
    public var isSaved: Bool
    public var isDemoPlace: Bool
    public var personalNote: String?
    public var wifiObservation: WiFiObservation
    public var powerObservation: PowerObservation
    public var noiseObservation: NoiseObservation
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        providerId: String? = nil,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        category: String = "Library",
        isSaved: Bool = false,
        isDemoPlace: Bool = false,
        personalNote: String? = nil,
        wifiObservation: WiFiObservation = .unknown,
        powerObservation: PowerObservation = .unknown,
        noiseObservation: NoiseObservation = .unknown,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.providerId = providerId
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.address = address.trimmingCharacters(in: .whitespacesAndNewlines)
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.isSaved = isSaved
        self.isDemoPlace = isDemoPlace
        self.personalNote = personalNote
        self.wifiObservation = wifiObservation
        self.powerObservation = powerObservation
        self.noiseObservation = noiseObservation
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var categoryEnum: StudyPlaceCategory {
        StudyPlaceCategory.from(storedString: category)
    }
    
    public var subtitleDisplay: String {
        let cat = categoryEnum.singularName
        if isDemoPlace {
            return "\(cat) · Demo place"
        } else if !address.isEmpty {
            return "\(cat) · \(address)"
        } else {
            return cat
        }
    }
    
    /// Validates latitude and longitude ranges and non-empty name
    public var isValid: Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard latitude.isFinite && longitude.isFinite else { return false }
        guard latitude >= -90.0 && latitude <= 90.0 else { return false }
        guard longitude >= -180.0 && longitude <= 180.0 else { return false }
        return true
    }
    
    /// Generates a normalized deduplication key based on providerId, or normalized name and coarse coordinates (~50m)
    public var deduplicationKey: String {
        if let providerId = providerId, !providerId.isEmpty {
            return "provider:\(providerId.lowercased())"
        }
        let cleanName = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let latRounded = String(format: "%.3f", latitude)
        let lonRounded = String(format: "%.3f", longitude)
        return "geo:\(cleanName)@\(latRounded),\(lonRounded)"
    }
}
