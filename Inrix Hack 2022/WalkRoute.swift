//
//  MapDirections.swift
//  Inrix Hack 2022
//
//  Created by Ricky Schober on 11/12/22.
//

import MapKit

class WalkRoute {
    let start: CLLocation
    let finish: CLLocation
    var route: MKRoute
    init(s: CLLocation, f: CLLocation){
        start = s
        finish = f
        route = MKRoute()
        self.calculateRoute()
    }
    func calculateRoute(){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: finish.coordinate.latitude, longitude: finish.coordinate.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        let directions = MKDirections(request: request)
        directions.calculate { [self] response, error in
            guard let unwrappedResponse = response else { print("ebic fail");return }
                   for rt in unwrappedResponse.routes {
                       print("yo number ",rt.distance)
                       self.route = rt
            }
        }
    }
}

