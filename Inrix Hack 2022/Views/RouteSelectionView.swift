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
                .font(.system(size: 20, design: .rounded))
                //.foregroundColor(.black)
                .padding()
                .background(
                    .thickMaterial,
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                .multilineTextAlignment(.center)
        }
        .frame(width: 300, height: 50)
        .padding(5)
    }
}

struct RouteSelectionView: View {
    

    
    let routeModel = RouteModel.shared
    
    @EnvironmentObject private var navModel: MyNavigationModel
    @StateObject private var userInfoModel = UserInfoModel()
    
    var body: some View {
        NavigationStack(path: $navModel.path) {
            VStack {
                ForEach(routeModel.getRoutes()) { route in
                    
                    NavigationLink(value: route) {
                        RouteView(route: route)
                    }
                }
                .navigationTitle("Choose Your Route!")
                .navigationDestination(for: Route.self, destination: { route in
                    EnterUserInfoView(route: route)
                        .environmentObject(userInfoModel)
                })

                Spacer()
            }
            .padding()
        }
        
    }
}

struct RouteSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RouteSelectionView().environmentObject(MyNavigationModel())
    }
}
