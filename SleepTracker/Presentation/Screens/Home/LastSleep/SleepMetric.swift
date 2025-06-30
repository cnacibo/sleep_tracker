import SwiftUI

struct SleepMetric: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24, alignment: .center)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SleepMetric(
        icon: "bed.double.fill",
        title: "Sleep Duration",
        value: "5h 4m",
        color: .green
    )
}
