//
//  FirebaseStorageService.swift
//  communitycooking
//
//  Created by FMA2 on 31.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI


class FirebaseStorageSercice {
    
    private static let STORAGE_DIR = "storage"
    
    static func uploadImageIntoStorage(imageId: String, image: UIImage, callback: @escaping (Bool) -> ()) {
        let reference = Storage.storage().reference(withPath: "\(STORAGE_DIR)/\(imageId).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        reference.putData(image.cropsToSquare().resize(targetSize: CGSize(width: 512, height: 512)).jpegData(compressionQuality: 0.75)!, metadata: metadata) { metadata, error in
            callback(error == nil)
        }
    }
}
