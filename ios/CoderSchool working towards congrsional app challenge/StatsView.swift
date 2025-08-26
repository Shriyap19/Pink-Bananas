//
//  StatsView.view.swift
//  CoderSchool working towards congrsional app challenge
//
//  Created by Shriya Patel on 7/22/25.
//

import SwiftUI
import Charts

struct AppData: Identifiable {
    let id = UUID()
    let category: String
    let value: Int
    let color: Color
}

struct StatsView: View {
    @State private var selectedTimeframe: String = "Today"
    
    var piechartdata: [AppData] {
        switch selectedTimeframe {
        case "Today":
            return [
                AppData(category: "Entertainment", value: 20, color: .blue),
                AppData(category: "Gaming", value: 30, color: .green),
                AppData(category: "Social", value: 15, color: .red),
                AppData(category: "Fun", value: 35, color: .yellow)
            ]
        case "Week":
            return [
                AppData(category: "Entertainment", value: 40, color: .blue),
                AppData(category: "Gaming", value: 10, color: .green),
                AppData(category: "Social", value: 20, color: .red),
                AppData(category: "Fun", value: 30, color: .yellow)
            ]
        case "Month":
            return [
                AppData(category: "Entertainment", value: 30, color: .blue),
                AppData(category: "Gaming", value: 20, color: .green),
                AppData(category: "Social", value: 36, color: .red),
                AppData(category: "Fun", value: 24, color: .yellow)
            ]
        case "All-Time":
            return [
                AppData(category: "Entertainment", value: 50, color: .blue),
                AppData(category: "Gaming", value: 10, color: .green),
                AppData(category: "Social", value: 20, color: .red),
                AppData(category: "Fun", value: 20, color: .yellow)
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
    
    func iconName(for category: String) -> String {
        switch category {
        case "Entertainment": return "desktopcomputer"
        case "Gaming": return "gamecontroller.fill"
        case "Social": return "bubble.left.fill"
        case "Fun": return "face.smiling.fill"
        default: return "questionmark"
        }
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Statistics")
                    .font(.custom("Futura", size: 40))
                    .foregroundColor(Color(UIColor.systemBlue))
                    .padding(.vertical,-1)
            }
            
            HStack(spacing: 15) {
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
                            .background(selectedTimeframe == timeframe ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedTimeframe == timeframe ? .white : .black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.vertical,10)
            
            VStack(spacing: 20) {
                ForEach(piechartdata) { data in
                    HStack(spacing: 25) {
                        ZStack {
                            Circle()
                                .fill(data.color)
                                .frame(width: 70, height: 70)
                            Image(systemName: iconName(for: data.category))
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        Text("\(hoursMinutes(from: data.value)) on \(data.category.lowercased()) apps")
                            .font(.custom("Futura", size: 20))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: 250, alignment: .leading)
                    }
                }
            }
            .padding(.bottom, 10)
            
            Chart {
                ForEach(piechartdata) { data in
                    SectorMark(
                        angle: .value("Usage", data.value),
                        innerRadius: .ratio(0.5)
                    )
                    .foregroundStyle(data.color)
                    .annotation(position: .overlay) {
                        Text(data.category)
                            .font(.custom("Futura", size:13))
                            .foregroundColor(.black)
                            .shadow(color:.white,radius:1)
                        Spacer().frame(height: 16)
                    }
                }
            }
            .frame(width: 240, height: 240)
            .padding(.bottom,0 )
        }
        .frame(maxWidth: .infinity, alignment: .center)
        //.padding(.bottom, -22)
    }
}

#Preview {
    StatsView()
}
