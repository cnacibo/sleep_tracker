import Foundation

enum SleepValidationError: Error {
    case invalidScoreFormat
    case scoreOutOfRange
    case invalidTimeRange
}

struct AddSleepUseCase {
    private let repository: SleepRepositoryProtocol
    
    init (repository: SleepRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(startTime: Date, endTime: Date, score: Int, notes: String) throws {
        guard startTime < endTime else {
            throw SleepValidationError.invalidTimeRange
        }
        
        let session = SleepSession(
            sleepStart: startTime,
            sleepEnd: endTime,
            score: score,
            information: notes)
        
        try repository.addSleepSession(session)
    }
}
