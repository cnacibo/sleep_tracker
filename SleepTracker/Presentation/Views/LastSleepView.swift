import SwiftUI
import SwiftData

struct LastSleepView: View {
    
    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let session = sessions.last {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack(alignment: .top) {
                            Image(systemName: "bed.double.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Sleep time")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                Text("\(session.duration.hours)ч \(session.duration.minutes)м")
                                    .font(.body)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Rating")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                Text(String(repeating: "⭐️", count: session.score))
                                    .font(.body)
                            }
                        }
                        if let info = session.information, !info.isEmpty {
                            HStack(alignment: .top) {
                                Image(systemName: "note.text")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                VStack(alignment: .leading) {
                                    Text("Notes")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                    Text(info)
                                        .font(.body)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(30)
                    
                } else {
                    VStack {
                        Image(systemName: "moon.zzz")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No sleep data")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Add your first sleep data")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
            }
            .navigationTitle("Last Sleep")
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
