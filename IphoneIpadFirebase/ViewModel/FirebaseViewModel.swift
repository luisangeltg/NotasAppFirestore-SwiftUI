//
//  FirebaseViewModel.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 29/11/22.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseViewModel : ObservableObject {
    @Published var show = false
    @Published var datos = [FirebaseModel]()
    @Published var itemUpdate : FirebaseModel!
    @Published var showEditar = false
    
    func sendData(item : FirebaseModel){
        itemUpdate = item
        showEditar.toggle()
        
    }
    
    func login(email: String, passw: String, completion: @escaping(_ done: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: passw){ (user, error) in
            if user != nil {
                print("Login done sucessfully")
                completion(true)
            }else{
                if let error = error?.localizedDescription {
                    print("error firebase:", error)
                }else{
                    print("error en la app")
                }
            }
        }
    }
    
    func createUser(email: String, passw: String, completion: @escaping(_ done: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: passw){(user, error) in
            if user != nil {
                print("Created user and login sucessfully")
                completion(true)
            }else{
                if let error = error?.localizedDescription {
                    print("error firebase / Created user and login:", error)
                }else{
                    print("error en la app / Created user and login")
                }
            }
        }
    }
    
    //Base de datos
    //Guardar
    func save(titulo: String, desc: String, plataforma: String, portada: Data, completion: @escaping (_ done: Bool) -> Void){
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directorio.putData(portada, metadata: metadata){data, error in
            if error == nil {
                print("se guardó la imagen")
                
                //Guardar texto
                let db = Firestore.firestore()
                let id = UUID().uuidString

                guard let idUser = Auth.auth().currentUser?.uid else { return }
                guard let email = Auth.auth().currentUser?.email else { return }

                let campos: [String: Any] = ["titulo": titulo, "desc": desc, "portada": String(describing: directorio), "idUser": idUser, "email": email]
                db.collection(plataforma).document(id).setData(campos) { error in
                    if let error = error?.localizedDescription {
                        print("Error al guardar firestore: ", error)
                    } else {
                        print("guardo firestore")
                        completion(true)
                    }
                }
            }else {
                if let error = error?.localizedDescription {
                    print("fallo al subir la imagen en storage", error)
                }else{
                    print("fallo la app")
                }
            }
        }
        
        
            
    }
    
    //Mostrar
    func getData(plataforma: String) {
        let db = Firestore.firestore()
        db.collection(plataforma).addSnapshotListener{(QuerySnapshot, error) in
            if let error = error?.localizedDescription {
                print("Error al mostrar datos: ", error)
            }else{
                self.datos.removeAll()
                //print("--------- document --------", QuerySnapshot!.documents.hashValue)
                for document in QuerySnapshot!.documents {
                    let valor = document.data()
                    //print("******** ///// valores:", valor)
                    let id = document.documentID
                    let titulo = valor["titulo"] as? String ?? "Sin título"
                    let desc = valor["desc"] as? String ?? "Sin desc"
                    let portada = valor["portada"] as? String ?? "Sin portada"
                    DispatchQueue.main.async {
                        let registros = FirebaseModel(id: id, titulo: titulo, desc: desc, portada: portada)
                        self.datos.append(registros)
                    }
                    
                }
            }
        }
    }
    
    //Eliminar
    func delete(index: FirebaseModel, plataforma: String){
        //Eliminar firestore
        let id = index.id
        let db = Firestore.firestore()
        db.collection(plataforma).document(id).delete()
        //Eliminar del storage
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        borrarImagen.delete(completion: nil)
    }
    
    //Editar
    func edit(titulo: String, desc: String, plataforma: String, id: String, completion: @escaping (_ done: Bool)-> Void ){
        let db = Firestore.firestore()
        let campos : [String:Any] = ["titulo":titulo, "desc":desc]
        db.collection(plataforma).document(id).updateData(campos){ error in
            if let error = error?.localizedDescription {
                print("Error al editar:", error)
            } else {
                print("Edito solo texto")
                completion(true)
            }
        }
    }
    
    //Editar con imagen
    func editWithImage(titulo: String, desc: String, plataforma: String, id: String, index: FirebaseModel, portada: Data, completion: @escaping (_ done: Bool)-> Void ){
        //Eliminar imagen
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        borrarImagen.delete(completion: nil)
        
        //Subir la nueva imagen
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directorio.putData(portada, metadata: metadata){data, error in
            if error == nil {
                print("guardo la imagen nueva")
                //Editando texto
                let db = Firestore.firestore()
                let campos : [String:Any] = ["titulo":titulo, "desc":desc, "portada":String(describing: directorio)]
                db.collection(plataforma).document(id).updateData(campos){ error in
                    if let error = error?.localizedDescription {
                        print("Error al editar:", error)
                    } else {
                        print("Edito solo texto")
                        completion(true)
                    }
                }
                
            }else {
                if let error = error?.localizedDescription {
                    print("fallo al subir la imagen en storage", error)
                }else{
                    print("fallo la app")
                }
            }
        }
    }
}
