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
        self.destination = destination
        self.lotLocations = lotLocations
        self.calcRoutes()
    }
    
    func calcRoutes() {
        for location in lotLocations {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .walking
            let directions = MKDirections(request: request)
            
            directions.calculate { [weak self] response, error in
                guard let self = self else {
                    return
                }
                
                guard let unwrappedResponse = response else {
                    print("Response is nil!")
                    return
                }
                
                for route in unwrappedResponse.routes {
                    self.routes.append(route)
                }
            }
        }
    }
}
