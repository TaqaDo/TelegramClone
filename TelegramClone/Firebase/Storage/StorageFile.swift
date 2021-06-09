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
    func saveFileToDisk(fileData: NSData, fileName: String, completion: @escaping(OnResult))
}

class StorageFile {
    static let shared = StorageFile()
    
    
    // DiskStorage
    
    func getdocumentURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    func fileInDocumentDierectory(fileName: String) -> String {
        return getdocumentURL().appendingPathComponent(fileName).path
    }
    
    func fileExistsAtPath(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: fileInDocumentDierectory(fileName: path))
    }
}

// MARK: - StorageFileProtocol

extension StorageFile: StorageFileProtocol {
    func saveFileToDisk(fileData: NSData, fileName: String, completion: @escaping(OnResult)) {
        let docUrl = getdocumentURL().appendingPathComponent(fileName, isDirectory: false)
        do {
            try fileData.write(to: docUrl)
            completion(.success(nil))
        } catch {
            print("cannto save file to disk")
            completion(.failure(error))
        }
        
    }
    
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
