import Foundation
import SwiftUI
import MapKit
import Combine

public enum SearchLoadingState: Equatable {
    case idle
    case loading
    case success
    case empty
    case error(String)
}

@MainActor
public final class ExploreViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public var selectedCategory: StudyPlaceCategory = .all
    @Published public var results: [PlaceDTO] = []
    @Published public var loadingState: SearchLoadingState = .idle
    
    private let appState: AppState
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    public init(appState: AppState) {
        self.appState = appState
        
        // Debounce search query typing by 350ms
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }
    
    public func onAppear() {
        if results.isEmpty && loadingState == .idle {
            performSearch()
        } else {
            refreshSavedStatus()
        }
    }
    
    public func selectCategory(_ category: StudyPlaceCategory) {
        guard selectedCategory != category else { return }
        selectedCategory = category
        performSearch()
    }
    
    public func performSearch() {
        searchTask?.cancel()
        loadingState = .loading
        
        let query = searchText
        let category = selectedCategory
        let region = MKCoordinateRegion(
            center: appState.selectedArea.coordinate,
            span: appState.selectedArea.span
        )
        let searchService = appState.activeSearchService
        
        searchTask = Task {
            do {
                let fetched = try await searchService.searchPlaces(
                    query: query,
                    category: category,
                    region: region
                )
                
                guard !Task.isCancelled else { return }
                
                // Overlay saved flags from persistent store
                let savedPlaces = (try? self.appState.placeRepository.fetchSavedPlaces()) ?? []
                let savedIds = Set(savedPlaces.map { $0.deduplicationKey })
                
                var annotatedResults = fetched.map { place -> PlaceDTO in
                    var p = place
                    if savedIds.contains(p.deduplicationKey) {
                        p.isSaved = true
                    }
                    return p
                }
                
                // If in demo mode and no search filter, guarantee Leaf & Latte and Quiet Corner Library are first
                if self.appState.isDemoMode && query.isEmpty && category == .all {
                    annotatedResults.sort { (p1, _) -> Bool in
                        return p1.name == "Leaf & Latte" || p1.name == "Quiet Corner Library"
                    }
                }
                
                self.results = annotatedResults
                self.loadingState = annotatedResults.isEmpty ? .empty : .success
            } catch let error as SearchServiceError {
                guard !Task.isCancelled else { return }
                switch error {
                case .cancelled:
                    break
                case .emptyResults:
                    self.results = []
                    self.loadingState = .empty
                case .networkUnavailable:
                    self.loadingState = .error("No internet connection. Saved study spots remain accessible in Saved Places.")
                case .searchFailed(let msg):
                    self.loadingState = .error(msg)
                }
            } catch {
                guard !Task.isCancelled else { return }
                self.loadingState = .error("An unexpected error occurred during search. Please retry.")
            }
        }
    }
    
    public func toggleBookmark(for place: PlaceDTO) {
        do {
            if place.isSaved {
                // Unsave place
                try appState.placeRepository.unsavePlace(id: place.id)
                updatePlaceSavedState(id: place.id, isSaved: false)
            } else {
                // Save place
                _ = try appState.placeRepository.savePlace(dto: place)
                updatePlaceSavedState(id: place.id, isSaved: true)
            }
        } catch {
            print("Failed to toggle bookmark: \(error.localizedDescription)")
        }
    }
    
    private func updatePlaceSavedState(id: UUID, isSaved: Bool) {
        if let idx = results.firstIndex(where: { $0.id == id }) {
            results[idx].isSaved = isSaved
        }
    }
    
    public func refreshSavedStatus() {
        guard let savedPlaces = try? appState.placeRepository.fetchSavedPlaces() else { return }
        let savedKeys = Set(savedPlaces.map { $0.deduplicationKey })
        for i in 0..<results.count {
            results[i].isSaved = savedKeys.contains(results[i].deduplicationKey)
        }
    }
}
