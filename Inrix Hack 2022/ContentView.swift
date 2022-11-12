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
            var accessor = HealthKitAccessor()
            accessor.setUpHealthRequest()
            accessor.readWalkingSpeed()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
