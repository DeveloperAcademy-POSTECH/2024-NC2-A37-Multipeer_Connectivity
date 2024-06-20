//
//  ReceiveScheduleView.swift
//  Yakssok
//
//  Created by 추서연 on 6/20/24.
//
import SwiftUI


struct ReceiveScheduleView: View {
    var dateManager: DateManager
    var timeDotManager: TimeDotManager
    
    var receivedData: String
    var peerDisplayName: String
    
    @Binding var isPresented: Bool
    @Binding var receivedPeers: [String]
    
    
    var body: some View {
        VStack {
            VStack(alignment:.leading) {
                HStack{
                    Spacer()
                    
                    Rectangle()
                        .frame(width:50, height:5)
                        .foregroundColor(AppColor.darkgray)
                        .cornerRadius(15)
                    
                    Spacer()
                }
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .foregroundColor(AppColor.orange)
                        .padding()
                }
            }
            Text("공유된 스케줄")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Divider()
            
            Text("\(peerDisplayName)에서 스케줄을 공유하려고 합니다")
                .font(.caption)
                .foregroundColor(AppColor.darkgray)
                .padding(15)
            
            Text("\(receivedData)")
                .foregroundStyle(.gray)
            
            ForEach(dateManager.receivedScheduleData.indices, id: \.self) { index in
                if let name = dateManager.receivedScheduleData[index]["name"] as? String {
                    Text(name)
                }
                if let weekOfMonth = dateManager.receivedScheduleData[index]["weekOfMonth"] as? String {
                    Text(weekOfMonth)
                }
                if let weekStart = dateManager.receivedScheduleData[index]["weekStart"] as? Date {
                    Text(weekStart.description)
                }
                if let selectedTimes = dateManager.receivedScheduleData[index]["selectedTimes"] as? [SelectedTime] {
                    ForEach(selectedTimes, id: \.self) { item in
                        Text(item.duration.description)
                    }
                }
            }
            
            /*
             if let selectedTimes = parseReceivedData(receivedData, dateManager: dateManager, timeDotManager: timeDotManager) {
             // 파싱된 데이터 출력
             ForEach(selectedTimes, id: \.day) { selectedTime in
             VStack(alignment: .leading) {
             Text("Day: \(selectedTime.day)")
             Text("Start Time: \(self.dateManager.timeFormatter.string(from: selectedTime.startTime))")
             Text("End Time: \(self.dateManager.timeFormatter.string(from: selectedTime.endTime))")
             Text("Duration: \(selectedTime.duration) hours")
             }
             }
             } else {
             Text("Failed to parse received data.")
             }*/
            
            Spacer()
            
            NavigationLink {
                CompleteScheduleView(dateManager: dateManager, timeDotManager: timeDotManager)
            } label: {
                HStack {
                    Image("AddSchedule")
                    Text("스케줄 추가하기")
                }
                .padding()
                .foregroundColor(AppColor.white)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(AppColor.black)
                )
            }

            
//            Button {
//                if let selectedTimes = parseReceivedData(receivedData, dateManager: dateManager, timeDotManager: timeDotManager, currentWeekStart: currentWeekStart) {
//                    // TODO: - 사용자가 전송한 주차의 정보로 currentWeekOfMonth 수정
//                    dateManager.receivedScheduleData.append([peerDisplayName, "\(dateManager.currentWeekOfMonth)", selectedTimes])
//                    let scheduleData = dateManager.receivedScheduleData
//                    receivedPeers.append(peerDisplayName)
//                    isPresented = false
//                    
//                    //디버깅용
//                    print("Schedule Data:")
//                    print(scheduleData.debugDescription)
//                    //                    for item in scheduleData {
//                    //                        if let strings = item as? [String] {
//                    //                            print(strings.joined(separator: ", "))
//                    //                        } else if let selectedTimes = item as? [SelectedTime] {
//                    //                            for selectedTime in selectedTimes {
//                    //                                print("Day: \(selectedTime.day), Start Time: \(DateManager.timeFormatter.string(from: selectedTime.startTime)), End Time: \(DateManager.timeFormatter.string(from: selectedTime.endTime)), Duration: \(selectedTime.duration) hours")
//                    //                            }
//                    //                        }
//                    //                    }
//                    
//                    
//                    
//                } else {
//                    print("Failed to parse received data.")
//                }
//            } label: {
//                HStack {
//                    Image("AddSchedule")
//                    Text("스케줄 추가하기")
//                }
//                .padding()
//                .foregroundColor(AppColor.white)
//                .padding(.horizontal, 30)
//                .background(
//                    RoundedRectangle(cornerRadius: 30)
//                        .fill(AppColor.black)
//                )
//                
//            }
        }
        .onAppear {
            if let data = parseReceivedData(receivedData, dateManager: dateManager, timeDotManager: timeDotManager, name: peerDisplayName) {
                dateManager.receivedScheduleData.append(data)
                print(">================ append data after parsing ================<")
                print(dateManager.receivedScheduleData.debugDescription)
            }
        }
        .padding()
    }
}


//func parseReceivedData(_ receivedData: String, dateManager: DateManager, timeDotManager: TimeDotManager, currentWeekStart: Date) -> [SelectedTime]? {
//    
//    let components = receivedData.components(separatedBy: "/")
//    
//    var selectedTimes: [SelectedTime] = []
//    
//    for component in components {
//        let subcomponents = component.components(separatedBy: "&")
//        
//        guard subcomponents.count == 4 else {
//            continue
//        }
//        
//        let day = Int(subcomponents[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
//        let startTimeString = subcomponents[1].trimmingCharacters(in: .whitespacesAndNewlines)
//        let endTimeString = subcomponents[2].trimmingCharacters(in: .whitespacesAndNewlines)
//        let durationString = subcomponents[3].trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        // 데이트로 형변환
//        guard let startTime = DateManager.timeFormatter.date(from: startTimeString),
//              let endTime = DateManager.timeFormatter.date(from: endTimeString),
//              let duration = Int(durationString)
//        else {
//            continue
//        }
//        
//        let selectedTime = SelectedTime(day: day, startTime: startTime, endTime: endTime)
//        selectedTimes.append(selectedTime)
//    }
//    
//    return selectedTimes.isEmpty ? nil : selectedTimes
//}

func parseReceivedData(_ receivedData: String, dateManager: DateManager, timeDotManager: TimeDotManager, name: String) -> [String : Any]? {
    
    let components = receivedData.components(separatedBy: "/")
    
    var selectedWeekOfMonth: String?
    var selectedWeekStart: Date?
    var selectedTimes: [SelectedTime] = []
    
    for component in components {
        var subcomponents = component.components(separatedBy: "&")
        
        if subcomponents.count == 1 {
            subcomponents = component.components(separatedBy: "-")
            
            selectedWeekOfMonth = subcomponents[1]
            selectedWeekStart = DateManager.detailDateFormatter.date(from: subcomponents[2])
            
            continue
        } else if subcomponents.count != 4 {
            continue
        }
        
        let day = Int(subcomponents[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        let startTimeString = subcomponents[1]
        let endTimeString = subcomponents[2]
        let durationString = subcomponents[3].trimmingCharacters(in: [" ", "-"])
        
        guard let startTime = DateManager.timeFormatter.date(from: startTimeString),
              let endTime = DateManager.timeFormatter.date(from: endTimeString),
              let duration = Int(durationString)
        else {
            print("durationString: \(durationString)")
            continue
        }
        
        let selectedTime = SelectedTime(day: day, startTime: startTime, endTime: endTime)
        selectedTimes.append(selectedTime)
        
        print(">============== selected time data ==============<")
        print(selectedTime.startTime.description)
        print(selectedTime.duration.description)
    }
    
    let data = ["name": name, "weekOfMonth": selectedWeekOfMonth ?? 0, "weekStart": selectedWeekStart ?? .now, "selectedTimes": selectedTimes] as [String : Any]
    
    print(">============== selected times during parsing ==============<")
    print(selectedTimes.description)
    
    return data
}


/*
 
 func parseReceivedData(_ receivedData: String, dateManager: DateManager, timeDotManager: TimeDotManager) -> [SelectedTime]? {
 let components = receivedData.components(separatedBy: "/")
 
 var selectedTimes: [SelectedTime] = []
 
 for component in components {
 let subcomponents = component.components(separatedBy: "&")
 
 // 컴포넌트 4개
 guard subcomponents.count == 4 else {
 continue
 }
 
 let day = Int(subcomponents[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
 let startTimeString = subcomponents[1].trimmingCharacters(in: .whitespacesAndNewlines)
 let endTimeString = subcomponents[2].trimmingCharacters(in: .whitespacesAndNewlines)
 let durationString = subcomponents[3].trimmingCharacters(in: .whitespacesAndNewlines)
 
 // 형 변환
 guard let startTime = dateManager.timeFormatter.date(from: startTimeString),
 let endTime = dateManager.timeFormatter.date(from: endTimeString),
 let duration = Int(durationString)
 else {
 continue
 }
 
 let selectedTime = SelectedTime(day: day, startTime: startTime, endTime: endTime)
 selectedTimes.append(selectedTime)
 }
 
 return selectedTimes.isEmpty ? nil : selectedTimes
 }
 
 */
