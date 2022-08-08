//
//  AsyncStorageImage.swift
//  communitycooking
//
//  Created by FMA2 on 11.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI
import Firebase

enum PlaceholderImage: String {
    case RECIPE = "defaultRecipe"
    case USER = "defaultUser"
}

struct AsyncStorageImage: View {
    
    @State var url: URL? = nil
    
    var reference: String?
    var placeholderImage: PlaceholderImage
    
    var body: some View {
        AsyncImage(url: self.url) { image in
            image.resizable()
        } placeholder: {
            Image(placeholderImage.rawValue).resizable()
        }
        .ignoresSafeArea()
        .onAppear {
            if self.reference != nil && self.url == nil {
                Storage.storage().reference(withPath: "storage/\(self.reference!).jpg").downloadURL { result, error in
                    if let url = result {
                        self.url = url
                    }
                }
            }
        }
    }
}
