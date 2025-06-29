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
    
}
