import Foundation
import CoreData

/// Protocol for place persistence operations, enabling dependency injection for unit testing.
public protocol PlaceRepositoryProtocol {
    func fetchSavedPlaces() throws -> [PlaceDTO]
    func fetchAllPlaces() throws -> [PlaceDTO]
    func fetchPlaceDTO(byId id: UUID) throws -> PlaceDTO?
    func savePlace(dto: PlaceDTO) throws -> PlaceDTO
    func unsavePlace(id: UUID) throws
    func updateObservations(
        id: UUID,
        wifi: WiFiObservation,
        power: PowerObservation,
        noise: NoiseObservation,
        personalNote: String?
    ) throws
    func deletePlacePermanently(id: UUID) throws
    func sessionCount(forPlaceId id: UUID) -> Int
}

public final class PlaceRepository: PlaceRepositoryProtocol {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// Fetches all places marked as isSaved = true, ordered by most recently updated
    public func fetchSavedPlaces() throws -> [PlaceDTO] {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "isSaved == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Place.updatedAt, ascending: false)]
        let entities = try context.fetch(request)
        return entities.map { $0.toDTO() }
    }

    /// Fetches all places in the local database (whether saved or holding sessions)
    public func fetchAllPlaces() throws -> [PlaceDTO] {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Place.updatedAt, ascending: false)]
        let entities = try context.fetch(request)
        return entities.map { $0.toDTO() }
    }

    public func fetchPlaceDTO(byId id: UUID) throws -> PlaceDTO? {
        guard let place = try fetchEntity(byId: id) else { return nil }
        return place.toDTO()
    }

    /// Fetches internal Place NSManagedObject by UUID
    public func fetchEntity(byId id: UUID) throws -> Place? {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    /// Finds an existing place using deduplication rules or creates a new one
    public func findOrCreateEntity(for dto: PlaceDTO) throws -> Place {
        // 1. Check by ID if known
        if let existing = try fetchEntity(byId: dto.id) {
            updateAttributes(of: existing, with: dto)
            return existing
        }

        // 2. Check by providerId
        if let providerId = dto.providerId, !providerId.isEmpty {
            let request: NSFetchRequest<Place> = Place.fetchRequest()
            request.predicate = NSPredicate(format: "providerId ==[c] %@", providerId)
            request.fetchLimit = 1
            if let existing = try context.fetch(request).first {
                updateAttributes(of: existing, with: dto)
                return existing
            }
        }

        // 3. Check by normalized name and proximity (~100m)
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        let latDelta = 0.001
        let lonDelta = 0.001
        request.predicate = NSPredicate(
            format: "name ==[c] %@ AND latitude BETWEEN {%lf, %lf} AND longitude BETWEEN {%lf, %lf}",
            dto.name,
            dto.latitude - latDelta, dto.latitude + latDelta,
            dto.longitude - lonDelta, dto.longitude + lonDelta
        )
        request.fetchLimit = 1
        if let existing = try context.fetch(request).first {
            updateAttributes(of: existing, with: dto)
            return existing
        }

        // 4. Create new place entity
        let newPlace = Place(context: context)
        newPlace.id = dto.id
        newPlace.providerId = dto.providerId
        newPlace.createdAt = Date()
        updateAttributes(of: newPlace, with: dto)
        return newPlace
    }

    private func updateAttributes(of place: Place, with dto: PlaceDTO) {
        place.name = dto.name
        place.address = dto.address
        place.latitude = dto.latitude
        place.longitude = dto.longitude
        place.category = dto.category
        place.wifiObservation = dto.wifiObservation.rawValue
        place.powerObservation = dto.powerObservation.rawValue
        place.noiseObservation = dto.noiseObservation.rawValue
        if let note = dto.personalNote {
            place.personalNote = note
        }
        place.updatedAt = Date()
    }

    /// Saves a place as a favourite/bookmark without creating duplicates
    public func savePlace(dto: PlaceDTO) throws -> PlaceDTO {
        let place = try findOrCreateEntity(for: dto)
        place.isSaved = true
        place.updatedAt = Date()
        try context.save()
        return place.toDTO()
    }

    /// Unmarking favourite flag preserves the place and all session history!
    public func unsavePlace(id: UUID) throws {
        guard let place = try fetchEntity(byId: id) else { return }
        place.isSaved = false
        place.updatedAt = Date()
        try context.save()
    }

    /// Updates personal observations and personal note
    public func updateObservations(
        id: UUID,
        wifi: WiFiObservation,
        power: PowerObservation,
        noise: NoiseObservation,
        personalNote: String?
    ) throws {
        guard let place = try fetchEntity(byId: id) else { return }
        place.wifiObservation = wifi.rawValue
        place.powerObservation = power.rawValue
        place.noiseObservation = noise.rawValue
        place.personalNote = personalNote
        place.updatedAt = Date()
        try context.save()
    }

    /// Counts how many sessions are linked to this place
    public func sessionCount(forPlaceId id: UUID) -> Int {
        guard let place = try? fetchEntity(byId: id) else { return 0 }
        return place.safeSessionsArray.count
    }

    /// Permanently deletes a local place and all associated study sessions
    public func deletePlacePermanently(id: UUID) throws {
        guard let place = try fetchEntity(byId: id) else { return }
        context.delete(place)
        try context.save()
    }
}
