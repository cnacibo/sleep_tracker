import SwiftUI
import SwiftData

struct AnalyticsView: View {
    
    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    private let sleepAnalytics: SleepAnalyticsProtocol
    
    init(sleepAnalytics: SleepAnalyticsProtocol = SleepAnalyticsUseCase()) {
        self.sleepAnalytics = sleepAnalytics
    }
    
    
    private let primaryColor = Color.indigo
    private let secondaryColor = Color.teal
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Sleep dynamics")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("Last 7 days average")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    
                    HStack(spacing: 16) {
                        MetricCard(
                            value: "\(sleepAnalytics.averageScore(sessions: sessions))",
                            title: "Score",
                            icon: "star.fill",
                            color: primaryColor
                        )
                        
                        MetricCard(
                            value: "\(sleepAnalytics.averageSleepTime(sessions: sessions).hours)h \(sleepAnalytics.averageSleepTime(sessions: sessions).minutes)m",
                            title: "Sleep Time",
                            icon: "moon.zzz.fill",
                            color: secondaryColor
                        )
                    }
                    .padding(.horizontal)
                    
                    AppAnalytics(sleepAppScore: "\(sleepAnalytics.scoreFromApp(sessions: sessions))")
                        .padding(.horizontal)
                    
                    DailySleep(sessions: sleepAnalytics.lastWeekSessions(sessions: sessions))
                }
                .padding(.vertical)
            }
            .navigationTitle("Your Sleep Analytics")
            .background(Color(.systemGroupedBackground))
        }
    }
}

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
