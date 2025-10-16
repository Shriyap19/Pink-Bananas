import SwiftUI

enum GoalStatus: String, Codable {
    case notChecked
    case achieved
    case failed
}

struct GoalItem: Identifiable, Codable {
    let id: UUID
    var appName: String
    var limit: String
    var completedDays: Set<Int> = []
    var status: GoalStatus = .notChecked
    
    init(id: UUID = UUID(), appName: String, limit: String, completedDays: Set<Int> = [], status: GoalStatus = .notChecked) {
        self.id = id
        self.appName = appName
        self.limit = limit
        self.completedDays = completedDays
        self.status = status
    }

    var text: String {
        "I want to limit \(appName) for \(limit) a day."
    }
}

struct Feedback: Codable {
    var appName: String
    var limit: String
}

struct GoalsPageView: View {

    @AppStorage("allGoalsData") private var allGoalsData: Data = Data()

    @State private var allGoals: [GoalItem] = []
    @State private var selectedApp = "Instagram"
    @State private var selectedLimit = "30 mins"
    
    let apps = ["Instagram", "TikTok", "YouTube", "Snapchat", "Twitter"]
    let limits = ["15 mins", "30 mins", "1 hr", "2 hrs"]
    let daysToShow = 7

    func loadGoals() {
        if let decoded = try? JSONDecoder().decode([GoalItem].self, from: allGoalsData) {
            allGoals = decoded
        }
    }

    func saveGoals() {
        if let encoded = try? JSONEncoder().encode(allGoals) {
            allGoalsData = encoded
        }
    }

    func parseLimit(_ limit: String) -> TimeInterval {
        if limit.contains("15") { return 15.0 * 60.0 }
        if limit.contains("30") { return 30.0 * 60.0 }
        if limit.contains("1 hr") || limit.contains("1 hrs") { return 60.0 * 60.0 }
        if limit.contains("2 hrs") { return 2.0 * 60.0 * 60.0 }
        return 0
    }
    
  // func submitSendGoalItem() {
    //    let feedbackData = Feedback(appName: selectedApp, limit: selectedLimit)
        //postFeedback(feedback: feedbackData)
  //  }
    
    var body: some View {
        ZStack {
            Color.cyan
                .ignoresSafeArea()
            
            ScrollViewReader { _ in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Goal Page")
                            .font(.custom("Futura", size: 32))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .padding(.top)
                            .id("top")
                        
                        VStack(spacing: 10) {
                            HStack(spacing: 0) {
                                Text("I want to limit ")
                                    .font(.custom("Futura", size: 18))
                                    .foregroundStyle(.white)
                                
                                Picker("", selection: $selectedApp) {
                                    ForEach(apps, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 120)
                                .clipped()
                                .padding(6)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                
                                Text("for ")
                                    .font(.custom("Futura", size: 18))
                                    .foregroundStyle(.white)
                                
                                Picker("", selection: $selectedLimit) {
                                    ForEach(limits, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 100)
                                .clipped()
                                .padding(6)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                
                                Text("a day")
                                    .font(.custom("Futura", size: 18))
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            
                            Button("Save Goal") {
                                let isAppAlreadyUsed = allGoals.contains { $0.appName == selectedApp }
                                guard !isAppAlreadyUsed, allGoals.count < 3 else { return }
                                
                                let newGoal = GoalItem(appName: selectedApp, limit: selectedLimit)
                                allGoals.insert(newGoal, at: 0)
                                saveGoals()
                            //    submitSendGoalItem()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(allGoals.count < 3 && !allGoals.contains(where: { $0.appName == selectedApp }) ? .green.opacity(0.7) : .gray)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .disabled(allGoals.count >= 3 || allGoals.contains(where: { $0.appName == selectedApp }))
                            
                            if allGoals.isEmpty {
                                Text("No goals yet.")
                                    .font(.custom("Futura", size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                            } else {
                                ForEach($allGoals) { $goal in
                                    GoalRowView(goal: $goal, daysToShow: daysToShow, removeAction: saveGoals) {
                                        if let index = allGoals.firstIndex(where: { $0.id == goal.id }) {
                                            allGoals.remove(at: index)
                                            saveGoals()
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Previous Goals")
                                        .font(.custom("Futura", size: 20))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    if !allGoals.isEmpty {
                                        Button("Delete All Goals") {
                                            allGoals.removeAll()
                                            saveGoals()
                                        }
                                        .font(.system(size: 14))
                                        .padding(8)
                                        .background(Color.red.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                                
                                if allGoals.isEmpty {
                                    Text("No previous goals.")
                                        .font(.custom("Futura", size: 14))
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                } else {
                                    ForEach(allGoals) { goal in
                                        Text("• \(goal.text)")
                                            .font(.custom("Futura", size: 16))
                                            .padding(.horizontal)
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .padding(.top)
                            
                            Spacer().frame(height: 40)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadGoals()
        }
    }
    
    struct GoalRowView: View {
        @Binding var goal: GoalItem
        let daysToShow: Int
        var removeAction: () -> Void
        var saveAction: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(goal.text)
                        .font(.custom("Futura", size: 16))
                        .foregroundStyle(.blue)
                    
                    if goal.status == .achieved {
                        Text("✅")
                    } else if goal.status == .failed {
                        Text("❌")
                    }
                    
                    Spacer()
                    Button("Reset") {
                        goal.completedDays.removeAll()
                        goal.status = .notChecked
                        saveAction()
                    }
                    .font(.system(size: 12))
                    .padding(6)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    Button("X") {
                        removeAction()
                        saveAction()
                    }
                    .font(.system(size: 14, weight: .bold))
                    .frame(width: 28, height: 28)
                    .background(Color.red.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
                
                HStack(spacing: 12) {
                    ForEach(0..<daysToShow, id: \.self) { i in
                        Circle()
                            .fill(goal.completedDays.contains(i) ? .cyan : .cyan.opacity(0.3))
                            .frame(width: 28, height: 28)
                            .onTapGesture {
                                if goal.completedDays.contains(i) {
                                    goal.completedDays.remove(i)
                                } else {
                                    goal.completedDays.insert(i)
                                }
                                saveAction()
                            }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

extension GoalsPageView {
    func postFeedback(feedback: Feedback) {
        guard let url = URL(string: "mongodb+srv://montgomerycoderschool:theCatOnTheCOMPUTERRR@cluster0.b9stmdy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0&ssl=true") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

#Preview {
    GoalsPageView()
}

