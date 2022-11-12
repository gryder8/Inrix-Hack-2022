//
//  RouteSelectionView.swift
//  Inrix Hack 2022
//
//  Created by Gavin Ryder on 11/12/22.
//

import SwiftUI

struct RouteView: View {
    
    var route: Route
    
    var body: some View {
        ZStack {
            Text(route.name)
                .padding()
                .background(
                    .ultraThickMaterial,
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
        }
        .frame(width: 300, height: 50)
    }
}

struct RouteSelectionView: View {
    
    let routeModel = RouteModel.shared
    
    var body: some View {
        VStack {
            ForEach(routeModel.getRoutes()) { route in
                RouteView(route: route)
            }
        }
    }
}

struct RouteSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RouteSelectionView()
    }
}
