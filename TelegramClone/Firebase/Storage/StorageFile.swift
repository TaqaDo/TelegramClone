//
//  StorageFile.swift
//  TelegramClone
//
//  Created by talgar osmonov on 9/6/21.
//

import Foundation
import FirebaseStorage
import UIKit


protocol StorageFileProtocol {
    func uploadAvatarImage(image: UIImage, directory: String, completion: @escaping(Result<String?, Error>) -> Void)
}

class StorageFile {
    static let shared = StorageFile()
}

extension StorageFile: StorageFileProtocol {
    func uploadAvatarImage(image: UIImage, directory: String, completion: @escaping (Result<String?, Error>) -> Void) {
        let storageRef = storage.reference(forURL: kFILEDIRECTORY).child(directory)
        let imageData = image.jpegData(compressionQuality: 0.6)
        var task: StorageUploadTask?
        task = storageRef.putData(imageData!, metadata: nil, completion: { metaData, error in
            task?.removeAllObservers()
            
            if error != nil {
                completion(.failure(error!))
                print("upload image error \(error?.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let imageUrl = url else {
                    return
                }
                completion(.success(imageUrl.absoluteString))
            }
        })
        
        task?.observe(StorageTaskStatus.progress, handler: { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            print("Show progress \(progress)")
        })
    }
}
