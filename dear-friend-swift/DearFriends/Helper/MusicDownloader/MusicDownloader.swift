//
//  MusicDownloader.swift
//  DearFriends
//
//  Created by Harsh Doshi on 07/06/23.
//

import Foundation

enum FileType {
    case image
    case video
    case unknown
}

class MusicDownloader: NSObject, URLSessionDownloadDelegate {
    
    var progressHandler: ((Double) -> Void)?
    var completionHandler: ((URL?, Error?) -> Void)?
    var isVideo = false
    var isContainsMp3 = false
    
    private var downloadTask: URLSessionDownloadTask?
    
    func downloadMusic(fromURL url: URL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        if self.checkFileType(for: url) == .image {
            self.isVideo = false
        } else {
            self.isVideo = true
        }
        
        self.isContainsMp3 = url.lastPathComponent.contains(".mp3")
        
        session.accessibilityLabel = url.lastPathComponent
        session.accessibilityValue = url.absoluteString
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    func cancelDownload() {
        downloadTask?.cancel()
    }
    
    // MARK: - URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        progressHandler?(progress)
    }
    
    func checkFileType(for url: URL) -> FileType {
        let fileExtension = url.pathExtension.lowercased()
        
        switch fileExtension {
        case "jpg", "jpeg", "png", "gif":
            return .image
        case "mp4", "mov", "avi", "mkv":
            return .video
        default:
            return .unknown
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceUrl = downloadTask.originalRequest?.url else {
            return
        }
        
        self.checkBookFileExists(withLink: sourceUrl, session: session, location: location) { filePath in
            self.completionHandler?(filePath, nil)
        }
    }
    
    func localFilePath(for url: URL) -> URL? {
        guard let documentsPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    func createDirectory() {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!

        let directoryName = "DearFriends"
        let directoryUrl = documentsUrl.appendingPathComponent(directoryName)

        do {
            try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            print("Directory created successfully at: \(directoryUrl.path)")
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    
    func checkBookFileExists(withLink link: URL, session: URLSession, location: URL, completion: @escaping ((_ filePath: URL?) -> Void)) {
                
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!

        // Generate a unique filename using a timestamp
        let timestamp = Int(Date().timeIntervalSince1970)
        var fileName = "\(timestamp).jpeg"
        if isVideo {
            fileName = "\(timestamp).mp4"
        }
        
        if self.isContainsMp3 {
            fileName = "\(timestamp).mp3"
        }
        
        let destinationUrl = documentsUrl.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: destinationUrl.path) {
            do {
                try fileManager.removeItem(at: destinationUrl)
                print("previous file deleted")
            } catch {
                print("current file could not be deleted")
            }
        }
        
        do {
            try fileManager.moveItem(at: location, to: destinationUrl)
            print("Music file downloaded and saved successfully at: \(destinationUrl.path)")
            completion(destinationUrl)
        } catch {
            print("Error moving downloaded file: \(error.localizedDescription)")
        }
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        completionHandler?(nil, error)
    }
}

