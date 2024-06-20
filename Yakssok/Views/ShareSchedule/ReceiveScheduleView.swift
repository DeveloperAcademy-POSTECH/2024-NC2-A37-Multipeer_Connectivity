//
//  ReceiveScheduleView.swift
//  Yakssok
//
//  Created by 추서연 on 6/20/24.
//
import SwiftUI


struct ReceiveScheduleView: View {
    var receivedData: String
    var peerDisplayName: String
    
    
    @Binding var isPresented: Bool
    @Binding var receivedPeers: [String]
    @Binding var scheduleData: [[Any]]
    
    var dateManager: DateManager = DateManager()
    var timeDotManager: TimeDotManager = TimeDotManager()
    var currentWeekStart: Date = Date()
    
    var body: some View {
        VStack {
            VStack(alignment:.leading){
                
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
            
            Button(action: {
                if let selectedTimes = parseReceivedData(receivedData, dateManager: dateManager, timeDotManager: timeDotManager, currentWeekStart: currentWeekStart) {
                    scheduleData.append([peerDisplayName, "\(dateManager.currentWeekOfMonth)", selectedTimes])
                    receivedPeers.append(peerDisplayName)
                    isPresented = false
                    
                    
                    //디버깅용
                    print("Schedule Data:")
                    for item in scheduleData {
                        if let strings = item as? [String] {
                            print(strings.joined(separator: ", "))
                        } else if let selectedTimes = item as? [SelectedTime] {
                            for selectedTime in selectedTimes {
                                print("Day: \(selectedTime.day), Start Time: \(self.dateManager.timeFormatter.string(from: selectedTime.startTime)), End Time: \(self.dateManager.timeFormatter.string(from: selectedTime.endTime)), Duration: \(selectedTime.duration) hours")
                            }
                        }
                    }
                    
                } else {
                    print("Failed to parse received data.")
                }            }) {
                    
                    HStack{
                        Image("AddSchedule")
                        Text("스케줄 추가하기")}
                    .padding()
                    .foregroundColor(AppColor.white)
                    .padding(.horizontal, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(AppColor.black)
                    )
                    
                }
            
        }
        .padding()
    }
}


func parseReceivedData(_ receivedData: String, dateManager: DateManager, timeDotManager: TimeDotManager, currentWeekStart: Date) -> [SelectedTime]? {
    
    let components = receivedData.components(separatedBy: "/")
    
    var selectedTimes: [SelectedTime] = []
    
    for component in components {
        let subcomponents = component.components(separatedBy: "&")
        
        guard subcomponents.count == 4 else {
            continue
        }
        
        let day = Int(subcomponents[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        let startTimeString = subcomponents[1].trimmingCharacters(in: .whitespacesAndNewlines)
        let endTimeString = subcomponents[2].trimmingCharacters(in: .whitespacesAndNewlines)
        let durationString = subcomponents[3].trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 데이트로 형변환
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
