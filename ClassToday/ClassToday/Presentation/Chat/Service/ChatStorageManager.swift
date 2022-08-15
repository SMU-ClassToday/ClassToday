//
//  ChatStorageManager.swift
//  ClassToday
//
//  Created by poohyhy on 2022/08/02.
//

import Foundation
import FirebaseStorage
import UIKit

struct ChatStorageManager {
    static func uploadImage(image: UIImage, channel: Channel, completion: @escaping (URL?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.4) else { return completion(nil)}
        let channelId = channel.id
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let imageReference = Storage.storage().reference().child("\(channelId)/\(imageName)")
        imageReference.putData(data, metadata: metaData) { _, _ in
            imageReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    static func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let reference = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        reference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}
