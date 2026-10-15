import Foundation
import SwiftUI
import CoreData
import MapKit

public enum AppTab: Int, CaseIterable, Identifiable {
    case explore = 0
    case map = 1
    case saved = 2
    case progress = 3
    
    public var id: Int { rawValue }
    
    public var title: String {
        switch self {
        case .explore: return "Explore"
        case .map: return "Map"
        case .saved: return "Saved"
        case .progress: return "Progress"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .explore: return "sparkles"
        case .map: return "mappin.and.ellipse"
        case .saved: return "bookmark.fill"
        case .progress: return "chart.bar.fill"
        }
    }
}

public struct SearchArea: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let coordinate: CLLocationCoordinate2D
    public let span: MKCoordinateSpan
    
    public init(name: String, latitude: Double, longitude: Double, latSpan: Double = 0.08, lonSpan: Double = 0.08) {
        self.id = name
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.span = MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
    }
    
    public static let colombo = SearchArea(name: "Colombo", latitude: 6.9271, longitude: 79.8612)
    public static let kandy = SearchArea(name: "Kandy", latitude: 7.2906, longitude: 80.6337)
    public static let galle = SearchArea(name: "Galle", latitude: 6.0535, longitude: 80.2210)
    public static let negombo = SearchArea(name: "Negombo", latitude: 7.2008, longitude: 79.8736)
    
    public static let presetAreas: [SearchArea] = [.colombo, .kandy, .galle, .negombo]
    
    public static func == (lhs: SearchArea, rhs: SearchArea) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Global Application State coordinating navigation, repositories, and Demo Mode
@MainActor
public final class AppState: ObservableObject {
    @Published public var selectedTab: AppTab = .explore
    @Published public var isDemoMode: Bool = false {
        didSet {
            setupRepositories()
        }
    }
    
    @Published public var selectedArea: SearchArea = .colombo
    @Published public var showAboutSheet: Bool = false
    @Published public var showAreaPickerSheet: Bool = false
    
    // Repositories
    public private(set) var placeRepository: PlaceRepository
    public private(set) var sessionRepository: SessionRepository
    
    // Services
    public let searchService: PlaceSearchServiceProtocol
    public let mockSearchService: MockPlaceSearchService
    public let locationService: CoreLocationService
    
    public init(
        persistenceController: PersistenceController = .shared,
        searchService: PlaceSearchServiceProtocol = MapKitSearchService(),
        locationService: CoreLocationService = CoreLocationService()
    ) {
        let placeRepo = PlaceRepository(context: persistenceController.container.viewContext)
        let sessionRepo = SessionRepository(context: persistenceController.container.viewContext, placeRepository: placeRepo)
        
        self.placeRepository = placeRepo
        self.sessionRepository = sessionRepo
        self.searchService = searchService
        self.mockSearchService = MockPlaceSearchService()
        self.locationService = locationService
    }
    
    private func setupRepositories() {
        let context = isDemoMode
            ? PersistenceController.demo.container.viewContext
            : PersistenceController.shared.container.viewContext
        
        if isDemoMode {
            PersistenceController.demo.seedSampleData(context: context)
        }
        
        let placeRepo = PlaceRepository(context: context)
        let sessionRepo = SessionRepository(context: context, placeRepository: placeRepo)
        
        self.placeRepository = placeRepo
        self.sessionRepository = sessionRepo
    }
    
    /// Returns the active search service depending on whether demo mode is enabled
    public var activeSearchService: PlaceSearchServiceProtocol {
        isDemoMode ? mockSearchService : searchService
    }
}
