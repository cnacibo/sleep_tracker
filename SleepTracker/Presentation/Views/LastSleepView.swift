import SwiftUI
import SwiftData
import Charts // Не забудьте добавить Charts framework в проект

struct LastSleepView: View {
    
    @Query(sort: \SleepSession.sleepStart, order: .reverse)
    private var sessions: [SleepSession]
    
    // Моковые данные для фаз сна (замените на реальные)
    private var sleepPhases: [SleepPhase] {
        [
            SleepPhase(type: .deep, duration: 120),
            SleepPhase(type: .light, duration: 180),
            SleepPhase(type: .rem, duration: 90),
            SleepPhase(type: .awake, duration: 30)
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if let session = sessions.last {
                        // Карточка с основной информацией
                        VStack(alignment: .leading, spacing: 20) {
                            // Заголовок с датой
                            HStack {
                                Image(systemName: "moon.zzz.fill")
                                    .foregroundColor(.indigo)
                                Text("Last Sleep")
                                    .font(.title2.bold())
                                Spacer()
                                Text(session.sleepStart, style: .date)
                                    .foregroundColor(.secondary)
                            }
                            
                            // График фаз сна
                            SleepPhasesChart(phases: sleepPhases)
                                .frame(height: 200)
                                .padding(.vertical, 10)
                            
                            // Детали сна
                            VStack(spacing: 16) {
                                SleepMetricRow(
                                    icon: "bed.double.fill",
                                    title: "Sleep Duration",
                                    value: "\(session.duration.hours)h \(session.duration.minutes)m",
                                    color: .blue
                                )
                                
                                SleepMetricRow(
                                    icon: "star.fill",
                                    title: "Sleep Quality",
                                    value: String(repeating: "★", count: session.score),
                                    color: .yellow
                                )
                                
                                if let info = session.information, !info.isEmpty {
                                    SleepMetricRow(
                                        icon: "note.text",
                                        title: "Notes",
                                        value: info,
                                        color: .green
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding()
                        
                        // Анализ сна
                        SleepAnalysisView(phases: sleepPhases)
                            .padding(.horizontal)
                        
                    } else {
                        EmptySleepView()
                    }
                }
            }
            .navigationTitle("Sleep Analysis")
            .background(Color(.systemGroupedBackground))
        }
        
    }
}

// MARK: - Компоненты

private struct SleepPhasesChart: View {
    let phases: [SleepPhase]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sleep Phases")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)
            
            Chart {
                ForEach(phases) { phase in
                    BarMark(
                        x: .value("Duration", phase.duration),
                        y: .value("Phase", phase.type.rawValue)
                    )
                    .foregroundStyle(by: .value("Phase", phase.type.rawValue))
                    .annotation(position: .trailing) {
                        Text("\(phase.duration / 60) min")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .chartForegroundStyleScale([
                "Deep": .purple,
                "Light": .blue,
                "REM": .mint,
                "Awake": .orange
            ])
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
            .frame(height: 150)
        }
    }
}

private struct SleepMetricRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
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

private struct SleepAnalysisView: View {
    let phases: [SleepPhase]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sleep Analysis")
                .font(.headline)
            
            ForEach(phases) { phase in
                HStack {
                    Circle()
                        .fill(phase.type.color)
                        .frame(width: 12, height: 12)
                    
                    Text(phase.type.rawValue)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(phase.duration / 60) min")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

private struct EmptySleepView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "moon.zzz")
                .font(.system(size: 64))
                .foregroundColor(.indigo.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No Sleep Data")
                    .font(.title3.bold())
                
                Text("Add your first sleep record to see detailed analysis")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        Color(.systemGroupedBackground)
            .edgesIgnoringSafeArea(.all)
    }
        
}

// MARK: - Модели данных

struct SleepPhase: Identifiable {
    let id = UUID()
    let type: SleepPhaseType
    let duration: Int // в минутах
}

enum SleepPhaseType: String {
    case deep = "Deep"
    case light = "Light"
    case rem = "REM"
    case awake = "Awake"
    
    var color: Color {
        switch self {
        case .deep: return .purple
        case .light: return .blue
        case .rem: return .mint
        case .awake: return .orange
        }
    }
}

// MARK: - Превью

#Preview {
    LastSleepView()
}

#Preview("With Data") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SleepSession.self, configurations: config)
    
    let session = SleepSession(
        sleepStart: Calendar.current.date(byAdding: .hour, value: -8, to: .now)!,
        sleepEnd: .now,
        score: 4,
        information: "Felt refreshed after waking up"
    )
    
    container.mainContext.insert(session)
    
    return LastSleepView()
        .modelContainer(container)
}
