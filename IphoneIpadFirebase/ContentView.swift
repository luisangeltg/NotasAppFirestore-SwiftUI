//
//  ContentView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 28/11/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var loginShow : FirebaseViewModel
    var body : some View {
        return Group{
            if loginShow.show {
                Home()
                    .edgesIgnoringSafeArea(.all)
                    //.preferredColorScheme(.dark)
            }else{
                Login()
                    //.preferredColorScheme(.light)
            }
        }.onAppear{
            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                loginShow.show = true
            }
        }
    }
}
