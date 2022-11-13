//
//  MapView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/6/22.
//

import SwiftUI
import MapKit
import CoreLocation


extension CLLocationCoordinate2D {
    init(_ location: CLLocation) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

struct MapView: UIViewRepresentable {

  let region: MKCoordinateRegion
  let lineCoordinates: [CLLocation]
    let annotationItems: [Place]

  // Create the MKMapView using UIKit.
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region
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
    
}

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var tintColor: Color = .red
}



struct AppleMapView: View {
    
    func regionForRoute(_ route: Route) {
        
        let start = CLLocationCoordinate2D(route.start)
        let end = CLLocationCoordinate2D(route.end)
        let p1 = MKMapPoint(start);
        let p2 = MKMapPoint(end);
        let mapRect = MKMapRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: abs(p1.x-p2.x), height: abs(p1.y-p2.y))
        var region = MKCoordinateRegion(mapRect)
        let padding = 0.000001111 * sqrt(pow(abs(p1.x - p2.x), 2) + pow(abs(p1.y - p2.y), 2))
        region.span.longitudeDelta = padding
        region.span.latitudeDelta = padding
        self.region = region
        
    }
    
//    func setRegion() {
//        let centerCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.778, -122.441)
//        region = regionForRoute(route)
//    }
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State private var lineCoords:[CLLocation] = []
    @EnvironmentObject var userInfoModel: UserInfoModel
    var route: Route
    
    //TODO: will need to add the parking lots locations from the API
    var annotations: [Place] {
        let startLoc = CLLocationCoordinate2D(route.start)
        let endLoc = CLLocationCoordinate2D(route.end)
        return [Place(name: "Start", coordinate: startLoc, tintColor: .green), Place(name: "End", coordinate: endLoc)]
    }
    
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: annotations) { item in
                MapMarker(coordinate: item.coordinate, tint: item.tintColor)
            }
            .frame(height: 300)
            Divider()
            Text(route.name)
                .font(.subheadline)
            Spacer()
        }
        .navigationTitle("Your Trip")
        .onAppear {
            regionForRoute(route)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapView(route: Route(start: RouteModel.shared.route1.start, end: RouteModel.shared.route1.end, id: UUID(), name: "Test Route to Test"))
    }
}
