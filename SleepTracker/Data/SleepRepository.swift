import SwiftData

protocol SleepRepositoryProtocol {
    func AddSleepSession(_ session: SleepSession) throws
}

final class SleepRepository : SleepRepositoryProtocol {
    private let context: ModelContext
    
    init (context: ModelContext) {
        self.context = context
    }
    
    func AddSleepSession(_ session: SleepSession) throws {
        context.insert(session)
    }
    
}
