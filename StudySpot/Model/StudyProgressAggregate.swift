import Foundation

/// Filter period for study progress metrics
public enum ProgressPeriod: String, CaseIterable, Identifiable {
    case thisWeek = "This week"
    case thisMonth = "This month"
    case allTime = "All time"
    
    public var id: String { rawValue }
    public var displayName: String { rawValue }
}

/// Daily study time entry for charts
public struct DailyStudyPoint: Identifiable, Hashable {
    public let id: String
    public let dayLabel: String
    public let date: Date
    public let minutes: Int
    
    public init(dayLabel: String, date: Date, minutes: Int) {
        self.id = dayLabel
        self.dayLabel = dayLabel
        self.date = date
        self.minutes = minutes
    }
}

/// Calculated aggregate study metrics derived from stored Core Data sessions
public struct StudyProgressAggregate: Equatable {
    public let period: ProgressPeriod
    public let totalMinutes: Int
    public let sessionCount: Int
    public let averageFocus: Double
    public let dailyPoints: [DailyStudyPoint]
    
    public init(
        period: ProgressPeriod = .thisWeek,
        totalMinutes: Int = 0,
        sessionCount: Int = 0,
        averageFocus: Double = 0.0,
        dailyPoints: [DailyStudyPoint] = []
    ) {
        self.period = period
        self.totalMinutes = totalMinutes
        self.sessionCount = sessionCount
        self.averageFocus = averageFocus
        self.dailyPoints = dailyPoints
    }
    
    /// Formatted study time matching hero card design (e.g. "3h 30m", "45m", "0m")
    public var heroTimeFormatted: String {
        guard totalMinutes > 0 else { return "0m" }
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Formatted average focus (e.g. "4/5", "4.5/5", "0/5")
    public var averageFocusFormatted: String {
        guard sessionCount > 0 else { return "0/5" }
        if averageFocus.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(averageFocus))/5"
        } else {
            return String(format: "%.1f/5", averageFocus)
        }
    }
    
    /// Calculates aggregate metrics from a list of sessions and a chosen period
    public static func compute(from sessions: [StudySessionDTO], period: ProgressPeriod, calendar: Calendar = .current) -> StudyProgressAggregate {
        let now = Date()
        let filteredSessions: [StudySessionDTO]
        
        switch period {
        case .thisWeek:
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else {
                filteredSessions = sessions
                break
            }
            filteredSessions = sessions.filter { weekInterval.contains($0.completedAt) }
            
        case .thisMonth:
            guard let monthInterval = calendar.dateInterval(of: .month, for: now) else {
                filteredSessions = sessions
                break
            }
            filteredSessions = sessions.filter { monthInterval.contains($0.completedAt) }
            
        case .allTime:
            filteredSessions = sessions
        }
        
        let totalMinutes = filteredSessions.reduce(0) { $0 + $1.durationMinutes }
        let sessionCount = filteredSessions.count
        let averageFocus: Double = sessionCount > 0
            ? Double(filteredSessions.reduce(0) { $0 + $1.focusRating }) / Double(sessionCount)
            : 0.0
        
        // Build 7-day breakdown for This Week
        var dailyPoints: [DailyStudyPoint] = []
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) {
            let daySymbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            var dayStart = weekInterval.start
            
            for i in 0..<7 {
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
                let minutesForDay = filteredSessions
                    .filter { $0.completedAt >= dayStart && $0.completedAt < dayEnd }
                    .reduce(0) { $0 + $1.durationMinutes }
                
                let label = (i < daySymbols.count) ? daySymbols[i] : "Day \(i+1)"
                dailyPoints.append(DailyStudyPoint(dayLabel: label, date: dayStart, minutes: minutesForDay))
                dayStart = dayEnd
            }
        }
        
        return StudyProgressAggregate(
            period: period,
            totalMinutes: totalMinutes,
            sessionCount: sessionCount,
            averageFocus: averageFocus,
            dailyPoints: dailyPoints
        )
    }
}
