import SwiftData
import Foundation

protocol SleepRepositoryProtocol {
    func addSleepSession(_ session: SleepSession) throws
    func getLastSleepSession() throws -> SleepSession?
    func getLastWeekSleep() throws -> [SleepSession]
}

final class SleepRepository : SleepRepositoryProtocol {
    private let context: ModelContext
    
    init (context: ModelContext) {
        self.context = context
    }
    
    func addSleepSession(_ session: SleepSession) throws {
        context.insert(session)
        try context.save()
    }
    
    func getLastSleepSession() throws -> SleepSession? {
        var descriptor = FetchDescriptor<SleepSession> (
            sortBy: [SortDescriptor(\SleepSession.sleepStart, order: .reverse)]
        )
        descriptor.fetchLimit = 1 
        
        let sessions = try context.fetch(descriptor)
        
        return sessions.first
    }
    
    func getLastWeekSleep() throws -> [SleepSession] {
        var descriptor = FetchDescriptor<SleepSession> (
            sortBy: [SortDescriptor(\SleepSession.sleepStart, order: .reverse)]
        )
        descriptor.fetchLimit = 7
        let sessions = try context.fetch(descriptor)
        return sessions
    }
    
    func getLastWeekSleepDuration() throws -> [DailySleepDuration] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let descriptor = FetchDescriptor<SleepSession> (
            predicate: #Predicate { $0.sleepStart >= weekAgo },
            sortBy: [SortDescriptor(\.sleepStart)]
        )
        
        let sessions = try context.fetch(descriptor)
        
        let grouped = Dictionary(grouping: sessions) { session in
            Calendar.current.startOfDay(for: session.sleepStart)
        }
        
        return grouped.map { date, sessions in
            let totalDuration = sessions.reduce(0) { $0 + $1.sleepEnd.timeIntervalSince($1.sleepStart) }
            return DailySleepDuration(date: date, duration: totalDuration)
        }
        .sorted { $0.date < $1.date }
    }
    
}
