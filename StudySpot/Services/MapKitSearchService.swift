import Foundation
import MapKit

/// Real MapKit-powered search service using MKLocalSearch
public final class MapKitSearchService: PlaceSearchServiceProtocol {
    private var activeSearch: MKLocalSearch?
    
    public init() {}
    
    public func searchPlaces(
        query: String,
        category: StudyPlaceCategory,
        region: MKCoordinateRegion
    ) async throws -> [PlaceDTO] {
        // Cancel any in-flight search
        cancel()
        
        let request = MKLocalSearch.Request()
        
        let cleanQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanQuery.isEmpty {
            request.naturalLanguageQuery = category.searchQuery
        } else {
            // Append category keywords if specific category selected
            if category != .all {
                request.naturalLanguageQuery = "\(cleanQuery) \(category.singularName)"
            } else {
                request.naturalLanguageQuery = cleanQuery
            }
        }
        
        request.region = region
        request.resultTypes = .pointOfInterest
        
        let search = MKLocalSearch(request: request)
        self.activeSearch = search
        
        do {
            let response = try await search.start()
            self.activeSearch = nil
            
            let places: [PlaceDTO] = response.mapItems.compactMap { item -> PlaceDTO? in
                guard let name = item.name, !name.isEmpty else { return nil }
                let coord = item.placemark.coordinate
                
                // Format readable address
                let placemark = item.placemark
                var addressParts: [String] = []
                if let subThoroughfare = placemark.subThoroughfare { addressParts.append(subThoroughfare) }
                if let thoroughfare = placemark.thoroughfare { addressParts.append(thoroughfare) }
                if let locality = placemark.locality { addressParts.append(locality) }
                if let admin = placemark.administrativeArea { addressParts.append(admin) }
                let address = addressParts.isEmpty ? (placemark.title ?? "") : addressParts.joined(separator: ", ")
                
                // Determine category tag
                let detectedCategory: String
                let lowerName = name.lowercased()
                if lowerName.contains("cafe") || lowerName.contains("café") || lowerName.contains("coffee") || lowerName.contains("bakes") {
                    detectedCategory = "Cafés"
                } else if lowerName.contains("library") || lowerName.contains("books") || lowerName.contains("reading") {
                    detectedCategory = "Libraries"
                } else {
                    detectedCategory = category == .all ? "Study Spot" : category.displayName
                }
                
                // Stable provider identifier if available
                let providerId: String
                if let phone = item.phoneNumber, !phone.isEmpty {
                    providerId = "tel:\(phone)"
                } else {
                    providerId = "\(name)@\(String(format: "%.4f,%.4f", coord.latitude, coord.longitude))"
                }
                
                return PlaceDTO(
                    id: UUID(),
                    providerId: providerId,
                    name: name,
                    address: address,
                    latitude: coord.latitude,
                    longitude: coord.longitude,
                    category: detectedCategory,
                    isSaved: false,
                    isDemoPlace: false,
                    personalNote: nil,
                    wifiObservation: .unknown,
                    powerObservation: .unknown,
                    noiseObservation: .unknown,
                    createdAt: Date(),
                    updatedAt: Date()
                )
            }
            
            return places
        } catch let error as NSError {
            self.activeSearch = nil
            if error.code == NSURLErrorCancelled {
                throw SearchServiceError.cancelled
            } else if error.domain == NSURLErrorDomain {
                throw SearchServiceError.networkUnavailable
            } else {
                throw SearchServiceError.searchFailed(error.localizedDescription)
            }
        }
    }
    
    public func cancel() {
        activeSearch?.cancel()
        activeSearch = nil
    }
}
