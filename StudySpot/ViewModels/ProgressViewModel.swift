import Foundation
import SwiftUI

@MainActor
public final class ProgressViewModel: ObservableObject {
    @Published public var selectedPeriod: ProgressPeriod = .thisWeek {
        didSet {
            loadProgress()
        }
    }
    
    @Published public var aggregate: StudyProgressAggregate = StudyProgressAggregate()
    @Published public var recentSessions: [StudySessionDTO] = []
    @Published public var sessionToEdit: StudySessionDraft? = nil
    @Published public var sessionToDelete: StudySessionDTO? = nil
    @Published public var errorMessage: String? = nil
    
    private let appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public func onAppear() {
        loadProgress()
    }
    
    public func loadProgress() {
        do {
            self.recentSessions = try appState.sessionRepository.fetchAllSessions()
            self.aggregate = try appState.sessionRepository.calculateAggregate(period: selectedPeriod)
        } catch {
            errorMessage = "Failed to load study sessions: \(error.localizedDescription)"
        }
    }
    
    public func startEditing(session: StudySessionDTO) {
        sessionToEdit = StudySessionDraft(
            sessionId: session.id,
            placeId: session.placeId,
            placeName: session.placeName,
            completedAt: session.completedAt,
            durationMinutes: session.durationMinutes,
            focusRating: session.focusRating,
            note: session.note ?? ""
        )
    }
    
    public func saveEditedSession(draft: StudySessionDraft) {
        do {
            _ = try appState.sessionRepository.updateSession(draft: draft)
            sessionToEdit = nil
            loadProgress()
        } catch {
            errorMessage = "Could not update session: \(error.localizedDescription)"
        }
    }
    
    public func deleteSession(_ session: StudySessionDTO) {
        do {
            try appState.sessionRepository.deleteSession(id: session.id)
            sessionToDelete = nil
            loadProgress()
        } catch {
            errorMessage = "Could not delete session: \(error.localizedDescription)"
        }
    }
}
