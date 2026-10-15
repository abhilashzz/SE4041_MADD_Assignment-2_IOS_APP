import Foundation
import CoreLocation

/// Protocol defining location authorization and location updates.
public protocol LocationServiceProtocol: AnyObject {
    var authorizationStatus: CLAuthorizationStatus { get }
    var userLocation: CLLocationCoordinate2D? { get }
    var errorMessage: String? { get }
    
    func requestPermission()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}
