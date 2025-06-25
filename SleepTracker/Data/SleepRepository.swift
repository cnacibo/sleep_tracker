import SwiftData
import Foundation

protocol SleepRepositoryProtocol {
    func AddSleepSession(_ session: SleepSession) throws
    func GetLastSleepSession() throws -> SleepSession?
    func GetLastWeekSleep() throws -> [SleepSession?]
}

final class SleepRepository : SleepRepositoryProtocol {
    private let context: ModelContext
    
    init (context: ModelContext) {
        self.context = context
    }
    
    func AddSleepSession(_ session: SleepSession) throws {
        context.insert(session)
    }
    
    func GetLastSleepSession() throws -> SleepSession? {
        var descriptor = FetchDescriptor<SleepSession> (
            sortBy: [SortDescriptor(\SleepSession.sleepStart, order: .reverse)]
        )
        descriptor.fetchLimit = 1 
        
        let sessions = try context.fetch(descriptor)
        
        return sessions.first
    }
    
    func GetLastWeekSleep() throws -> [SleepSession?] {
        var descriptor = FetchDescriptor<SleepSession> (
            sortBy: [SortDescriptor(\SleepSession.sleepStart, order: .reverse)]
        )
        descriptor.fetchLimit = 7
        let sessions = try context.fetch(descriptor)
        return sessions
    }
    
}
