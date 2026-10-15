import Foundation
import SwiftUI

@MainActor
public final class SavedPlacesViewModel: ObservableObject {
    @Published public var savedPlaces: [PlaceDTO] = []
    @Published public var searchText: String = ""
    @Published public var placeToEditNotes: PlaceDTO? = nil
    @Published public var placeToDelete: PlaceDTO? = nil
    @Published public var errorMessage: String? = nil
    
    private let appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public func onAppear() {
        loadSavedPlaces()
    }
    
    public func loadSavedPlaces() {
        do {
            self.savedPlaces = try appState.placeRepository.fetchSavedPlaces()
        } catch {
            self.errorMessage = "Failed to load saved places: \(error.localizedDescription)"
        }
    }
    
    public var filteredPlaces: [PlaceDTO] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty {
            return savedPlaces
        }
        return savedPlaces.filter { place in
            place.name.lowercased().contains(trimmed) ||
            place.address.lowercased().contains(trimmed) ||
            (place.personalNote?.lowercased().contains(trimmed) ?? false) ||
            place.category.lowercased().contains(trimmed)
        }
    }
    
    public func unsavePlace(_ place: PlaceDTO) {
        do {
            try appState.placeRepository.unsavePlace(id: place.id)
            loadSavedPlaces()
        } catch {
            errorMessage = "Failed to unsave place: \(error.localizedDescription)"
        }
    }
    
    public func deletePermanently(_ place: PlaceDTO) {
        do {
            try appState.placeRepository.deletePlacePermanently(id: place.id)
            loadSavedPlaces()
        } catch {
            errorMessage = "Failed to delete place: \(error.localizedDescription)"
        }
    }
}
