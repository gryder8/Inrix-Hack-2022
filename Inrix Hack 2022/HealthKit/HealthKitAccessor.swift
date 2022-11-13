//
//  HealthKitAccessor.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/12/22.
//

import Foundation
import HealthKit


class HealthKitAccessor {
    var healthStore = HKHealthStore()
    var hasRequestedHealthData = false
    var walkSpeed: Double = 0.0
    var wheelChairUseAvailible: Bool? = nil
    
    
    func setUpHealthRequest(){
        if HKHealthStore.isHealthDataAvailable(){
            var readInfo = Set<HKObjectType>()
            if let wheelchairUse = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.wheelchairUse) {
                wheelChairUseAvailible = true
                readInfo.insert(wheelchairUse)
            } else {
                print("Wheelchair use not found!")
                return
            }
            
            if let walkSpeed = HKSampleType.quantityType (forIdentifier: HKQuantityTypeIdentifier.walkingSpeed) {
                readInfo.insert(walkSpeed)
            } else {
                print("Walking speed not found!")
                return
            }
            
            //let infoToRead = Set([wheelchairUse, walkSpeed])
            //infoToRead is a set of wheelchairUse and walkSpeed
            
            //ask for HealthKit access
            healthStore.requestAuthorization(toShare: Set(), read: readInfo, completion: { (success, error) in
                
                if let error = error {
                    print("HealthKit Authorization Error: \(error.localizedDescription)")
                } else {
                    if success {
                        if self.hasRequestedHealthData { //dont request the same thing over and over
                            print("You've already requested access to health data. ")
                            self.walkSpeed = self.getWalkSpeed()

                        }
                        else {
                            print("HealthKit authorization request was successful! ")
                            self.walkSpeed = self.getWalkSpeed()

                        }
                        self.hasRequestedHealthData = true
                    }
                    else {
                        print("HealthKit authorization did not complete successfully.")
                    }
                }
            })
        }
    }
    
    
    private func readWalkingSpeed() {
        //update walking speed data from health app
        //var res: Double? = 0.0
        let walkingType = HKSampleType.quantityType (forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!
        let walkingSpeedQuery = HKSampleQuery(sampleType: walkingType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                let res = result.quantity.doubleValue(for: .meter().unitDivided(by: .second()))
                self.walkSpeed = res
                print(self.walkSpeed)
            } else {
                print("Latest walking speed not found!")
            }
        }
        healthStore.execute(walkingSpeedQuery)
    }
    
    func getWalkSpeed() -> Double {
        
        if let _ = wheelChairUseAvailible {
            do {
                if (try healthStore.wheelchairUse().wheelchairUse == HKWheelchairUse.yes) {
                    return 0.5
                }
            } catch {
                print("Failed to query wheelchair use!")
            }
        } else {
            readWalkingSpeed()
            return self.walkSpeed
        }
        return 0.0
    }
}




