import Foundation

protocol SleepAnalyticsProtocol {
    func lastWeekSessions(sessions: [SleepSession]) -> [SleepSession]
    func averageScore(sessions: [SleepSession]) -> Double
    func averageSleepTime(sessions: [SleepSession]) -> (hours: Int, minutes: Int)
    func scoreFromApp(sessions: [SleepSession]) -> Double
}
