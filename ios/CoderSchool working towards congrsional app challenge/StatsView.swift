//
//  StatsView.view.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 7/22/25.


import SwiftUI
import Charts
import FamilyControls
import DeviceActivity
import ManagedSettings

struct AppData: Identifiable {
    let id = UUID()
    let category: String
    let value: Int
    let color: Color
}
    
//class UsageFetcher: ObservableObject {
//    @Published var categoryUsage: [String: TimeInterval] = [:]
//    private let center = DeviceActivityCenter()
//    
//    func fetchUsage(for timeframe: String) async {
//        let calendar = Calendar.current
//        let now = Date()
//        var startDate: Date
//      
//        switch timeframe {
//        case "Today":
//            startDate = calendar.startOfDay(for: now)
//        case "Week":
//            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
//        case "Month":
//            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
//        case "All-Time":
//            startDate = Date.distantPast
//        default:
//            startDate = .distantPast
//        }
//        
//        let startComponents = calendar.dateComponents(
//            [.year, .month, .day, .hour, .minute, .second],
//            from: startDate
//        )
//
//        let endComponents = calendar.dateComponents(
//            [.year, .month, .day, .hour, .minute, .second],
//            from: now
//        )
//        
//        let schedule = DeviceActivitySchedule(
//            intervalStart: startComponents,
//            intervalEnd: endComponents,
//            repeats: false
//    
//    }
//}

func categoryForGenre(_ genre: String) -> String {
    switch genre {
    case "Health & Fitness":
        return "Other"
        
    case "Education":
        return "Social"
        
    case "Information & Reading":
        return "Other"
        
    case "Productivity & Finance":
        return "Other"
        
    case "Shopping & Food":
        return "Social"
        
    case "Travel":
        return "Social"
        
    case "Utilities":
        return "Other"
        
    case "Social":
        return "Social"
        
    case "Games":
        return "Gaming"
        
    case "Entertainment":
        return "Entertainment"
        
    case "Creativity":
        return "Other"
        
    default: return "Other"
    }
}

func formatTime(_ interval: TimeInterval) -> String {
    let hours = Int(interval)/3600
    let minutes = (Int(interval)) % 3600 / 60
    return "\(hours)h \(minutes)m"
}


struct StatsView: View {
   // @StateObject private var fetcher = UsageFetcher()
    @State private var selectedTimeframe: String = "Today"
    let timeframes = ["Today", "Week", "Month", "All-Time"]
    
    var piechartdata: [AppData] {
        switch selectedTimeframe {
        case "Today":
            return [
                AppData(category: "Entertainment", value: 67, color: .blue),
                AppData(category: "Gaming", value: 30, color: .green),
                AppData(category: "Social", value: 27, color: .red),
                AppData(category: "Other", value: 16, color: .yellow)
            ]
        case "Week":
            return [
                AppData(category: "Entertainment", value: 140, color: .blue),
                AppData(category: "Gaming", value: 65, color: .green),
                AppData(category: "Social", value: 125, color: .red),
                AppData(category: "Other", value: 130, color: .yellow)
            ]
        case "Month":
            return [
                AppData(category: "Entertainment", value: 250, color: .blue),
                AppData(category: "Gaming", value: 130, color: .green),
                AppData(category: "Social", value: 308, color: .red),
                AppData(category: "Other", value: 254, color: .yellow)
            ]
        case "All-Time":
            return [
                AppData(category: "Entertainment", value: 550, color: .blue),
                AppData(category: "Gaming", value: 320, color: .green),
                AppData(category: "Social", value: 790, color: .red),
                AppData(category: "Other", value: 830, color: .yellow)
            ]
        default:
            return []
        }
    }
    
    func hoursMinutes(from totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    
    var body: some View {
        
        ZStack {
            
            Color.cyan.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    
                    Text("Statistics")
                        .font(.custom("Futura", size: 40))
                        .foregroundColor(Color(.white))
                        .padding(.vertical, 2)
                }
                
                HStack(spacing: 7) {
                    ForEach(["Today", "Week", "Month", "All-Time"], id: \.self) { timeframe in
                        Button {
                            withAnimation {
                                selectedTimeframe = timeframe
                            }
                        } label: {
                            Text(timeframe)
                                .font(.custom("Futura", size: 16))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                            
                                .background(selectedTimeframe == timeframe ? Color.blue : Color.blue.opacity(0.2))
                                .foregroundColor(selectedTimeframe == timeframe ? .white : .white)
                                .cornerRadius(10)
                            
                        }
                    }
                }
                .padding(.vertical,7)
                
                
                VStack(spacing: 20) {
                    ForEach(piechartdata) { data in
                        let hours = data.value / 60
                        let minutes = data.value % 60
                        HStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(data.color)
                                    .frame(width: 70, height: 70)
                                Image(systemName: iconName(for: data.category))
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            Text("\(hours) hours and \(minutes) minutes on \(data.category.lowercased()) apps.")
                                .font(.custom("Futura", size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    
                }
                
                
                Chart {
                    ForEach(piechartdata) { data in
                        SectorMark(
                            angle: .value("Usage", data.value),
                            innerRadius: .ratio(0.5)
                        )
                        .foregroundStyle(data.color)
                        .annotation(position: .overlay) {
                            Text(data.category)
                                .font(.custom("Futura", size:14))
                                .bold()
                                .foregroundColor(.white)
                                .shadow(color:.white,radius:1)
                            Spacer().frame(height: 15)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .frame(width: 400, height: 750)
            .padding(.bottom, -15 )
        }
    }
    
    
    func iconName(for category: String) -> String {
        switch category {
        case "Entertainment": return "desktopcomputer"
        case "Gaming": return "gamecontroller.fill"
        case "Social": return "bubble.left.fill"
        case "Other": return "ellipsis.circle.fill"
        default: return "questionmark"
        }
    }
}
#Preview {
    StatsView()
}
