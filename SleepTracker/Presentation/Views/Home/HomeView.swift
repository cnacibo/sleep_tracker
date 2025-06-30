import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    private var lastWeekDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // Формат "Месяц День" (например: "Jun 15 - Jun 21")
        
        guard let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()),
              let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            return ""
        }
        
        let startDate = formatter.string(from: weekAgo)
        let endDate = formatter.string(from: yesterday)
        
        return "\(startDate) - \(endDate)"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if let session = sessions.first {
                        VStack() {
                            HStack {
                                Image(systemName: "moon.zzz.fill")
                                    .foregroundColor(.indigo)
                                Text("Last Sleep")
                                    .font(.title2.bold())
                                
                                Text(session.sleepStart, style: .date)
                                    .foregroundColor(.secondary)
                            }
                            SleepPhasesChart(phases: session.phases)
                                .frame(height: 200)
                                .padding(.vertical, 10)
                            
                            Divider()
                            
                            VStack(spacing: 15) {
                                SleepMetric(
                                    icon: "bed.double.fill",
                                    title: "Sleep Duration",
                                    value: "\(session.duration.hours)h \(session.duration.minutes)m",
                                    color: .blue
                                )
                                
                                SleepMetric(
                                    icon: "star.fill",
                                    title: "Sleep Quality",
                                    value: String(repeating: "★", count: session.score),
                                    color: .yellow
                                )
                                
                                if let info = session.information, !info.isEmpty {
                                    SleepMetric(
                                        icon: "note.text",
                                        title: "Notes",
                                        value: info,
                                        color: .green
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding()
                        
                        VStack {
                            HStack {
                                Image(systemName: "chart.bar.xaxis")
                                    .foregroundColor(.indigo)
                                Text("Last Week")
                                    .font(.title2.bold())
                                Text(lastWeekDateRange)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding()
                        
                    } else {
                        EmptySleep()
                    }
                }
                
            }
            .background(Color(.systemGroupedBackground))
        }
        
    }
}


#Preview {
    HomeView()
}

#Preview("With Data") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SleepSession.self, configurations: config)
    
    let session = SleepSession(
        sleepStart: Calendar.current.date(byAdding: .hour, value: -8, to: .now)!,
        sleepEnd: .now,
        score: 4,
        information: "Felt refreshed after waking up"
    )
    
    container.mainContext.insert(session)
    
    return HomeView()
        .modelContainer(container)
}
