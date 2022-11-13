//
//  EnterUserInfoView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/12/22.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit


struct EnterUserInfoView: View {
    
    @EnvironmentObject var userInfoModel: UserInfoModel
    @State private var walkSpeedInput = ""
    
    @StateObject var apiModel = APIModel()
    
    private let healthKitAccessor = HealthKitAccessor()
    
    
    var route: Route
    
    private func minuteOptions() -> [Int] {
        var res: [Int] = [Int]()
        
        for i in stride(from: 10, to: 60, by: 5) {
            res.append(i)
        }
        
        return res
    }
    
    func regionForRoute(_ route: Route) -> MKCoordinateRegion {
        
        let start = CLLocationCoordinate2D(route.start)
        let end = CLLocationCoordinate2D(route.end)
        let p1 = MKMapPoint(start);
        let p2 = MKMapPoint(end);
        let mapRect = MKMapRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: abs(p1.x-p2.x), height: abs(p1.y-p2.y))
        var region = MKCoordinateRegion(mapRect)
        let padding = 0.000001111 * sqrt(pow(abs(p1.x - p2.x), 2) + pow(abs(p1.y - p2.y), 2))
        region.span.longitudeDelta = padding
        region.span.latitudeDelta = padding
        return region
        
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
                    Toggle("Handicapped", isOn: $userInfoModel.isHandicapped)
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
                AppleMapView(region: regionForRoute(route), route: route)
                    .environmentObject(userInfoModel)
                    .environmentObject(apiModel)
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
            .simultaneousGesture(TapGesture().onEnded({
                print("Nav link pressed, fetching API!")
                Task(priority: .high) {
                    await apiModel.fetchData()
                }
            }))
            Spacer()
        }
        .navigationTitle("About You")
        .onAppear {
            
            let fmt = NumberFormatter()
            fmt.maximumFractionDigits = 1
            fmt.minimumFractionDigits = 1
                                              
            apiModel.start = route.start
            apiModel.destination = route.end
            print("***Walk SPEED: \(userInfoModel.walkSpeed)")
            //self.walkSpeedInput = fmt.string(from: (userInfoModel.walkSpeed as NSNumber) / 10) ?? ""
            healthKitAccessor.setUpHealthRequest()
            if (healthKitAccessor.walkSpeed != 0.0) {
                self.walkSpeedInput = String(healthKitAccessor.walkSpeed)
                print("Found walkspeed of \(healthKitAccessor.walkSpeed)")
            } else {
                print("Found a value of 0.0!")
            }
        }
    }
}

//struct EnterUserInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnterUserInfoView()
//    }
//}
