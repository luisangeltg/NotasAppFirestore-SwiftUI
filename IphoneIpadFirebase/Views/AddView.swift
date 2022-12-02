//
//  AddView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 29/11/22.
//

import SwiftUI

struct AddView: View {

    @State private var titulo = ""
    @State private var desc = ""
    var consolas = ["Playstation", "Xbox", "Nintendo"]
    @State private var plataforma = "Playstation"
    @State private var guardar = FirebaseViewModel()

    @State private var imageData: Data = .init(capacity: 0)
    @State private var mostrarMenu = true
    @State private var imagePicker = false
    @State private var source: UIImagePickerController.SourceType = .camera
    @State private var progress = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all)
                VStack {
                    NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source), isActive: $imagePicker) {
                        EmptyView()

                    }.navigationBarHidden(true)
                    TextField("Titulo", text: $titulo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextEditor(text: $desc)
                        .frame(height: 200)
                    Picker("Consolas", selection: $plataforma) {
                        ForEach(consolas, id: \.self) { item in
                            Text(item).foregroundColor(.black)
                        }
                    }.foregroundColor(.black)

                    Button(action: {
                        mostrarMenu.toggle()
                    }) {
                        Text("Cargar imagen")
                            .foregroundColor(.black)
                            .bold()
                            .font(.largeTitle)
                    }.actionSheet(isPresented: $mostrarMenu, content: {
                        ActionSheet(title: Text("Menu"), message: Text("Selecciona una opción"),
                            buttons: [
                                .default(Text("Camara"), action: {
                                    source = .camera
                                    imagePicker.toggle()
                                }),
                                .default(Text("Libreria"), action: {
                                    source = .photoLibrary
                                    imagePicker.toggle()
                                }),
                                .default(Text("Cancelar"))
                            ]
                        )
                    })
                    if imageData.count != 0 {
                        Image(uiImage: UIImage(data: imageData)!)
                            .resizable()
                            .frame(width: 250, height: 250)
                            .cornerRadius(15)
                        
                        Button(action: {
                            //Todo: Guardar data
                            progress = true
                            guardar.save(titulo: titulo, desc: desc, plataforma: plataforma, portada: imageData) { (done) in
                                if done {
                                    titulo = ""
                                    desc = ""
                                    imageData = .init(capacity: 0)
                                }

                            }
                        }) {
                            Text("Guardar")
                                .foregroundColor(.black)
                                .bold()
                                .font(.largeTitle)
                        }
                        if progress {
                            Text("Espere un momento por favor...").foregroundColor(.black)
                            ProgressView()
                        }
                    }

                    
                    Spacer()
                }.padding(.all)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
