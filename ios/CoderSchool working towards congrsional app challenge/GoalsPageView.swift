import SwiftUI

struct GoalItem: Identifiable {
    let id = UUID()
    var text: String
    var completedDays: Set<Int> = []
}

struct GoalsPageView: View {
    @State private var allGoals: [GoalItem] = []
    @State private var selectedApp = "Instagram"
    @State private var selectedLimit = "30 mins"
    let apps = ["Instagram", "TikTok", "YouTube", "Snapchat", "Twitter"]
    let limits = ["15 mins", "30 mins", "1 hrs", "2 hrs"]
    let daysToShow = 7
    
    var body: some View {
        ZStack{
            Color.cyan
               .ignoresSafeArea()
            
            ScrollViewReader { proxy in
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
                                guard allGoals.count < 3 else { return }
                                let goalSentence = "I want to limit \(selectedApp) for \(selectedLimit) this week."
                                allGoals.insert(GoalItem(text: goalSentence), at: 0)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(allGoals.count < 3 ? .green.opacity(0.7) : .gray)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .disabled(allGoals.count >= 3)
                        }
                        
                        if allGoals.isEmpty {
                            Text("No goals yet.")
                                .font(.custom("Futura", size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        } else {
                            ForEach($allGoals) { $goal in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(goal.text)
                                            .font(.custom("Futura", size: 16))
                                            .foregroundStyle(.blue)
                                        Spacer()
                                        Button("Reset") {
                                            goal.completedDays.removeAll()
                                        }
                                        .font(.system(size: 12))
                                        .padding(6)
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        
                                        Button("X") {
                                            if let index = allGoals.firstIndex(where: { $0.id == goal.id }) {
                                                allGoals.remove(at: index)
                                            }
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
}

#Preview {
    GoalsPageView()
}
