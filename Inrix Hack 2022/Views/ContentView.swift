//
//  ContentView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/6/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject private var navModel = MyNavigationModel()
    
    var body: some View {
        RouteSelectionView()
            .environmentObject(navModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
