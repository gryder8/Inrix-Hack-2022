//
//  ContentView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/6/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("INRIX Hack 2022!")
        }
        .padding()
        .onAppear {
            var temp = RouteModel()
            WalkRoute(s: temp.route1.start, f: temp.route1.end)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
