import Foundation
import CoreLocation

/// Mock location service for deterministic testing and demo environments
public final class MockLocationService: ObservableObject, LocationServiceProtocol {
    @Published public var authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    @Published public var userLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612) // Colombo
    @Published public var errorMessage: String? = nil
    
    public init() {}
    
    public func requestPermission() {
        authorizationStatus = .authorizedWhenInUse
    }
    
    public func startUpdatingLocation() {
        userLocation = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
    }
    
    public func stopUpdatingLocation() {}
}
