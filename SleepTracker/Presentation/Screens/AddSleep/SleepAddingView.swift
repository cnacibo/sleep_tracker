import SwiftUI
import SwiftData

struct SleepAddingView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var sleepStart: Date = .now
    @State private var sleepEnd: Date = .now
    @State private var score: Int = 3
    @State private var info: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    private var addSleepUseCase: AddSleepUseCase {
        let repository = SleepRepository(context: context)
        return AddSleepUseCase(repository: repository)
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {Color("AccentColor")
                Form {
                    Section(header: Text("Sleep Time").font(.headline)) {
                        DatePicker("Start", selection: $sleepStart)
                        DatePicker("End", selection: $sleepEnd)
                    }
                    
                    Section(header: Text("Sleep Quality").font(.headline)) {
                        
                        HStack {
                            Text("Score")
                            Spacer()
                            Picker("Sleep Score", selection: $score){
                                ForEach(1...5, id: \.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 180)
                        }
                    }
                    
                    Section(header: Text("Notes").font(.headline)) {
                        TextField("Additional information", text: $info)
                    }
                    
                    Section {
                        Button(action: AddSession) {
                            HStack {
                                Spacer()
                                Label("Save", systemImage: "square.and.arrow.down.fill")
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.vertical, 17)
                            .background(LinearGradient(
                                colors: [.indigo.opacity(0.2), .teal.opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing))
                            .foregroundColor(.indigo)
                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .navigationTitle("New Sleep Session")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(alertMessage)
            }
            
        }
    }
    
    private func AddSession() {
        do {
            try addSleepUseCase.execute(
                startTime: sleepStart,
                endTime: sleepEnd,
                score: score,
                notes: info)
            sleepStart = .now
            sleepEnd = .now
            score = 3
            info = ""
            showAlert("Ваша запись успешно сохранена!", "")
        } catch SleepValidationError.invalidScoreFormat {
            showAlert("Ошибка", "Введите число от 1 до 5")
        } catch SleepValidationError.scoreOutOfRange {
            showAlert("Ошибка", "Оценка должна быть от 1 до 5")
        } catch SleepValidationError.invalidTimeRange {
            showAlert("Ошибка", "Время начала сна должно быть раньше окончания")
        } catch {
            showAlert("Ошибка", "Не удалось сохранить: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(_ title: String, _ message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    SleepAddingView()
}
