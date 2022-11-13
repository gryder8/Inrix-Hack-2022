//
//  EnterUserInfoView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/12/22.
//

import SwiftUI
import Combine
import CoreLocation


struct EnterUserInfoView: View {
    
    @EnvironmentObject var userInfoModel: UserInfoModel
    @State private var walkSpeedInput = ""
    
    var route: Route
    
    private func minuteOptions() -> [Int] {
        var res: [Int] = [Int]()
        
        for i in stride(from: 10, to: 60, by: 5) {
            res.append(i)
        }
        
        return res
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Mobility") {
                    TextField("Walking Speed", text: $walkSpeedInput)
                        .keyboardType(.numberPad)
                        .onReceive(Just(walkSpeedInput)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.walkSpeedInput = filtered
                                userInfoModel.walkSpeed = Double(self.walkSpeedInput) ?? 0.0
                            }
                        }
                    Toggle("Handicapped?", isOn: $userInfoModel.isHandicapped)
                }
                Section("Timeframe") {
                    Picker("Timeframe", selection: $userInfoModel.timeFrame) {
                        ForEach (minuteOptions(), id: \.self) { min in
                            Text("\(min) minutes")
                        }
                    }
                }
            }
            .padding([.bottom, .horizontal])
            .cornerRadius(10)
            NavigationLink(destination: {
                AppleMapView(route: route).environmentObject(userInfoModel)
            }, label: {
                Text("Let's Go!")
                    .foregroundColor(.green)
                    .font(.system(size: 20, design: .rounded))
                    .padding()
                    .background(
                        .thickMaterial,
                        in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
            })
            Spacer()
        }
        .navigationTitle("About You")
    }
}

//struct EnterUserInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnterUserInfoView()
//    }
//}
