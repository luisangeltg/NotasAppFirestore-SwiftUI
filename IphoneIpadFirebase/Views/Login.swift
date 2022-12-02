//
//  Login.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 29/11/22.
//

import SwiftUI

struct Login: View {
    @State private var email = ""
    @State private var passw = ""
    @StateObject var login = FirebaseViewModel()
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    var device = UIDevice.current.userInterfaceIdiom

    var body: some View {
        ZStack {
            Color.purple.edgesIgnoringSafeArea(.all)
            VStack {
                Text("My Games")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(width: device == .pad ? 400 : nil)
                SecureField("Password", text: $passw)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .frame(width: device == .pad ? 400 : nil)
                    .padding(.bottom, 20)

                //Boton Login
                Button(action: {
                    login.login(email: email, passw: passw){(done) in
                        if done{
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.show.toggle()
                        }
                    }
                }) {
                    Text("Entrar")
                        .font(.title)
                        .frame(width: 200)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    Capsule()
                        .stroke(Color.white)
                )
                Divider()
                //Boton Register
                Button(action: {
                    login.createUser(email: email, passw: passw){(done) in
                        if done{
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.show.toggle()
                        }
                    }
                }) {
                    Text("Registrarse")
                        .font(.title)
                        .frame(width: 200)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    Capsule()
                        .stroke(Color.white)
                )
            }.padding(.all)
        }
    }
}
