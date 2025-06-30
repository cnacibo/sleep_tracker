import SwiftUI
import SwiftData

struct LastSleepView: View {
    
    let session: SleepSession
    
    var body: some View {
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
        
    }
}


#Preview("With data") {

    
    let session = SleepSession(
        sleepStart: Calendar.current.date(byAdding: .hour, value: -8, to: .now)!,
        sleepEnd: .now,
        score: 4,
        information: "Felt refreshed after waking up"
    )
    return LastSleepView(session: session)
        .modelContainer(try! ModelContainer(for: SleepSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)))
}
