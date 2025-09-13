import SwiftUI
import FamilyControls
import DeviceActivity

enum GoalStatus {
    case notChecked
    case achieved
    case failed
}

struct GoalItem: Identifiable {
    let id = UUID()
    var appName: String
    var limit: String
    var completedDays: Set<Int> = []
    var status: GoalStatus = .notChecked
    
    var text: String {
        "I want to limit \(appName) for \(limit) this week."
    }
}

struct Feedback: Codable {
    var appName: String
    var limit: String
}

class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()
    
    @Published var usageByApp: [String: TimeInterval] = [:] // seconds per app
    
    private init() {}
    
    // Request authorization (will be used in onboarding)
    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                print("✅ Screen time authorization granted")
            } catch {
                print("❌ Failed to get authorization: \(error)")
            }
        }
    }
    
    // Placeholder until onboarding is built
    var selectedApps: FamilyActivitySelection = FamilyActivitySelection()
    
    // Simulated fetch (replace later with DeviceActivityReport)
    func fetchUsageForToday() {
        usageByApp = [
            "Instagram": Double(25 * 60), // 25 min
            "TikTok": Double(45 * 60)     // 45 min
        ]
    }
}

struct GoalsPageView: View {
    @State private var allGoals: [GoalItem] = []
    @State private var selectedApp = "Instagram"
    @State private var selectedLimit = "30 mins"
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    
    let apps = ["Instagram", "TikTok", "YouTube", "Snapchat", "Twitter"]
    let limits = ["15 mins", "30 mins", "1 hr", "2 hrs"]
    let daysToShow = 7
    
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
                                
                                Text("this week")
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
                                submitSendGoalItem()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(allGoals.count < 3 && !allGoals.contains(where: { $0.appName == selectedApp }) ? .green.opacity(0.7) : .gray)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .disabled(allGoals.count >= 3 || allGoals.contains(where: { $0.appName == selectedApp }))
                            
                            Button("Check Screen Time") {
                                screenTimeManager.fetchUsageForToday()
                                checkGoals()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(12)
                        }
                        
                        if allGoals.isEmpty {
                            Text("No goals yet.")
                                .font(.custom("Futura", size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        } else {
                            ForEach($allGoals) { $goal in
                                GoalRowView(goal: $goal, daysToShow: daysToShow) {
                                    if let index = allGoals.firstIndex(where: { $0.id == goal.id }) {
                                        allGoals.remove(at: index)
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
    
    func checkGoals() {
        for i in allGoals.indices {
            let limitSeconds = parseLimit(allGoals[i].limit)
            let usageSeconds = screenTimeManager.usageByApp[allGoals[i].appName] ?? 0
            
            if usageSeconds <= limitSeconds {
                allGoals[i].status = .achieved
            } else {
                allGoals[i].status = .failed
            }
        }
    }
    
    func parseLimit(_ limit: String) -> TimeInterval {
        if limit.contains("15") { return 15.0 * 60.0 }
        if limit.contains("30") { return 30.0 * 60.0 }
        if limit.contains("1 hr") || limit.contains("1 hrs") { return 60.0 * 60.0 }
        if limit.contains("2 hrs") { return 2.0 * 60.0 * 60.0 }
        return 0
    }
    
    func submitSendGoalItem() {
        let feedbackData = Feedback(appName: selectedApp, limit: selectedLimit)
        postFeedback(feedback: feedbackData)
    }
}

struct GoalRowView: View {
    @Binding var goal: GoalItem
    let daysToShow: Int
    var removeAction: () -> Void
    
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
                }
                .font(.system(size: 12))
                .padding(6)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Button("X") {
                    removeAction()
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

extension GoalsPageView {
    func postFeedback(feedback: Feedback) {
        guard let url = URL(string: "mongodb+srv://montgomerycoderschool:theCatOnTheCOMPUTERRR@cluster0.b9stmdy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0&ssl=true") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // TODO: Encode feedback and send with URLSession
    }
}

#Preview {
    GoalsPageView()
}
