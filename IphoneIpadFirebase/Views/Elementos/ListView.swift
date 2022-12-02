//
//  ListView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 01/12/22.
//

import SwiftUI

struct ListView: View {
    @Binding var orientation : UIDeviceOrientation
    var device = UIDevice.current.userInterfaceIdiom
    //var orientation = UIDevice.current.orientation
    @Environment(\.horizontalSizeClass) var width
    @StateObject var datos = FirebaseViewModel()
    @State private var showEditar = false
    var plataforma : String

    func getColumns() -> Int {
        return (device == .pad) ? 3 : ((device == .phone && orientation.isLandscape) ? 3 : 1)
        //return (orientation.isLandscape == true) ? 3 : 1
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20),count : getColumns()), spacing: 20) {
                ForEach(datos.datos) { item in
                    CardView(titulo: item.titulo, portada: item.portada, index: item, plataforma: plataforma)
                        .onTapGesture {
                            datos.sendData(item: item)
                        }.sheet(isPresented: $datos.showEditar, content: {
                            EditarView(plataforma: plataforma, datos: datos.itemUpdate)
                        })
                        .padding(.all)
                }
            }
        }.onAppear{
            datos.getData(plataforma: plataforma)
        }
    }
}
