import Foundation
import CoreLocation

/// Real CoreLocation service managing When In Use location permissions and updates.
public final class CoreLocationService: NSObject, ObservableObject, CLLocationManagerDelegate, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    
    @Published public private(set) var authorizationStatus: CLAuthorizationStatus
    @Published public private(set) var userLocation: CLLocationCoordinate2D?
    @Published public private(set) var errorMessage: String?
    
    public override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    public func requestPermission() {
        // Only request When In Use permission on explicit user interaction ("Near Me")
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            errorMessage = "Location services are disabled on this device. You can still search manually."
            return
        }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            requestPermission()
        case .denied, .restricted:
            errorMessage = "Location permission was denied. You can re-enable it in iOS Settings, or explore the map manually."
        case .authorizedWhenInUse, .authorizedAlways:
            errorMessage = nil
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.errorMessage = nil
                self.locationManager.startUpdatingLocation()
            case .denied, .restricted:
                self.errorMessage = "Location access is not available. Manual map search is fully enabled."
            default:
                break
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
            // Stop updates once a reasonable fix is acquired to conserve device battery
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Could not determine location: \(error.localizedDescription)"
        }
    }
}
