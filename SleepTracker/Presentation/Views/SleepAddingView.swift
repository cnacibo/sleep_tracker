import SwiftUI
import SwiftData

struct SleepAddingView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var sleepStart: Date = .now
    @State private var sleepEnd: Date = .now
    @State private var score: String = ""
    @State private var info: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    private var addSleepUseCase: AddSleepUseCase {
        let repository = SleepRepository(context: context)
        return AddSleepUseCase(repository: repository)
    }
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                Form {
                    DatePicker("Sleep Start", selection: $sleepStart)
                    DatePicker("Sleep End", selection: $sleepEnd)
                    TextField("Sleep Score", text: $score)
                        .keyboardType(.numberPad)
                    TextField("Additional information", text: $info)
                }
                
                Button("Save", systemImage: "square.and.arrow.down.fill", action: AddSession)
                    .padding(12)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                
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
            score = ""
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
