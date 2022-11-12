//
//  HealthKitAccessor.swift
//  Inrix Hack 2022
//
//  Created by Ethan Shenassa on 11/12/22.
//

import HealthKit
class HealthKitAccessor {
    var healthStore = HKHealthStore()
    var hasRequestedHealthData = false;
    
    
    func setUpHealthRequest(){
        
        if HKHealthStore.isHealthDataAvailable(){
            
            guard let wheelchairUse = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.wheelchairUse) else {
                print("THIS IS BAD WHEELCHARUSE WAS NULL")
                return
            }
            //protect against nil
            guard let walkSpeed = HKSampleType.quantityType (forIdentifier: HKQuantityTypeIdentifier.walkingSpeed) else {
                return
            }
            
            let infoToRead = Set([wheelchairUse, walkSpeed])
            //infoToRead is a set of wheelchairUse and walkSpeed
            
            //ask for HealthKit access
            healthStore.requestAuthorization(toShare: Set(), read: infoToRead, completion: { (success, error) in
            
                if let error = error {
                    print("HealthKit Authorization Error: \(error.localizedDescription)")
                }
                else {
                    if success {
                        if self.hasRequestedHealthData { //dont request the same thing over and over
                            print("You've already requested access to health data. ")
                        }
                        else {
                            print("HealthKit authorization request was successful! ")
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
    
    
    func readWalkingSpeed() -> Double? {
        //update walking speed data from health app
        let walkingType = HKSampleType.quantityType (forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!
        let querySpeed = HKSampleQuery(sampleType: walkingType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                        print("weight => \(result.quantity)")
                    }
                }
        healthStore.execute(querySpeed)
        return 0.0
        
    }
    
    func getWalkSpeed() -> Double? {
        do {
            if ( try healthStore.wheelchairUse().wheelchairUse == HKWheelchairUse.yes) {
                return nil
            }
            else {
                return self.readWalkingSpeed()
            }
        }
        catch {
            print("Wheel Chair use not avaliable")
        }
        return 0.0
    }
}




