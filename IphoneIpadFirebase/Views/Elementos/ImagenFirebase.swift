//
//  ImagenFirebase.swift
//  IphoneIpadFirebase
//
//  Created by Luis Angel Torres G on 01/12/22.
//

import SwiftUI

struct ImagenFirebase: View {
    let imagenAlternativa = UIImage(systemName: "photo")
    @ObservedObject var imageLoader : PortadaViewModel
    
    init(imageUrl: String){
        imageLoader = PortadaViewModel(imageUrl: imageUrl)
    }
    var image : UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        Image(uiImage: image ?? imagenAlternativa!)
            .resizable()
            .cornerRadius(3.0)
            .shadow(radius: 5)
            .aspectRatio(contentMode: .fit)
    }
}
