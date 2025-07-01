import SwiftUI

struct SleepDayRow: View {
    let session: SleepSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.subheadline)
                
                Text("\(session.duration.hours)h \(session.duration.minutes)m")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                ForEach(1..<6) { index in
                    Image(systemName: index <= session.score ? "star.fill" : "star")
                        .foregroundColor(index <= session.score ? .yellow : .gray)
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: session.sleepStart)
    }
}
