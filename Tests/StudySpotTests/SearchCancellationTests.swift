import XCTest
import MapKit
@testable import StudySpot

final class SearchCancellationTests: XCTestCase {
    
    func testMockSearchCategoryFiltering() async throws {
        let service = MockPlaceSearchService()
        service.simulatedDelayNanoseconds = 0
        
        let colomboRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        // Search Cafes
        let cafes = try await service.searchPlaces(query: "", category: .cafe, region: colomboRegion)
        XCTAssertFalse(cafes.isEmpty)
        for c in cafes {
            XCTAssertEqual(c.category, "Cafés")
        }
        
        // Search Libraries
        let libraries = try await service.searchPlaces(query: "", category: .library, region: colomboRegion)
        XCTAssertFalse(libraries.isEmpty)
        for l in libraries {
            XCTAssertEqual(l.category, "Libraries")
        }
    }
    
    func testMockSearchQueryFiltering() async throws {
        let service = MockPlaceSearchService()
        service.simulatedDelayNanoseconds = 0
        let region = MKCoordinateRegion()
        
        let results = try await service.searchPlaces(query: "Leaf", category: .all, region: region)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Leaf & Latte")
    }
    
    func testMockSearchErrorSimulation() async {
        let service = MockPlaceSearchService()
        service.simulatedDelayNanoseconds = 0
        service.shouldSimulateError = true
        let region = MKCoordinateRegion()
        
        do {
            _ = try await service.searchPlaces(query: "", category: .all, region: region)
            XCTFail("Should throw networkUnavailable error")
        } catch {
            XCTAssertEqual(error as? SearchServiceError, .networkUnavailable)
        }
    }
    
    func testCancellation() async {
        let service = MockPlaceSearchService()
        service.simulatedDelayNanoseconds = 100_000_000 // 100ms
        let region = MKCoordinateRegion()
        
        let task = Task {
            try await service.searchPlaces(query: "Leaf", category: .all, region: region)
        }
        
        service.cancel()
        
        do {
            _ = try await task.value
            XCTFail("Expected cancelled error")
        } catch {
            XCTAssertEqual(error as? SearchServiceError, .cancelled)
        }
    }
}
