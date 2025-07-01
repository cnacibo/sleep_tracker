import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if let session = sessions.first {
                        
                        LastSleepView(session: session)
                        
                        LastWeekView(sessions: sessions)
                        
                    } else {
                        EmptySleep()
                    }
                }
                
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Home page")
        }
        
    }
}


#Preview {
    HomeView()
}

#Preview("With Data") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SleepSession.self, configurations: config)
    
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
            container.mainContext.insert(session2)
        }
        
        container.mainContext.insert(session1)
    }

    
    return HomeView()
        .modelContainer(container)
}
