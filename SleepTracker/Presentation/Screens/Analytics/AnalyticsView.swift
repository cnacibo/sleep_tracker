import SwiftUI
import SwiftData

struct AnalyticsView: View {
    
    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    // Цветовая схема
    private let primaryColor = Color.indigo
    private let secondaryColor = Color.teal
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Заголовок
                    HeaderView()
                    
                    // Основные метрики
                    HStack(spacing: 16) {
                        MetricCard(
                            value: "\(averageScore)",
                            title: "Средняя оценка",
                            icon: "star.fill",
                            color: primaryColor
                        )
                        
                        MetricCard(
                            value: "\(averageSleepTime.hours)ч \(averageSleepTime.minutes)м",
                            title: "Средняя длительность",
                            icon: "moon.zzz.fill",
                            color: secondaryColor
                        )
                    }
                    .padding(.horizontal)
                    
                    // График сна за неделю
                    SleepChartView(sessions: lastWeekSessions)
                        .frame(height: 200)
                        .padding(.horizontal)
                    
                    // Детализация по дням
                    DailySleepView(sessions: lastWeekSessions)
                }
                .padding(.vertical)
            }
            .navigationTitle("Аналитика сна")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - Вычисляемые свойства
    
    private var lastWeekSessions: [SleepSession] {
        guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return []
        }
        return sessions.filter { $0.sleepStart >= sevenDaysAgo }
    }
    
    private var averageScore: Double {
        guard !lastWeekSessions.isEmpty else { return 0 }
        let total = lastWeekSessions.reduce(0) { $0 + Double($1.score) }
        return total / Double(lastWeekSessions.count)
    }
    
    private var averageSleepTime: (hours: Int, minutes: Int) {
        guard !lastWeekSessions.isEmpty else { return (0, 0) }
        
        let totalSeconds = lastWeekSessions.reduce(0.0) { total, session in
            total + session.sleepEnd.timeIntervalSince(session.sleepStart)
        }
        
        let averageSeconds = totalSeconds / Double(lastWeekSessions.count)
        let hours = Int(averageSeconds) / 3600
        let minutes = (Int(averageSeconds) % 3600) / 60
        return (hours, minutes)
    }
}

// MARK: - Компоненты

private struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ваш сон")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("За последние 7 дней")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

private struct MetricCard: View {
    let value: String
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

private struct SleepChartView: View {
    let sessions: [SleepSession]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("График сна")
                .font(.headline)
            
            if sessions.isEmpty {
                placeholderView
            } else {
                // Здесь можно добавить реальный график
                // Например, используя Charts framework
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [.indigo, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .overlay(
                        Text("График продолжительности сна")
                            .foregroundColor(.white)
                            .padding()
                    )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var placeholderView: some View {
        VStack {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("Недостаточно данных")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DailySleepView: View {
    let sessions: [SleepSession]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Детализация по дням")
                .font(.headline)
                .padding(.horizontal)
            
            if sessions.isEmpty {
                Text("Нет данных за последнюю неделю")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(sessions.prefix(7)) { session in
                    SleepDayRow(session: session)
                }
                .padding(.horizontal)
            }
        }
    }
}

private struct SleepDayRow: View {
    let session: SleepSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.subheadline)
                
                Text("\(session.duration.hours)ч \(session.duration.minutes)м")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                ForEach(1..<6) { index in
                    Image(systemName: index <= session.score ? "star.fill" : "star")
                        .foregroundColor(index <= session.score ? .yellow : .gray)
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: session.sleepStart)
    }
}

// MARK: - Превью

#Preview {
    AnalyticsView()
}

#Preview("With Data") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SleepSession.self, configurations: config)
    
    // Генерация тестовых данных
    for i in 0..<7 {
        let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
        let endDate = Calendar.current.date(
            byAdding: .hour, value: Int.random(in: 6...8),
            to: startDate
        )!
        
        let session = SleepSession(
            sleepStart: startDate,
            sleepEnd: endDate,
            score: Int.random(in: 1...5),
            information: i % 2 == 0 ? "Хороший сон" : nil
        )
        container.mainContext.insert(session)
    }
    
    return AnalyticsView()
        .modelContainer(container)
}
