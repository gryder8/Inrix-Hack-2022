//
//  UserInfoModel.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/12/22.
//

import Foundation
import HealthKit

class UserInfoModel: ObservableObject {
    
    static let healthStore = HKHealthStore()
    
//    private static var allHealthDataTypes: [HKSampleType] {
//        let typeIdentifiers: [String] = [
//            HKQuantityTypeIdentifier.walkingSpeed.rawValue,
//            HKQuantityTypeIdentifier.
//        ]
//
//        return typeIdentifiers.compactMap { getSampleType(for: $0) }
//    }
        
    @Published var walkSpeed: Double = 3
    @Published var isHandicapped: Bool = true
    @Published var timeFrame: Int = 30
    
    func getDataFromHealthKit() {
        //todo
    }
}
