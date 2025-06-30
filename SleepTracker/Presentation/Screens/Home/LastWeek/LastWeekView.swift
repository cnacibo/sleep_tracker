import SwiftUI
import SwiftData
import Charts

struct LastWeekView: View {
    let sessions: [SleepSession]
    
    private var lastWeekDateRange: String {
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
    
    private var lastWeekSessions: [DailySleepDuration] {
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
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.indigo)
                Text("Last Week")
                    .font(.title2.bold())
                Text(lastWeekDateRange)
            }
            if !lastWeekSessions.isEmpty {
                Chart {
                    ForEach(lastWeekSessions) { data in
                        BarMark(
                            x: .value("Day", data.date, unit: .day),
                            y: .value("Hours", data.duration / 3600)
                        )
                        .foregroundStyle(.indigo)
                        .annotation(position: .top) {
                            Text("\(String(format: "%.1f", data.duration / 3600))h")
                                .font(.system(size: 10))
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)
                .padding(.top)
            } else {
                Text("No data for last week")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding()
        
    }
}

#Preview {
    var sessions: [SleepSession] = []
    
    // Генерируем данные за последние 7 дней
    for dayOffset in 0..<7 {
        // Определяем дату для этого дня (от сегодня назад)
        let dayStart = Calendar.current.date(byAdding: .day, value: -dayOffset, to: .now)!
        
        // Создаем 1-2 сессии сна для каждого дня с разным временем сна
        let session1 = SleepSession(
            sleepStart: Calendar.current.date(byAdding: .hour, value: -8, to: dayStart)!,
            sleepEnd: dayStart,
            score: Int.random(in: 1...5),
            information: ["Good sleep", "Felt OK", "Tired"][Int.random(in: 0...2)]
        )
        
        // Иногда добавляем вторую сессию сна в тот же день (например, дневной сон)
        if dayOffset % 2 == 0 {
            let session2 = SleepSession(
                sleepStart: Calendar.current.date(byAdding: .hour, value: -2, to: dayStart)!,
                sleepEnd: Calendar.current.date(byAdding: .hour, value: -1, to: dayStart)!,
                score: Int.random(in: 1...5),
                information: "Nap"
            )
            sessions.append(session2)
        }
        
        sessions.append(session1)
    }
    return LastWeekView(sessions: sessions)
        .modelContainer(try! ModelContainer(for: SleepSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)))
}
