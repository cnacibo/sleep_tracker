import Foundation

struct SleepAnalyticsUseCase : SleepAnalyticsProtocol {
    func lastWeekSessions(sessions: [SleepSession]) -> [SleepSession] {
        guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return []
        }
        return sessions.filter { $0.sleepStart >= sevenDaysAgo }
    }
    
    func averageScore(sessions: [SleepSession]) -> Double {
        let lastWeekSessions = lastWeekSessions(sessions: sessions)
        guard !lastWeekSessions.isEmpty else { return 0 }
        let total = lastWeekSessions.reduce(0) { $0 + Double($1.score) }
        return (total / Double(lastWeekSessions.count)).rounded(toPlaces: 1)
    }
    
    func averageSleepTime(sessions: [SleepSession]) -> (hours: Int, minutes: Int) {
        let lastWeekSessions = lastWeekSessions(sessions: sessions)
        guard !lastWeekSessions.isEmpty else { return (0, 0) }
        
        let totalSeconds = lastWeekSessions.reduce(0.0) { total, session in
            total + session.sleepEnd.timeIntervalSince(session.sleepStart)
        }
        
        let averageSeconds = totalSeconds / Double(lastWeekSessions.count)
        let hours = Int(averageSeconds) / 3600
        let minutes = (Int(averageSeconds) % 3600) / 60
        return (hours, minutes)
    }
    
    func scoreFromApp(sessions: [SleepSession]) -> Double {
        let lastWeekSessions = lastWeekSessions(sessions: sessions)
        guard !lastWeekSessions.isEmpty else { return 0 }
        
        let sessionsByDay = Dictionary(grouping: lastWeekSessions) { session in
            Calendar.current.startOfDay(for: session.sleepStart)
        }
        
        var earlyBedTimeDays = 0
        var goodDurationDays = 0
        let totalDays = sessionsByDay.count
        
        for (_, daySessions) in sessionsByDay {
            
            if let earliestSession = daySessions.min(by: {$0.sleepStart < $1.sleepStart}) {
                let components = Calendar.current.dateComponents([.hour], from: earliestSession.sleepStart)
                if components.hour ?? 0 < 23 {
                    earlyBedTimeDays += 1
                }
            }
            
            let totalDayDuration = daySessions.reduce(0.0) {
                $0 + $1.sleepEnd.timeIntervalSince($1.sleepStart)
            }
            
            let totalHours = totalDayDuration / 3600
            if (8...10).contains(totalHours) {
                goodDurationDays += 1
            }
        }
        
        let earlyBetTimeScore = Double(earlyBedTimeDays) / Double(totalDays) * 50
        let goodDurationDaysScore = Double(goodDurationDays) / Double(totalDays) * 50
        let weekAppScore = (earlyBetTimeScore + goodDurationDaysScore) / 20
        
        return weekAppScore.rounded(toPlaces: 1)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
