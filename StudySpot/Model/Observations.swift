import Foundation
import SwiftUI

/// Personal observation of Wi-Fi availability at a study spot.
/// NOTE: These are user-entered personal observations, not verified public facts from MapKit.
public enum WiFiObservation: String, CaseIterable, Identifiable, Codable {
    case unknown = "Unknown"
    case yes = "Yes"
    case no = "No"
    case limited = "Limited"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .unknown: return "Wi-Fi: Unknown"
        case .yes: return "Wi-Fi: Available"
        case .no: return "Wi-Fi: None"
        case .limited: return "Wi-Fi: Limited"
        }
    }
    
    public var shortLabel: String {
        switch self {
        case .unknown: return "Wi-Fi: ?"
        case .yes: return "Wi-Fi: Yes"
        case .no: return "Wi-Fi: No"
        case .limited: return "Wi-Fi: Ltd"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .unknown: return "wifi.slash"
        case .yes: return "wifi"
        case .no: return "wifi.exclamationmark"
        case .limited: return "wifi"
        }
    }
}

/// Personal observation of power outlet availability.
public enum PowerObservation: String, CaseIterable, Identifiable, Codable {
    case unknown = "Unknown"
    case yes = "Yes"
    case no = "No"
    case limited = "Few Outlets"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .unknown: return "Power: Unknown"
        case .yes: return "Power: Plentiful"
        case .no: return "Power: None"
        case .limited: return "Power: Few Outlets"
        }
    }
    
    public var shortLabel: String {
        switch self {
        case .unknown: return "Power: ?"
        case .yes: return "Power: Yes"
        case .no: return "Power: No"
        case .limited: return "Power: Few"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .unknown: return "bolt.slash"
        case .yes: return "bolt.fill"
        case .no: return "bolt.badge.xmark"
        case .limited: return "bolt"
        }
    }
}

/// Personal observation of ambient noise level at a study spot.
public enum NoiseObservation: String, CaseIterable, Identifiable, Codable {
    case unknown = "Unknown"
    case quiet = "Quiet"
    case moderate = "Moderate"
    case lively = "Lively"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .unknown: return "Noise: Unknown"
        case .quiet: return "Noise: Quiet"
        case .moderate: return "Noise: Moderate"
        case .lively: return "Noise: Lively"
        }
    }
    
    public var shortLabel: String {
        switch self {
        case .unknown: return "Noise: ?"
        case .quiet: return "Noise: Quiet"
        case .moderate: return "Noise: Moderate"
        case .lively: return "Noise: Lively"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .unknown: return "speaker.slash"
        case .quiet: return "speaker.wave.1.fill"
        case .moderate: return "speaker.wave.2.fill"
        case .lively: return "speaker.wave.3.fill"
        }
    }
}
