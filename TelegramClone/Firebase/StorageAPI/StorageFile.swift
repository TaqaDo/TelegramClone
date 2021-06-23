//
//  StorageFile.swift
//  TelegramClone
//
//  Created by talgar osmonov on 9/6/21.
//

import Foundation
import FirebaseStorage
import UIKit



protocol StorageFileHelperProtocol {
    
}

protocol StorageFileProtocol {
    func downloadAvatarImage(url: String,  completion: @escaping(Result<UIImage?, Error>) -> Void)
    func uploadAvatarImage(image: UIImage, directory: String, completion: @escaping(Result<String?, Error>) -> Void)
    func saveFileToDisk(fileData: NSData, fileName: String, completion: @escaping(OnResult))
}

class StorageFile: StorageFileHelperProtocol {
    static let shared = StorageFile()
    private let queue = DispatchQueue(label: "storageApiQueue")
    
    // DiskStorage
    
    func fileNameOfUserUrl(fileUrl: String) -> String {
        let name = ((fileUrl.components(separatedBy: "_").last)?.components(separatedBy: "?").first)?.components(separatedBy: ".").first
        return name!
    }
    
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
    func downloadAvatarImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        queue.async {
            let userUrl = self.fileNameOfUserUrl(fileUrl: url)
            if StorageFile.shared.fileExistsAtPath(path: userUrl) {
                print("local image")
                if let fileImage = UIImage(contentsOfFile: StorageFile.shared.fileInDocumentDierectory(fileName: userUrl)) {
                    DispatchQueue.main.async {
                        completion(.success(fileImage))
                    }
                }
                
            } else {
                print("remote image")
                if url != "" {
                        let data = NSData(contentsOf: URL(string: url)!)
                        if data != nil {
                            self.saveFileToDisk(fileData: data!, fileName: userUrl) { result in
                            }
                            DispatchQueue.main.async {
                                completion(.success(UIImage(data: data! as Data)))
                        }
                    }
                }
            }
        }
    }
    
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
        queue.async {
            let storageRef = storage.reference(forURL: kFILEDIRECTORY).child(directory)
            let imageData = image.jpegData(compressionQuality: 0.6)
            var task: StorageUploadTask?
            task = storageRef.putData(imageData!, metadata: nil, completion: { metaData, error in
                task?.removeAllObservers()
                
                if error != nil {
                    DispatchQueue.main.async {
                        completion(.failure(error!))
                    }
                    print("upload image error \(error?.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    guard let imageUrl = url else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(imageUrl.absoluteString))
                    }
                }
            })
            
            task?.observe(StorageTaskStatus.progress, handler: { snapshot in
                let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                print("Show progress \(progress)")
            })
        }
    }
}
