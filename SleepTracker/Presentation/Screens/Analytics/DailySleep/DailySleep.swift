import SwiftUI

struct DailySleep: View {
    let sessions: [SleepSession]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Days")
                .font(.headline)
                .padding(.horizontal)
            
            if sessions.isEmpty {
                placeholderView
            } else {
                ForEach(sessions.prefix(7)) { session in
                    SleepDayRow(session: session)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var placeholderView: some View {
          VStack {
              Image(systemName: "chart.line.downtrend.xyaxis")
                  .font(.system(size: 40))
                  .foregroundColor(.secondary)
              Text("No data")
                  .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity)
      }
}
