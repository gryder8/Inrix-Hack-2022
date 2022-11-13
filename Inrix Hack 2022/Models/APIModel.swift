//
//  APIModel.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/6/22.
//

import Foundation
import CoreLocation
import MapKit

class APIModel: ObservableObject {
    
    var destination: CLLocation = CLLocation()
    var start: CLLocation = CLLocation()
    
    var encodedStart: String {
        return "\(start.coordinate.latitude),\(start.coordinate.longitude)"
    }
    
    var encodedEnd: String {
        return "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
    }
    
    @Published var isLoaded: Bool = false
    @Published var lots: [Lot] = []
    @Published var routes: [Route] = []
    
    @Published var walkingRoutes: [MKRoute] = []
    
    var walkingRoutesModel = WalkingRoutesModel()
    
    func parkingLotLocations() -> [Place] {
        var res = [Place]()
        for lot in lots {
            let place = Place(name: lot.name, coordinate: CLLocationCoordinate2DMake(lot.point.coordinates[1], lot.point.coordinates[0]))
            res.append(place)
        }
        return res
    }
    
    struct Response: Codable {
        var lots: [Lot]
        var routes: [Route]
    }

    struct Lot: Codable, Hashable {
        var occupancy: LotOccupancy
        var point: Coordinate
        var url: String
        var handicapSpacesTotal: Int
        var name: String
    }



    struct LotOccupancy: Codable, Hashable {
        var available: Int
        var pct: Int
        var probability: Int
    }

    struct LotLocation: Codable {
        var point: Coordinate
    }

    struct Coordinate: Codable, Hashable {
        var coordinates: [Double]
    }

    struct Route: Codable {
        var points: Points
        var travelTimeMinutes: Int
        var boundingBox: BoundingBox
    }
    struct Trip: Codable {
        var waypoints: [Waypoints]
    }
    struct Waypoints: Codable {
        var geometry: Geometry
    }
    struct Geometry: Codable {
        var point: Points
    }
    struct BoundingBox: Codable {
        var corner1: Corner
        var corner2: Corner
    }
    struct Corner: Codable {
        var coordinates: [[Double]]
    }

    struct Points: Codable {
        var coordinates: [[Double]]
    }

    func fetchData() async {
        DispatchQueue.main.async {
            self.isLoaded = false
        }
        print("Calling Flask API!")
        let urlString = "http://127.0.0.1:5000/viola?startCoords=\(encodedStart)&destCoords=\(encodedEnd)"
        print("Using URL: \(urlString)")
        let url = URL(string: urlString)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Got data of size \(data)")
            let result = try JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async { //update published properties
                self.lots = result.lots
                self.routes = result.routes
                self.isLoaded = true
            }
            let lotLocations = lots.map { lot in
                return CLLocation(latitude: lot.point.coordinates[1], longitude: lot.point.coordinates[0])
            }
            //walkingRoutesModel.calcUsing(destination: self.destination, lotLocations: lotLocations)
//            DispatchQueue.main.async {
//                self.walkingRoutes = self.walkingRoutesModel.routes
//            }
            
//            print(result.lots[2].point.coordinates)
//            print(result.lots[0].handicapSpacesTotal)
//            print(result.lots[0].occupancy.probability)
        } catch {
            print("Failed to query API : \(error)")
        }
    }
    
    
}
