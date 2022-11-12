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
    var walkSpeed: Double = 0.0
    
    
    func setUpHealthRequest(){
        print("is it run")
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
        self.getWalkSpeed()
    }
    
    
    func readWalkingSpeed() {
        //update walking speed data from health app
        var res: Double? = 0.0
        let walkingType = HKSampleType.quantityType (forIdentifier: HKQuantityTypeIdentifier.walkingSpeed)!
        let querySpeed = HKSampleQuery(sampleType: walkingType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                res = result.quantity.doubleValue(for: .meter().unitDivided(by: .second()))
                self.walkSpeed = res!
                print(self.walkSpeed)
            }
            else{
                print("nil returned")
                res = 0.0
            }
        }
        healthStore.execute(querySpeed)
    }
    
    func getWalkSpeed() {
        do {
            if ( try healthStore.wheelchairUse().wheelchairUse == HKWheelchairUse.yes) {
                print("I am crippled?")
                walkSpeed = 0.5
            }
            else {
                readWalkingSpeed()
            }
        }
        catch {
            print("Wheel Chair use not avaliable")
        }
    }
}




