import SwiftUI
import SwiftData

struct LastSleepView: View {
    
    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    var body: some View {
        NavigationStack{
            VStack{
                if let session = sessions.last {
                    Text("🛌 Длительность сна: \(session.duration.hours)ч \(session.duration.minutes)м")
                    Text("💤 Оценка сна: \(session.score)")
                    if let info = session.information {
                        Text("📝 \(info)")
                    }
                } else {
                    ProgressView("Загрузка...")
                }
            }
            .navigationTitle("Last Sleep Data")
        }
        
    }
}

#Preview {
    LastSleepView()
}

#Preview("Sleep data") {
    let sampleSession = SleepSession(
        sleepStart: Calendar.current.date(byAdding: .hour, value: -8, to: .now)!,
        sleepEnd: .now,
        score: 4,
        information: "Чувствовал себя отлично после сна"
    )
    
    let schema = Schema([SleepSession.self])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: schema, configurations: [configuration])
    
    modelContainer.mainContext.insert(sampleSession)
    
    return LastSleepView()
        .modelContainer(modelContainer)
}
