import Foundation
import MapKit

public enum SearchServiceError: LocalizedError, Equatable {
    case networkUnavailable
    case searchFailed(String)
    case cancelled
    case emptyResults
    
    public var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Unable to connect to search service. Please check your internet connection."
        case .searchFailed(let message):
            return "Search failed: \(message)"
        case .cancelled:
            return "Search was cancelled."
        case .emptyResults:
            return "No study spots found in this area. Try searching for a different place or café."
        }
    }
}

/// Protocol for searching study locations, enabling swapping real MapKit and mock implementations.
public protocol PlaceSearchServiceProtocol: AnyObject {
    func searchPlaces(
        query: String,
        category: StudyPlaceCategory,
        region: MKCoordinateRegion
    ) async throws -> [PlaceDTO]
    
    func cancel()
}
