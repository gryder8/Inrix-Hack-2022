//
//  MapView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/6/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    //@State var mapRect = MKMapRect(
    
    func setRegion() {
        let centerCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.778, -122.441)
        region = MKCoordinateRegion.init(center: centerCoord, latitudinalMeters: 9200, longitudinalMeters: 9200)
    }
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
                .frame(height: 300)
                .padding()
            Divider()
            Text("Bottom Section")
            Spacer()
        }
        .navigationTitle("Your Trip")
        .onAppear {
            setRegion()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
