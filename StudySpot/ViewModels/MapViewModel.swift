import Foundation
import SwiftUI
import MapKit
import Combine

@MainActor
public final class MapViewModel: ObservableObject {
    @Published public var region: MKCoordinateRegion
    @Published public var markers: [PlaceDTO] = []
    @Published public var selectedPlace: PlaceDTO? = nil
    @Published public var searchText: String = ""
    @Published public var isSearching: Bool = false
    @Published public var locationErrorMessage: String? = nil
    
    private let appState: AppState
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    public init(appState: AppState) {
        self.appState = appState
        self.region = MKCoordinateRegion(
            center: appState.selectedArea.coordinate,
            span: appState.selectedArea.span
        )
        
        // Listen to location service updates
        appState.locationService.$userLocation
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] coord in
                self?.region.center = coord
            }
            .store(in: &cancellables)
            
        appState.locationService.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] err in
                self?.locationErrorMessage = err
            }
            .store(in: &cancellables)
    }
    
    public func onAppear() {
        if markers.isEmpty {
            searchVisibleArea()
        }
    }
    
    public func searchVisibleArea() {
        searchTask?.cancel()
        isSearching = true
        
        let query = searchText
        let currentRegion = region
        let searchService = appState.activeSearchService
        
        searchTask = Task {
            do {
                let places = try await searchService.searchPlaces(
                    query: query.isEmpty ? "study library cafe" : query,
                    category: .all,
                    region: currentRegion
                )
                
                guard !Task.isCancelled else { return }
                
                // Match saved states
                let savedPlaces = (try? self.appState.placeRepository.fetchSavedPlaces()) ?? []
                let savedKeys = Set(savedPlaces.map { $0.deduplicationKey })
                
                self.markers = places.map { place in
                    var p = place
                    p.isSaved = savedKeys.contains(p.deduplicationKey)
                    return p
                }
                
                // Default select the first place if Leaf & Latte is present
                if self.selectedPlace == nil {
                    self.selectedPlace = self.markers.first(where: { $0.name == "Leaf & Latte" }) ?? self.markers.first
                }
                
                self.isSearching = false
            } catch {
                guard !Task.isCancelled else { return }
                self.isSearching = false
            }
        }
    }
    
    public func nearMe() {
        appState.locationService.startUpdatingLocation()
        if let userCoord = appState.locationService.userLocation {
            withAnimation(.easeInOut) {
                region.center = userCoord
                region.span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            }
            searchVisibleArea()
        }
    }
    
    public func selectMarker(_ place: PlaceDTO) {
        selectedPlace = place
    }
}
