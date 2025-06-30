import Foundation

protocol LastWeekDataProtocol {
    func calculateLastWeekSleepDuration(sessions: [SleepSession]) -> [DailySleepDuration]
    func getLastWeekDateRange() -> String
}
