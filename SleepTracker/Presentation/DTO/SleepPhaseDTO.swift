import Foundation

enum SleepPhaseType: String {
    case deep = "Deep"
    case light = "Light"
    case rem = "REM"
    case awake = "Awake"
}

struct SleepPhase : Identifiable {
    let id = UUID()
    let type: SleepPhaseType
    let duration: Int
}
