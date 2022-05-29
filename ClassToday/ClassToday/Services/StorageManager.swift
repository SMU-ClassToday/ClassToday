//
//  FirestoreStorageManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/17.
//

import FirebaseStorage
import UIKit
import Alamofire

enum StorageError: Error {
    case invalidData
    case putDataError
}

class StorageManager {
    static let shared = StorageManager()
    let storage = Storage.storage()

    private init() {}

    func upload(image: UIImage, completion: @escaping (String) -> Void) throws {
        guard let data = image.jpegData(compressionQuality: 0.3) else {
            throw StorageError.invalidData
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let imagePath = UUID().uuidString
        let firebaseReference = storage.reference().child(imagePath)
        firebaseReference.putData(data, metadata: metaData) { metaData, error in
            if let error = error {
                debugPrint(error)
                return
            }
            firebaseReference.downloadURL { url, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                guard let url = url else {
                    return
                }
                completion(url.absoluteString)
            }
        }
    }
    func downloadImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)

        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data, let image = UIImage(data: imageData) else {
                completion(Result.failure(StorageError.invalidData))
                return
            }
            completion(Result.success(image))
        }
    }

    func deleteImage(urlString: String) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        storageReference.delete { error in
            if let error = error {
                debugPrint(error)
            } else {
                debugPrint("Image \(urlString) deleted")
            }
        }
    }
}
