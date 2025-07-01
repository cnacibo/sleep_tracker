import SwiftUI
import SwiftData

struct ContentView: View {
    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]

    var body: some View {
        TabView {
            Tab("Add Sleep", systemImage: "plus.app"){
                SleepAddingView()
            }
            Tab("Home", systemImage: "bed.double.fill"){
                HomeView()
            }
            Tab("Analytics", systemImage: "chart.xyaxis.line"){
                AnalyticsView()
            }
        }
        .tint(.indigo)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SleepSession.self, inMemory: true)
}
