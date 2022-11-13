//
//  MapView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/6/22.
//

import SwiftUI
import MapKit
import CoreLocation
import UIKit


extension CLLocationCoordinate2D {
    init(_ location: CLLocation) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    let annotationItems: [Place]
    
    // Create the MKMapView using UIKit VC
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        for item in annotationItems {
            let annotation = MKPointAnnotation()
            annotation.title = item.name
            annotation.coordinate = item.coordinate
            mapView.addAnnotation(annotation)
        }
        return mapView
    }
    
    
    // We don't need to worry about this as the view will never be updated.
    func updateUIView(_ view: MKMapView, context: Context) {}
    
    // Link it to the coordinator which is defined below.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let annotTitle = annotation.title
        
        
        let ident = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ident)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: ident)
            if (annotTitle != "End" && annotTitle != "Start") {
                annotationView?.image = UIImage(systemName: "parkingsign.circle.fill")
            }
            //annotation.pinT
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
}

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var tintColor: Color = .red
}


struct MapDetailsBottomView: View {
    
    var travelTime: Int
    
    
    var body: some View {
        VStack {
            
        }
    }
}

struct ParkingLotDetailView: View {
    var name: String
    var handicapSpaces: Int
    var spotsAvailible: Int
    var pct: Int
    var lotLocation: CLLocation
    var dest: CLLocation
    
    var dist: Int {
        return Int(dest.distance(from: lotLocation).magnitude)
    }
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "parkingsign.circle.fill").font(.system(size: 48))
                    .foregroundColor(.blue)
                VStack {
                    Text(name)
                        .font(.system(size: 24, design: .rounded))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text("Handicap Spots: \(handicapSpaces)")
                                .padding(.horizontal, 5)
                            Text("Total Spots: \(spotsAvailible)")
                                .padding(.horizontal, 5)
                            Text("\(pct)% usually availible")
                            
                        }
                    }
                    Text("Distance: \(dist) meters")
                    .font(.body)
                }
                .foregroundColor(.white)
            }
            //RoundedRectangle(cornerRadius: 10).background(.thickMaterial)
            
        }
        .frame(height: 100)
    }
}


struct AppleMapView: View {
    
    
    var region: MKCoordinateRegion
    private var lineCoords:[CLLocationCoordinate2D] {
        guard let firstRoute = apiModel.routes.first else {
            print("No first route!")
            return []
        }
        
        return firstRoute.points.coordinates.map { coord in
            return CLLocationCoordinate2D(CLLocation(latitude: coord[1], longitude: coord[0]))
        }
        
        //TestData().routeToCoordsArray().map { location in
        //return CLLocationCoordinate2D(location)
    //}
    }
    
    @EnvironmentObject var userInfoModel: UserInfoModel
    @EnvironmentObject var apiModel: APIModel
    
    var route: Route
    
    var annotations: [Place] {
        let startLoc = CLLocationCoordinate2D(route.start)
        let endLoc = CLLocationCoordinate2D(route.end)
        var res =  [Place(name: "Start", coordinate: startLoc, tintColor: .green), Place(name: "End", coordinate: endLoc)]
        res.append(contentsOf: apiModel.parkingLotLocations())
        return res
    }
    
    
    var body: some View {
        VStack {
            if (apiModel.isLoaded) {
                MapView(region: region, lineCoordinates: lineCoords, annotationItems: annotations)
                    .frame(height: 300)
                Divider()
                Text("Parking for \(route.name)")
                    .font(.headline)
                List(apiModel.lots, id: \.self) { lot in
                    ParkingLotDetailView(name: lot.name, handicapSpaces: lot.handicapSpacesTotal, spotsAvailible: lot.occupancy.available, pct: lot.occupancy.pct, lotLocation: CLLocation(latitude: lot.point.coordinates[1], longitude: lot.point.coordinates[0]), dest: route.end)
                        .listRowBackground(Color.clear)
                }
                
                Spacer()
            } else {
                Text("Loading...")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .navigationTitle("Your Trip")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapView(region: MKCoordinateRegion(), route: Route(start: RouteModel.shared.route1.start, end: RouteModel.shared.route1.end, id: UUID(), name: "Test Route to Test"))
    }
}
