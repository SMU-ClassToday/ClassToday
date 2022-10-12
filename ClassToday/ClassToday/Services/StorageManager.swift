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
    case invailidURL
}

class StorageManager {
    static let shared = StorageManager()
    let storage = Storage.storage()

    private init() {}

    /// FireStorage에 이미지를 업로드 합니다.
    func upload(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.3) else {
            completion(.failure(StorageError.invalidData))
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let imagePath = UUID().uuidString
        let firebaseReference = storage.reference().child(imagePath)
        firebaseReference.putData(data, metadata: metaData) { metaData, error in
            if let error = error {
                completion(.failure(error))
            }
            firebaseReference.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let url = url else {
                    completion(.failure(StorageError.invailidURL))
                    return
                }
                completion(.success(url.absoluteString))
            }
        }
    }
    
    /// FireStorage에서 이미지를 다운로드 합니다.
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

    /// FireStorage에서 이미지를 삭제합니다.
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
