import Foundation

class LastWeekDataUseCase: LastWeekDataProtocol {
    func calculateLastWeekSleepDuration(sessions: [SleepSession]) -> [DailySleepDuration] {
        guard let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return []
        }
        
        // Фильтруем сессии за последнюю неделю
        let filtered = sessions.filter { $0.sleepStart >= weekAgo }
        
        // Группируем по дням
        let grouped = Dictionary(grouping: filtered) { session in
            Calendar.current.startOfDay(for: session.sleepStart)
        }
        
        // Преобразуем в массив DailySleepData
        return grouped.map { date, sessions in
            let totalDuration = sessions.reduce(0) { $0 + $1.sleepEnd.timeIntervalSince($1.sleepStart) }
            return DailySleepDuration(
                date: date,
                duration: totalDuration
            )
        }
        .sorted { $0.date < $1.date }
    }
    
    func getLastWeekDateRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        guard let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()),
              let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            return ""
        }
        
        let startDate = formatter.string(from: weekAgo)
        let endDate = formatter.string(from: yesterday)
        
        return "\(startDate) - \(endDate)"
    }
}
