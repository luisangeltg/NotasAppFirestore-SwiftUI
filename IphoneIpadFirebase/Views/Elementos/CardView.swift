//
//  CardView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 28/11/22.
//

import SwiftUI

struct CardView: View {
    var titulo: String
    var portada: String
    
    var index : FirebaseModel
    var plataforma : String
    
    @StateObject var datos = FirebaseViewModel()
    
    //@Binding var isLandscape : Bool
    var body: some View {
        VStack(spacing: 20){
            ImagenFirebase(imageUrl: portada)
            Text(titulo)
                .font(.title)
                .bold()
                .foregroundColor(.black)
            Button(action:{
                //Eliminar datos
                datos.delete(index: index, plataforma: plataforma)
            }){
                Text("Eliminar")
                    .foregroundColor(.red)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(Capsule().stroke(Color.red))
            }
        }.padding()
            .background(Color.white)
            .cornerRadius(20)
    }
}
