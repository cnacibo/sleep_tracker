import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Add Sleep", systemImage: "plus.app"){
                SleepAddingView()
            }
            Tab("Last Sleep", systemImage: "bed.double.fill"){
                LastSleepView()
            }
            Tab("Analitics", systemImage: "chart.xyaxis.line"){
                AnaliticsView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SleepSession.self, inMemory: true)
}
