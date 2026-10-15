import XCTest
@testable import StudySpot

final class ProgressAggregationTests: XCTestCase {
    
    func testHeroTimeFormatting() {
        var agg = StudyProgressAggregate(totalMinutes: 210) // 3h 30m
        XCTAssertEqual(agg.heroTimeFormatted, "3h 30m")
        
        agg = StudyProgressAggregate(totalMinutes: 60)
        XCTAssertEqual(agg.heroTimeFormatted, "1h")
        
        agg = StudyProgressAggregate(totalMinutes: 45)
        XCTAssertEqual(agg.heroTimeFormatted, "45m")
        
        agg = StudyProgressAggregate(totalMinutes: 0)
        XCTAssertEqual(agg.heroTimeFormatted, "0m")
    }
    
    func testAverageFocusFormatting() {
        let agg1 = StudyProgressAggregate(sessionCount: 2, averageFocus: 4.0)
        XCTAssertEqual(agg1.averageFocusFormatted, "4/5")
        
        let agg2 = StudyProgressAggregate(sessionCount: 3, averageFocus: 4.333)
        XCTAssertEqual(agg2.averageFocusFormatted, "4.3/5")
        
        let aggZero = StudyProgressAggregate(sessionCount: 0, averageFocus: 0.0)
        XCTAssertEqual(aggZero.averageFocusFormatted, "0/5")
    }
    
    func testDateRangeFiltering() {
        let now = Date()
        let placeId = UUID()
        
        let sessionToday = StudySessionDTO(
            placeId: placeId,
            placeName: "Spot 1",
            completedAt: now,
            durationMinutes: 90,
            focusRating: 5
        )
        let sessionYesterday = StudySessionDTO(
            placeId: placeId,
            placeName: "Spot 2",
            completedAt: now.addingTimeInterval(-86400 * 1),
            durationMinutes: 60,
            focusRating: 4
        )
        let sessionLastYear = StudySessionDTO(
            placeId: placeId,
            placeName: "Old Spot",
            completedAt: now.addingTimeInterval(-86400 * 300),
            durationMinutes: 120,
            focusRating: 3
        )
        
        let all = [sessionToday, sessionYesterday, sessionLastYear]
        
        // This week calculation
        let weekAgg = StudyProgressAggregate.compute(from: all, period: .thisWeek)
        XCTAssertTrue(weekAgg.sessionCount >= 2)
        XCTAssertFalse(weekAgg.dailyPoints.isEmpty)
        
        // All time calculation
        let allAgg = StudyProgressAggregate.compute(from: all, period: .allTime)
        XCTAssertEqual(allAgg.sessionCount, 3)
        XCTAssertEqual(allAgg.totalMinutes, 270) // 90 + 60 + 120
    }
}
