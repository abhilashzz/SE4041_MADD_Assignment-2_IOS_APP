import Foundation
import CoreData

public protocol SessionRepositoryProtocol {
    func fetchAllSessions() throws -> [StudySessionDTO]
    func fetchSessions(forPlaceId id: UUID) throws -> [StudySessionDTO]
    func fetchSession(byId id: UUID) throws -> StudySessionDTO?
    func logSession(draft: StudySessionDraft, placeDTO: PlaceDTO) throws -> StudySessionDTO
    func updateSession(draft: StudySessionDraft) throws -> StudySessionDTO
    func deleteSession(id: UUID) throws
    func calculateAggregate(period: ProgressPeriod) throws -> StudyProgressAggregate
}

public final class SessionRepository: SessionRepositoryProtocol {
    private let context: NSManagedObjectContext
    private let placeRepository: PlaceRepository

    public init(context: NSManagedObjectContext, placeRepository: PlaceRepository) {
        self.context = context
        self.placeRepository = placeRepository
    }

    public func fetchAllSessions() throws -> [StudySessionDTO] {
        let request: NSFetchRequest<StudySession> = StudySession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \StudySession.completedAt, ascending: false)]
        let entities = try context.fetch(request)
        return entities.map { $0.toDTO() }
    }

    public func fetchSessions(forPlaceId id: UUID) throws -> [StudySessionDTO] {
        let request: NSFetchRequest<StudySession> = StudySession.fetchRequest()
        request.predicate = NSPredicate(format: "place.id == %@", id as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \StudySession.completedAt, ascending: false)]
        let entities = try context.fetch(request)
        return entities.map { $0.toDTO() }
    }

    public func fetchSession(byId id: UUID) throws -> StudySessionDTO? {
        guard let entity = try fetchSessionEntity(byId: id) else { return nil }
        return entity.toDTO()
    }

    private func fetchSessionEntity(byId id: UUID) throws -> StudySession? {
        let request: NSFetchRequest<StudySession> = StudySession.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    /// Logs a completed study session linked to a place with validation
    public func logSession(draft: StudySessionDraft, placeDTO: PlaceDTO) throws -> StudySessionDTO {
        // Enforce validation
        switch draft.validate() {
        case .failure(let error):
            throw error
        case .success:
            break
        }

        // Ensure place entity exists
        let place = try placeRepository.findOrCreateEntity(for: placeDTO)

        let session = StudySession(context: context)
        session.id = UUID()
        session.completedAt = draft.completedAt
        session.durationMinutes = Int16(draft.durationMinutes)
        session.focusRating = Int16(draft.focusRating)
        session.note = draft.note.isEmpty ? nil : draft.note
        session.place = place

        place.updatedAt = Date()

        try context.save()
        return session.toDTO()
    }

    /// Updates an existing session with validation
    public func updateSession(draft: StudySessionDraft) throws -> StudySessionDTO {
        switch draft.validate() {
        case .failure(let error):
            throw error
        case .success:
            break
        }

        guard let sessionId = draft.sessionId,
              let session = try fetchSessionEntity(byId: sessionId) else {
            throw NSError(domain: "StudySpot", code: 404, userInfo: [NSLocalizedDescriptionKey: "Session not found"])
        }

        session.completedAt = draft.completedAt
        session.durationMinutes = Int16(draft.durationMinutes)
        session.focusRating = Int16(draft.focusRating)
        session.note = draft.note.isEmpty ? nil : draft.note

        try context.save()
        return session.toDTO()
    }

    /// Deletes a session and updates all aggregate metrics
    public func deleteSession(id: UUID) throws {
        guard let session = try fetchSessionEntity(byId: id) else { return }
        context.delete(session)
        try context.save()
    }

    public func calculateAggregate(period: ProgressPeriod) throws -> StudyProgressAggregate {
        let sessions = try fetchAllSessions()
        return StudyProgressAggregate.compute(from: sessions, period: period)
    }
}
