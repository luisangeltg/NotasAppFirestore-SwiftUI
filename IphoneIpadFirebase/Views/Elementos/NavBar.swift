//
//  NavBar.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 28/11/22.
//

import SwiftUI
import Firebase

struct NavBar: View {
    var device = UIDevice.current.userInterfaceIdiom
    @Binding var index: String
    @Binding var menu: Bool
    @EnvironmentObject var loginShow : FirebaseViewModel

    var body: some View {
        HStack {
            Text("My games")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .font(.system(size: device == .phone ? 25 : 35))
            Spacer()
            if device == .pad {
                HStack(spacing: 25) {
                    ButtonView(index: $index, menu: $menu, title: "Playstation")
                    ButtonView(index: $index, menu: $menu, title: "Xbox")
                    ButtonView(index: $index, menu: $menu, title: "Nintendo")
                    ButtonView(index: $index, menu: $menu, title: "Agregar")
                    Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.removeObject(forKey: "sesion")
                        loginShow.show = false
                    }){
                        Text("Salir")
                            .font(.title)
                            .frame(width: 150)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                    }.background(
                        Capsule()
                            .stroke(Color.white)
                    )

                }
            } else {
                //Menu iphone
                Button(action: {
                    index = "Agregar"
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                        .foregroundColor(.white)

                }
                Button(action: {
                    withAnimation {
                        menu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 25))
                        .foregroundColor(.white)

                }
            }
        }
            .padding(.top, 30)
            .padding()
            .background(Color.purple)
    }
}
