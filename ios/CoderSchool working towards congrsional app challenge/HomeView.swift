//
//  ContentView.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 5/24/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedDate: Date? = nil
    @State private var streakDays: [Date: Bool] = [:] // if true then streak is achived
    @State private var displayedMonth: Int = Calendar.current.component(.month, from: Date()) // js using informstion to get current dat and also noting the compoents including month then the next one is the year
    @State private var displayedYear: Int = Calendar.current.component(.year, from: Date())
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    private let calendar = Calendar.current // let cant be changed afte being declared, var can
    private var currentMonthDates: [Date] {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = displayedYear
        comps.month = displayedMonth
        comps.day = 1
        guard let startOfMonth = calendar.date(from: comps), // what does guard mean?
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return [] }
        
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    func previousMonth() {
        if displayedMonth == 1 {
            displayedMonth = 12
            displayedYear -= 1
        } else {
            displayedMonth -= 1
        }
    }

    func nextMonth() {
        if displayedMonth == 12 {
            displayedMonth = 1
            displayedYear += 1
        } else {
            displayedMonth += 1
        }
    }

    func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[month - 1]
    }


    var body: some View {
        VStack {
            Text("Screen Time Tracker")
                .font(.title)
                .padding()
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("\(monthName(displayedMonth)) \(displayedYear)")
                    .font(.headline)
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(currentMonthDates, id: \.self) { date in
                    let day = calendar.component(.day, from: date)
                    let today = Date()
                    let isToday = calendar.isDate(date, inSameDayAs: today)
                    let isFuture = date > Date()
                    
                    let color: Color = streakDays[date] == true ? .green :
                                       isToday ? Color.gray.opacity(0.6) :
                                       Color.gray.opacity(0.3)
                    

                    
                    
                    Text("\(day)")
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(color))
                        .opacity(isFuture ? 0.3 : 1.0)
                        .simultaneousGesture(
                                TapGesture(count: 2)
                                    .onEnded {
                                        if !isFuture {
                                            streakDays[date] = true  // double-tap marks streak green
                                        }
                                    }
                            )
                            .onTapGesture {
                                if !isFuture {
                                    selectedDate = date  // single-tap shows box
                                }
                            }


                
                    
                    
                }
                
            }
            .padding()
            
            if let selected = selectedDate {
                    VStack {
                        Text("Overview for \(selected, formatter: dateFormatter)")
                        Text("Screen time: 3h 25m")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                }
            
            
            
        }.onAppear {
            let calendar = Calendar.current
            let today = Date()
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
                streakDays[yesterday] = true
            }
            streakDays[today] = true
        }

        

    }
}


    
    

#Preview {
    HomeView()
}
