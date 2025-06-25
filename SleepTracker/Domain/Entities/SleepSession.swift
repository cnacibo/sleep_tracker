import SwiftData
import Foundation

@Model
class SleepSession {
    var sleepStart: Date
    var sleepEnd: Date
    var score: Int
    var information: String?
    
    init (sleepStart: Date, sleepEnd: Date, score: Int, information: String?) {
        self.sleepStart = sleepStart
        self.sleepEnd = sleepEnd
        self.score = score
        self.information = information
    }
    
    var duration: (hours: Int, minutes: Int) {
        let components = Calendar.current.dateComponents(
            [.hour, .minute],
            from: sleepStart,
            to: sleepEnd
        )
        return (
            hours: components.hour ?? 0,
            minutes: components.minute ?? 0
        )
    }
}
