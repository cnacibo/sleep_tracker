import SwiftUI

struct EmptySleep: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "moon.zzz")
                .font(.system(size: 64))
                .foregroundColor(.indigo.opacity(0.7))
            
            VStack {
                Text("No Sleep Data")
                    .font(.title3.bold())
                Text("Add your first sleep record")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
        }
        .padding(40)
        Color(.systemGroupedBackground)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    EmptySleep()
}
