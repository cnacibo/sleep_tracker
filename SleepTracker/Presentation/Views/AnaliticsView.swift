import SwiftUI
import SwiftData

struct AnaliticsView: View {

    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    var averageScore: Float {
        let lastWeekSessions = sessions.filter { session in
            
            guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return false }
            return session.sleepStart >= sevenDaysAgo
        }
        guard !lastWeekSessions.isEmpty else { return 0 }
        
        let total = lastWeekSessions.reduce(0) { $0 + Float($1.score) }
        return total / Float(lastWeekSessions.count)
    }
    
    var averageSleepTime: (hours: Int, minutes: Int) {
        let lastWeekSessions = sessions.filter { session in
            guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return false }
            return session.sleepStart >= sevenDaysAgo
        }
        guard !lastWeekSessions.isEmpty else { return (0,0) }
        
        let totalSeconds = lastWeekSessions.reduce(0.0) { total, session in
            total + session.sleepEnd.timeIntervalSince(session.sleepStart)
        }
        
        let averageSeconds = totalSeconds / Double(lastWeekSessions.count)
        let hours = Int(averageSeconds) / 3600
        let minutes = (Int(averageSeconds) % 3600) / 60
        return (hours, minutes)
    }
    
    var body: some View {
        Text("Average score: \(averageScore, specifier: "%.2f")")
        Text("Average time: \(averageSleepTime.hours)h \(averageSleepTime.hours)m ")
    }
}

#Preview {
    AnaliticsView()
}
