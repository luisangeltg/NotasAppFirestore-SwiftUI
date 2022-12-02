//
//  Home.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 28/11/22.
//

import Firebase
import SwiftUI

struct Home: View {
    @State private var index = "Playstation"
    @State private var menu = false
    @State private var widthMenu = UIScreen.main.bounds.width
    //@State private var isLandscape = false
    
    @EnvironmentObject var orientationInfo: OrientationInfo
    @EnvironmentObject var loginShow : FirebaseViewModel
    @State private var orientation = UIDevice.current.orientation


    var body: some View {
        ZStack {
            VStack {
                NavBar(index: $index, menu: $menu)
                //Text("Orientation is '\(orientationInfo.orientation == .portrait ? "portrait" : "landscape")'")
                ZStack {
                    if index == "Playstation" {
                        ListView(orientation: $orientation, plataforma: "Playstation")
                    } else if index == "Xbox" {
                        ListView(orientation: $orientation, plataforma: "Xbox")
                    } else if index == "Nintendo" {
                        ListView(orientation: $orientation, plataforma: "Nintendo")
                    } else{
                        AddView()
                    }
                }
            }//Termina navbar ipad
            if menu {
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    menu.toggle()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)

                            }
                        }.padding()
                            .padding(.top, 50)
                        VStack(alignment: .trailing) {
                            ButtonView(index: $index, menu: $menu, title: "Playstation")
                            ButtonView(index: $index, menu: $menu, title: "Xbox")
                            ButtonView(index: $index, menu: $menu, title: "Nintendo")
                            Button(action: {
                                try! Auth.auth().signOut()
                                UserDefaults.standard.removeObject(forKey: "sesion")
                                loginShow.show = false
                            }){
                                Text("Salir")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        Spacer()

                    }
                        .frame(width: widthMenu - 200)
                        .background(Color.purple)
                }
            }
        }.background(Color("fondo"))
            .detectOrientation($orientation)
    }
}





struct DetectOrientation: ViewModifier {

    @Binding var orientation: UIDeviceOrientation

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
    }
}

extension View {
    func detectOrientation(_ orientation: Binding<UIDeviceOrientation>) -> some View {
        modifier(DetectOrientation(orientation: orientation))
    }
}
