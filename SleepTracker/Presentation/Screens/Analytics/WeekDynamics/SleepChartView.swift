import SwiftUI
import SwiftData

struct AppAnalytics: View {
    let sleepAppScore: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Analytics from SleepTracker")
                .font(.headline)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    colors: [.indigo.opacity(0.2), .teal.opacity(0.2)],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("\(sleepAppScore)")
                                .font(.largeTitle.bold())
                                .foregroundColor(.indigo)
                            Text("- score from app")
                                .font(.title2)
                        }
                        .padding(15)
                        
                        Text("You can upgrade your score by going to bed before 11 pm and sleeping 8-10 hours a day")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                    }
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .frame(height: 200)
    }
}

#Preview("With data") {
    var sleepAppScore: String = "2.4"
    return AppAnalytics(sleepAppScore: sleepAppScore)
        .modelContainer(try! ModelContainer(for: SleepSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)))
}


