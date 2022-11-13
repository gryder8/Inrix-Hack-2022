//
//  WalkingRoutesModel.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/13/22.
//

import Foundation
import MapKit

class WalkingRoutesModel: ObservableObject {
    @Published var routes: [MKRoute] = []
    
    private var destination: CLLocation
    private var lotLocations: [CLLocation]
    
    
    ///Create the model and calculate the routes
    init(destination: CLLocation, lotLocations: [CLLocation]) {
        self.destination = destination
        self.lotLocations = lotLocations
        self.calcRoutes()
    }
    
    init() {
        self.destination = CLLocation()
        self.lotLocations = []
    }
    
    func calcUsing(destination: CLLocation, lotLocations: [CLLocation]) {
        print("Calculating routes!")
        self.destination = destination
        self.lotLocations = lotLocations
        self.calcRoutes()
        print("Found \(routes.count) routes")
    }
    
    func calcRoutes() {
        for location in lotLocations {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .walking
            let directions = MKDirections(request: request)
            print("Getting directions from \(location)")
            
            directions.calculate { [weak self] response, error in
                guard error == nil else {
                    print("Error in getting directions! \(error)")
                    return
                }
                
                guard let self = self else {
                    return
                }
                
                guard let unwrappedResponse = response else {
                    print("Response is nil!")
                    return
                }
                
                for route in unwrappedResponse.routes {
                    DispatchQueue.main.async {
                        self.routes.append(route)
                    }
                    print("Found walking route of distance: \(route.distance.magnitude)")
                }
            }
        }
    }
}
