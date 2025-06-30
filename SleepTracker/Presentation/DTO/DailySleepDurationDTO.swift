import Foundation

struct DailySleepDuration: Identifiable {
    let id = UUID()
    let date: Date
    let duration: TimeInterval
}
