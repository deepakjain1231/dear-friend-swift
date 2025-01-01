//
//  CustomLaunchVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 28/06/23.
//

import UIKit
import SwiftyJSON
import AVFoundation

class CustomLaunchVC: BaseVC {
    
    // MARK: - OUTLETS
    var arrOfOnboarding = [OnboardingListModel]()
    
    @IBOutlet weak var acti: UIActivityIndicatorView!
    
    // MARK: - VARIABLES
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.acti.startAnimating()

        self.setupBaseAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "ReloadApp"), object: nil)
    }
    
    @objc func disconnectPaxiSocket(_ notification: Notification) {
        self.setupBaseAPI()
    }
    
    func setupBaseAPI() {
        if Reach().connectionStatus().description == ReachabilityStatus.offline.description {
            appDelegate.setNonetRoot()
            
        } else {
//            if UIApplication.topViewController2() is CustomLaunchVC {
//                self.acti.startAnimating()
//            }
            CurrentUser.shared.getBackAudioList(isShowLoader: false) { _ in
             
                self.setupUI()
                self.downloadMusic(index: 0)
                
            } failure: { _ in
                
            }
        }
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            
            if (CurrentUser.shared.user?.internalIdentifier) == nil || (CurrentUser.shared.user?.internalIdentifier) == 0 {
                appDelegate.setLoginRoot()
                
            } else {
                
                CurrentUser.shared.getUserProfile { _ in
                    if !appDelegate.isFromPush {
                        if UserDefaults.standard.string(forKey: lastPlanPurchsed) != nil {
                            appDelegate.verifyPlanReciptMain()
                        } else {
                            appDelegate.setTabbarRoot()
                        }
                    }
                } failure: { _ in
                    
                }
            }
            
        } else {
            self.getOnboarding { _ in
                
                self.get_AboutCreator_Onboarding { _ in
                    
                } failure: { errorResponse in
                    
                }
                
            } failure: { errorResponse in
                
            }

        }
    }
    
    func getOnboarding(success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
            
        ServiceManager.shared.getRequest(ApiURL: .onboarding_content, parameters: [:], isShowLoader: false) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfOnboarding = [OnboardingListModel]()
                response["data"].arrayValue.forEach { model in
                    self.arrOfOnboarding.append(OnboardingListModel(json: model))
                }
                
//                let vc: OnbordingVC = OnbordingVC.instantiate(appStoryboard: .main)
//                vc.arrOfOnboarding = arrOfOnboarding
//                self.navigationController?.pushViewController(vc, animated: false)
                
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    
    func get_AboutCreator_Onboarding(success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
            
        ServiceManager.shared.getRequest(ApiURL: .onboarding_about_creator, parameters: [:], isShowLoader: false) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                dic_aboutCreator = OnboardingAboutCreatorModel(json: response["data"])

                if let url = URL(string: dic_aboutCreator.file ?? "") {
                    self.getMusicName(from: url) { title in
                        if let title = title {
                            dic_aboutCreator.title = title
                        }
                    }
                    
                    self.getSongDuration(from: url) { duration in
                        if let duration = duration {
                            dic_aboutCreator.audio_duration = Int(duration)
                        }
                    }
                }
                
                let vc: OnbordingVC = OnbordingVC.instantiate(appStoryboard: .main)
                vc.arrOfOnboarding = self.arrOfOnboarding
                self.navigationController?.pushViewController(vc, animated: false)
                
                
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func getMusicName(from music_url: URL, completion: @escaping (String?) -> Void) {
        let asset = AVAsset(url: music_url)
        let metadataKey = "title"
        
        asset.loadValuesAsynchronously(forKeys: ["commonMetadata"]) {
            var title: String?
            
            let status = asset.statusOfValue(forKey: "commonMetadata", error: nil)
            if status == .loaded {
                for metadataItem in asset.commonMetadata {
                    if metadataItem.commonKey?.rawValue == metadataKey {
                        title = metadataItem.stringValue
                        break
                    }
                }
            } else {
                print("Failed to load metadata.")
            }
            
            DispatchQueue.main.async {
                completion(title)
            }
        }
    }
    
    func getSongDuration(from url: URL, completion: @escaping (Double?) -> Void) {
        let audioPlayer = AVPlayer()
        let playerItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: playerItem)
        
        // Wait for the duration to load
        playerItem.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            DispatchQueue.main.async {
                if playerItem.asset.statusOfValue(forKey: "duration", error: nil) == .loaded {
                    let duration = CMTimeGetSeconds(playerItem.asset.duration)
                    completion(duration.isFinite ? duration : nil)
                } else {
                    completion(nil)
                }
            }
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

extension CustomLaunchVC: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Handle the downloaded file at 'location'
        // Move the file to a permanent location if needed
        // Call endBackgroundTask() when done
        
        endBackgroundTask()
        
        guard let sourceUrl = downloadTask.originalRequest?.url else {
            return
        }
        
        if let indexx = Int(self.downloadTask?.accessibilityLabel ?? "") {
            var current = CurrentUser.shared.arrOfBGAudios[indexx]
            self.checkBookFileExists(current: current, withLink: sourceUrl, session: session, location: location) { filePath in
                if let url = filePath {
                    CommonCDFunctions.saveMyBGMusic(currentProduct: current) { isSaved, error in
                        if isSaved {
                            CommonCDFunctions.getBGInfoFromData(with: current.file ?? "") { array, error, count in
                                if let first = array.first {
                                    let addNew = BGAudioListModel.init(json: "")
                                    addNew.file = first.file ?? ""
                                    addNew.internalIdentifier = Int(first.bg_id ?? "") ?? 0
                                    addNew.title = first.title ?? ""
                                    addNew.type = first.type ?? ""
                                    CurrentUser.shared.arrOfDownloadedBGAudios.append(current)
                                }
                            }
                            if let id = CurrentUser.shared.arrOfBGAudios[safe: indexx + 1] {
                                self.downloadMusic(index: indexx + 1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkBookFileExists(current: BGAudioListModel, withLink link: URL, session: URLSession, location: URL, completion: @escaping ((_ filePath: URL?) -> Void)) {
                
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!

        // Generate a unique filename using a timestamp
        let timestamp = Int(Date().timeIntervalSince1970)
        
        if let url = URL(string: current.file ?? "") {
            let fileName = url.lastPathComponent
            print("File Name: \(fileName)")
            let destinationUrl = documentsUrl.appendingPathComponent(fileName)
            
            do {
                try fileManager.moveItem(at: location, to: destinationUrl)
                print("Music file downloaded and saved successfully at: \(destinationUrl.path)")
                completion(destinationUrl)
                
            } catch {
                print("Error moving downloaded file: \(error.localizedDescription)")
            }
            
        } else {
            print("Invalid URL")
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // Handle download completion or error
        if let error = error {
            print("Download failed with error: \(error)")
        }

        // Call endBackgroundTask() when done
        endBackgroundTask()
    }
    
    func checkAndSave(current: BGAudioListModel) {
        CommonCDFunctions.CheckandSaveBGMusic(currentProduct: current) { isSaved, data, error in
            
        }
    }
    
    func beginBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    
    func downloadMusic(index: Int) {
        let current = CurrentUser.shared.arrOfBGAudios[index]
        CommonCDFunctions.checkCurrentBG(currentProduct: current) { downloadeArray, error in
            if downloadeArray.count == 0 {
                self.beginBackgroundTask()
                if let url = URL(string: current.file ?? "") {
                    let config = URLSessionConfiguration.background(withIdentifier: "com.dearfriends.backgroundDownload")
                    let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                    self.downloadTask = session.downloadTask(with: url)
                    self.downloadTask?.accessibilityLabel = "\(index)"
                    self.downloadTask?.resume()
                }
            } else {
                if let first = downloadeArray.first(where: {$0.bg_id == "\(current.internalIdentifier ?? 0)"}) {
                    if let first2 = CurrentUser.shared.arrOfDownloadedBGAudios.first(where: {"\($0.internalIdentifier ?? 0)" == "\(first.bg_id ?? "")"}) {
                        
                        if let id = CurrentUser.shared.arrOfBGAudios[safe: index + 1] {
                            self.downloadMusic(index: index + 1)
                        }
                        
                    } else {
                        let addNew = BGAudioListModel.init(json: "")
                        addNew.file = first.file ?? ""
                        addNew.internalIdentifier = Int(first.bg_id ?? "") ?? 0
                        addNew.title = first.title ?? ""
                        addNew.type = first.type ?? ""
                        CurrentUser.shared.arrOfDownloadedBGAudios.append(addNew)
                        
                        if let id = CurrentUser.shared.arrOfBGAudios[safe: index + 1] {
                            self.downloadMusic(index: index + 1)
                        }
                    }
                } else {
                    if let id = CurrentUser.shared.arrOfBGAudios[safe: index + 1] {
                        self.downloadMusic(index: index + 1)
                    }
                }
            }
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
