//
//  RoutesModel.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/12/22.
//

import Foundation
import CoreLocation

struct Route: Identifiable {
    var start: CLLocation
    var end: CLLocation
    var id: UUID
    var name: String
}

class RouteModel {
    private static var locations = [
        [
            CLLocation(latitude: 37.75560, longitude: -122.45242),
            CLLocation(latitude: 37.76199, longitude: -122.43508)
        ],
        [
            CLLocation(latitude: 37.80276, longitude: -122.40583),
            CLLocation(latitude: 37.78979, longitude: -122.39757)
        ],
        [
            CLLocation(latitude: 37.73387, longitude: -122.50599),
            CLLocation(latitude: 37.77808, longitude: -122.39121)
        ]
        
    ]
    
    let route1 = Route(start: locations[0][0], end: locations[0][1], id: UUID(), name: "Sutro Tower to Castro Theatre")
    let route2 = Route(start: locations[1][0], end: locations[1][1], id: UUID(), name: "Coit Tower to Salesforce Tower")
    let route3 = Route(start: locations[2][0], end: locations[2][1], id: UUID(), name: "SF Zoo to Oracle Park")
    
    static let shared = RouteModel()
    
    func getRoutes() -> [Route] {
        return [route1, route2, route3]
    }
}
