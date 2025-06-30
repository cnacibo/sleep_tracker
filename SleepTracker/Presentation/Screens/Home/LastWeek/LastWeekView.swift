import SwiftUI
import SwiftData
import Charts

struct LastWeekView: View {
    let sessions: [SleepSession]
    private let lastWeekData: LastWeekDataProtocol
    
    init(sessions: [SleepSession], lastWeekData: LastWeekDataProtocol = LastWeekDataUseCase()) {
        self.sessions = sessions
        self.lastWeekData = lastWeekData
    }
    
    private var lastWeekSessions: [DailySleepDuration] {
        lastWeekData.calculateLastWeekSleepDuration(sessions: sessions)
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.indigo)
                Text("Last Week")
                    .font(.title2.bold())
                Text(lastWeekData.getLastWeekDateRange())
                    .foregroundColor(.secondary)
            }
            if !lastWeekSessions.isEmpty {
                Chart {
                    ForEach(lastWeekSessions) { data in
                        BarMark(
                            x: .value("Day", data.date, unit: .day),
                            y: .value("Hours", data.duration / 3600)
                        )
                        .foregroundStyle(.indigo.opacity(0.8))
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
    

    return LastWeekView(sessions: sessions)
        .modelContainer(try! ModelContainer(for: SleepSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)))
}

#Preview("With data") {
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
