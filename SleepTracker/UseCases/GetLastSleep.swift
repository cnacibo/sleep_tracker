import Foundation

enum GettingLastSleepError: Error {
    case sleepSessionsEmpty
}

struct GetLastSleepUseCase {
    private let repository: SleepRepositoryProtocol
    
    
    init (repository: SleepRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> SleepSummary? {
        guard let lastSleep = try repository.getLastSleepSession() else {
            throw GettingLastSleepError.sleepSessionsEmpty
        }
        
        return SleepSummary(
            duration: lastSleep.duration,
            score: lastSleep.score,
            information: lastSleep.information
        )
    }
}
