import Foundation
import SwiftUI
import MapKit

@MainActor
public final class PlaceDetailsViewModel: ObservableObject {
    @Published public var place: PlaceDTO
    @Published public var sessions: [StudySessionDTO] = []
    @Published public var isSaved: Bool
    @Published public var showEditNotesSheet: Bool = false
    @Published public var showLogSessionSheet: Bool = false
    @Published public var showDeleteConfirmation: Bool = false
    @Published public var feedbackMessage: String? = nil
    
    private let appState: AppState
    
    public init(place: PlaceDTO, appState: AppState) {
        self.place = place
        self.appState = appState
        self.isSaved = place.isSaved
        loadData()
    }
    
    public func loadData() {
        // Fetch persisted place data if present
        if let stored = try? appState.placeRepository.fetchPlaceDTO(byId: place.id) {
            self.place = stored
            self.isSaved = stored.isSaved
        }
        
        // Fetch sessions linked to this place
        if let sessions = try? appState.sessionRepository.fetchSessions(forPlaceId: place.id) {
            self.sessions = sessions
        }
    }
    
    public func toggleSave() {
        do {
            if isSaved {
                try appState.placeRepository.unsavePlace(id: place.id)
                isSaved = false
                place.isSaved = false
            } else {
                let saved = try appState.placeRepository.savePlace(dto: place)
                isSaved = true
                place = saved
            }
        } catch {
            feedbackMessage = "Failed to update saved spot: \(error.localizedDescription)"
        }
    }
    
    public func updateObservations(
        wifi: WiFiObservation,
        power: PowerObservation,
        noise: NoiseObservation,
        personalNote: String?
    ) {
        do {
            // Ensure place is persisted
            if !isSaved {
                _ = try appState.placeRepository.savePlace(dto: place)
                isSaved = true
            }
            
            try appState.placeRepository.updateObservations(
                id: place.id,
                wifi: wifi,
                power: power,
                noise: noise,
                personalNote: personalNote
            )
            
            place.wifiObservation = wifi
            place.powerObservation = power
            place.noiseObservation = noise
            place.personalNote = personalNote
            place.updatedAt = Date()
            
            showEditNotesSheet = false
        } catch {
            feedbackMessage = "Failed to save observations: \(error.localizedDescription)"
        }
    }
    
    public func logSession(draft: StudySessionDraft) {
        do {
            // Save place first if not already stored
            let targetDTO = try appState.placeRepository.savePlace(dto: place)
            self.place = targetDTO
            self.isSaved = true
            
            _ = try appState.sessionRepository.logSession(draft: draft, placeDTO: targetDTO)
            loadData()
            showLogSessionSheet = false
        } catch {
            feedbackMessage = "Could not log session: \(error.localizedDescription)"
        }
    }
    
    public var linkedSessionCount: Int {
        appState.placeRepository.sessionCount(forPlaceId: place.id)
    }
    
    public func deletePlacePermanently() throws {
        try appState.placeRepository.deletePlacePermanently(id: place.id)
    }
    
    public func openAppleMapsDirections() {
        let placemark = MKPlacemark(coordinate: place.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place.name
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]
        
        let opened = mapItem.openInMaps(launchOptions: launchOptions)
        if !opened {
            feedbackMessage = "Apple Maps could not be launched on this device."
        }
    }
}
