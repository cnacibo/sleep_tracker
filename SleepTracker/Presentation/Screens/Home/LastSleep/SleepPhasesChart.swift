import SwiftUI
import Charts

struct SleepPhasesChart: View {
    
    let phases: (deep: Int, rem: Int, awake: Int, light: Int)
    
    private var chartData: [SleepPhase] {
        [
            SleepPhase(type: .deep, duration: phases.deep),
            SleepPhase(type: .rem, duration: phases.rem),
            SleepPhase(type: .awake, duration: phases.awake),
            SleepPhase(type: .light, duration: phases.light),
        ]
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sleep Phases")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)
            
            Chart {
                ForEach(chartData) { phase in
                    BarMark (
                        x: .value("Duration", phase.duration),
                        y: .value("Phase", phase.type.rawValue)
                    )
                    .foregroundStyle(by: .value("Phase", phase.type.rawValue))
                    .annotation(position: .trailing) {
                        Text("\(phase.duration) min")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            .chartForegroundStyleScale([
                "Deep": .purple,
                "Light": .blue,
                "REM": .mint,
                "Awake": .orange,
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

#Preview {
    SleepPhasesChart(phases: (deep: 120, rem: 90, awake: 30, light: 180))
}
