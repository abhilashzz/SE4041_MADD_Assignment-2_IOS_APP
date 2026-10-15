import Foundation
import MapKit

/// Deterministic mock search service for Demo Mode and UI testing
public final class MockPlaceSearchService: PlaceSearchServiceProtocol {
    public var shouldSimulateError: Bool = false
    public var simulatedDelayNanoseconds: UInt64 = 300_000_000 // 0.3 seconds
    private var isCancelled = false
    
    public init() {}
    
    public static let samplePlaces: [PlaceDTO] = [
        PlaceDTO(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            providerId: "demo-leaf-and-latte",
            name: "Leaf & Latte",
            address: "Alfred House Gardens, Colombo 03",
            latitude: 6.8973,
            longitude: 79.8550,
            category: "Cafés",
            isSaved: true,
            isDemoPlace: true,
            personalNote: "Best for reading and solo work.",
            wifiObservation: .yes,
            powerObservation: .yes,
            noiseObservation: .quiet,
            createdAt: Date().addingTimeInterval(-86400 * 5),
            updatedAt: Date().addingTimeInterval(-86400 * 5)
        ),
        PlaceDTO(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            providerId: "demo-quiet-corner",
            name: "Quiet Corner Library",
            address: "Independence Avenue, Colombo 07",
            latitude: 6.9042,
            longitude: 79.8698,
            category: "Libraries",
            isSaved: true,
            isDemoPlace: true,
            personalNote: "Great for deep study and reference books.",
            wifiObservation: .yes,
            powerObservation: .limited,
            noiseObservation: .quiet,
            createdAt: Date().addingTimeInterval(-86400 * 4),
            updatedAt: Date().addingTimeInterval(-86400 * 4)
        ),
        PlaceDTO(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            providerId: "demo-campus-commons",
            name: "Campus Commons",
            address: "Reid Avenue, Colombo 07",
            latitude: 6.9015,
            longitude: 79.8606,
            category: "Libraries",
            isSaved: true,
            isDemoPlace: true,
            personalNote: "Group study space with ample desk room.",
            wifiObservation: .yes,
            powerObservation: .yes,
            noiseObservation: .moderate,
            createdAt: Date().addingTimeInterval(-86400 * 3),
            updatedAt: Date().addingTimeInterval(-86400 * 3)
        ),
        PlaceDTO(
            id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
            providerId: "demo-daily-brew",
            name: "The Daily Brew & Books",
            address: "Galle Road, Colombo 04",
            latitude: 6.8900,
            longitude: 79.8580,
            category: "Cafés",
            isSaved: false,
            isDemoPlace: true,
            personalNote: nil,
            wifiObservation: .unknown,
            powerObservation: .unknown,
            noiseObservation: .unknown,
            createdAt: Date(),
            updatedAt: Date()
        ),
        PlaceDTO(
            id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
            providerId: "demo-national-reading-room",
            name: "National Reading Room",
            address: "Sir Marcus Fernando Mawatha, Colombo 07",
            latitude: 6.9110,
            longitude: 79.8640,
            category: "Libraries",
            isSaved: false,
            isDemoPlace: true,
            personalNote: nil,
            wifiObservation: .unknown,
            powerObservation: .unknown,
            noiseObservation: .unknown,
            createdAt: Date(),
            updatedAt: Date()
        ),
        PlaceDTO(
            id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
            providerId: "demo-java-study",
            name: "Java Study Lounge",
            address: "Jawatte Road, Colombo 05",
            latitude: 6.8890,
            longitude: 79.8670,
            category: "Cafés",
            isSaved: false,
            isDemoPlace: true,
            personalNote: nil,
            wifiObservation: .unknown,
            powerObservation: .unknown,
            noiseObservation: .unknown,
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    
    public func searchPlaces(
        query: String,
        category: StudyPlaceCategory,
        region: MKCoordinateRegion
    ) async throws -> [PlaceDTO] {
        if isCancelled || Task.isCancelled {
            isCancelled = false
            throw SearchServiceError.cancelled
        }
        
        do {
            if simulatedDelayNanoseconds > 0 {
                try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
            }
        } catch {
            isCancelled = false
            throw SearchServiceError.cancelled
        }
        
        if isCancelled || Task.isCancelled {
            isCancelled = false
            throw SearchServiceError.cancelled
        }
        
        if shouldSimulateError {
            throw SearchServiceError.networkUnavailable
        }
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        return Self.samplePlaces.filter { place in
            // Filter by category
            let matchesCategory: Bool
            switch category {
            case .all:
                matchesCategory = true
            case .library:
                matchesCategory = place.category == "Libraries"
            case .cafe:
                matchesCategory = place.category == "Cafés"
            }
            
            guard matchesCategory else { return false }
            
            // Filter by query
            if trimmed.isEmpty {
                return true
            } else {
                return place.name.lowercased().contains(trimmed) ||
                       place.address.lowercased().contains(trimmed) ||
                       place.category.lowercased().contains(trimmed)
            }
        }
    }
    
    public func cancel() {
        isCancelled = true
    }
}
