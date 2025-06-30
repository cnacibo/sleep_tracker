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
    
    var phases: (deep: Int, rem: Int, awake: Int, light: Int) {
        let totalMinutes = Calendar.current.dateComponents([.minute], from: sleepStart, to: sleepEnd).minute ?? 0
        
        guard totalMinutes > 0 else {
            return (0, 0, 0, 0)
        }
        
        let deepSleep = Int(Double(totalMinutes) * 0.25)
        let remSleep = Int(Double(totalMinutes) * 0.3)
        let lightSleep = Int(Double(totalMinutes) * 0.36)
        let awakeSleep = totalMinutes - deepSleep - remSleep - lightSleep
        
        return (
            deep: max(deepSleep, 0),
            rem: max(remSleep, 0),
            awake: max(awakeSleep, 0),
            light: max(lightSleep, 0)
        )
    }
}
