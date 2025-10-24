import SwiftUI

struct CustomCalenderView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @State private var selectedDate: Date? = nil // The date user last tapped on (for showing overview box)
    @EnvironmentObject var tracker: GoalTracker //true if goal completed, var tracks the streak days
    @State private var displayedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var displayedYear: Int = Calendar.current.component(.year, from: Date())
    // Currently displayed month and year in the calendar

    
    private let calendar = Calendar.current     // Calendar object for date calculations
    private var currentMonthDates: [Date] {
        var comps = DateComponents()
        comps.year = displayedYear
        comps.month = displayedMonth
        comps.day = 1
        // Computed property: builds an array of all the dates in the displayed month

        guard let startOfMonth = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return [] }   // Find the first day of the month and the number of days in that month

        
        return range.compactMap { day in // Generate a Date for each day in the month
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) else { return nil }// Normalize each date to start of day (no time)
            return calendar.startOfDay(for: date)
        }
    }
    
    private func monthName(_ month: Int) -> String {  // Helper to turn month number into its name like  1 → January

        let formatter = DateFormatter()
        return formatter.monthSymbols[month - 1]
    }
    
    private func previousMonth() {    // Go back one month
        if displayedMonth == 1 {
            displayedMonth = 12
            displayedYear -= 1
        } else {
            displayedMonth -= 1
        }
    }
    
    private func nextMonth() {     // Go forward one month
        if displayedMonth == 12 {
            displayedMonth = 1
            displayedYear += 1
        } else {
            displayedMonth += 1
        }
    }
    
    private var dateFormatter: DateFormatter {  // Formatter to display selected date nicely like Sep 22, 2025

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    // 🔥 Current streak calculation
    private func currentStreak() -> Int {
        let completedDays = tracker.streakDays.keys
            .filter { tracker.streakDays[$0] == true }
            .sorted(by: <) // ascending
        
        guard !completedDays.isEmpty else { return 0 }
        
        var streak = 0
        var prevDate: Date? = nil
        
        for day in completedDays.reversed() { // start from latest
            if prevDate == nil {
                let today = calendar.startOfDay(for: Date())
                if calendar.isDate(day, inSameDayAs: today) ||
                    calendar.isDate(day, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today)!) {
                    streak = 1
                    prevDate = day
                } else {
                    break
                }
            } else if let prev = prevDate,
                      let expected = calendar.date(byAdding: .day, value: -1, to: prev),
                      calendar.isDate(day, inSameDayAs: expected) {
                streak += 1
                prevDate = day
            } else {
                break
            }
        }
        
        return streak
    }
    
    // 🔥 Longest streak calculation
    private func longestStreak() -> Int {
        let completedDays = tracker.streakDays.keys
            .filter { tracker.streakDays[$0] == true }
            .sorted()
        
        var longest = 0
        var current = 0
        var prevDate: Date? = nil
        
        for day in completedDays {
            if let prev = prevDate,
               let next = calendar.date(byAdding: .day, value: 1, to: prev),
               calendar.isDate(day, inSameDayAs: next) {
                current += 1
            } else {
                current = 1
            }
            longest = max(longest, current)
            prevDate = day
        }
        
        return longest
    }
    
    var body: some View {
        VStack {
           Text("UnScroll").font(.largeTitle).bold().foregroundStyle(.white)
//            Button("Reset Onboarding") {
//                hasCompletedOnboarding = false
//            }
//            .font(.headline)
//            .padding()
//            .background(Color.white)
//            .foregroundColor(.cyan)
//            .cornerRadius(10)
            
            // Month Navigation
            Spacer().frame(height: 50)
            HStack {
                Button(action: previousMonth) { Image(systemName: "chevron.left").foregroundColor(.white) }
                Spacer()
                Text("\(monthName(displayedMonth)) \(displayedYear)")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: nextMonth) { Image(systemName: "chevron.right").foregroundColor(.white) }
            }
            .padding(.horizontal)
            
            // MARK: Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {      // Loop over every date in the displayed month

                ForEach(currentMonthDates, id: \.self) { date in
                    let day = calendar.component(.day, from: date)
                    let today = calendar.startOfDay(for: Date())
                    let isFuture = date > today
                    
                    let color: Color = tracker.isCompleted(on: date) ? .green :
                                       calendar.isDate(date, inSameDayAs: today) ? Color.gray.opacity(0.6) :
                                       Color.gray.opacity(0.3) // Decide circle color for each day:
                    // green if streak achieved
                    // darker gray if today
                    // lighter gray otherwise
                    
                    Text("\(day)")
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(color))
                        .foregroundColor(.white)
                        .opacity(isFuture ? 0.3 : 1.0)
                        .onTapGesture {
                            if !isFuture { selectedDate = date } // single tap shows overview
                        }
//                        .simultaneousGesture(
//                            TapGesture(count: 2).onEnded {
//                                if !isFuture { tracker.streakDays[date] = true } // double tap marks streak
//                            }
//                        )
                }
            }
            .padding()
            
            // MARK: Overview Box (Outside Grid)
            if let selected = selectedDate {
                VStack {
                    Text("Date: \(selected, formatter: dateFormatter)")
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.5)))
                .animation(.easeInOut, value: selectedDate)
            }
            
            Spacer()
            
            HStack { // puts Current Streak on the left, Longest Streak on the right
                VStack(alignment: .leading) {
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(currentStreak()) 🔥")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom) // makes text that gradient color
                        )
                }
                
                Spacer() // pushes longest streak apart so the box/backgorund can go across whole screen and look cleaner
                VStack(alignment: .trailing) {
                               Text("Longest Streak")
                                   .font(.caption)
                                   .foregroundColor(.white.opacity(0.7))
                               Text("\(longestStreak()) days")
                                   .font(.title2)
                                   .foregroundStyle(
                                       LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                                   )
                           }
                
                
                
            }.padding().background( //this is the box that goes around the two to connect them
                RoundedRectangle(cornerRadius: 16)  .fill(
                    LinearGradient(colors: [Color.blue.opacity(0.4),
                                            Color.purple.opacity(0.6)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
        )

            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cyan) // light blue background
    }
}

#Preview {
    let tracker = GoalTracker()
    tracker.markGoalCompleted(on: Date())
    return CustomCalenderView().environmentObject(tracker)
}
