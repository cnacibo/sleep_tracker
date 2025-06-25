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
    
    func execute(startTime: Date, endTime: Date, score: String, notes: String) throws {
        guard let scoreValue = Int(score) else {
            throw SleepValidationError.invalidScoreFormat
        }
        
        guard (1...5).contains(scoreValue) else {
            throw SleepValidationError.scoreOutOfRange
        }
        
        guard startTime < endTime else {
            throw SleepValidationError.invalidTimeRange
        }
        
        let session = SleepSession(sleepStart: startTime, sleepEnd: endTime, score: scoreValue, information: notes)
        try repository.AddSleepSession(session)
    }
}
