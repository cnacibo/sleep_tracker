import Foundation

struct AnalyzeWeekUseCase {
    private let repository: SleepRepositoryProtocol
    
    init(repository: SleepRepositoryProtocol) {
        self.repository = repository
    }
    
    func getAverageScore() async throws -> Float {
        let weekSleep = try repository.getLastWeekSleep()
        var averageScore: Float = 0.0
        let validSleeps = weekSleep.compactMap { $0 }
        
        for sleep in validSleeps {
            averageScore += Float(sleep.score)
        }
        
        if validSleeps.isEmpty {
            return 0.0
        }
        
        return averageScore / Float(validSleeps.count)
    }
}
