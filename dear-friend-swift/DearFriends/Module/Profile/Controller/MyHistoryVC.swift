//
//  MyHistoryVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 16/05/23.
//

import UIKit
import SkeletonView
import AVFAudio

enum CurrentScreen {
    case download
    case favourites
    case customAudio
    case history
}

class MyHistoryVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var colleView: UICollectionView!
    
    @IBOutlet weak var consTop: NSLayoutConstraint!
    @IBOutlet weak var vwProgress: UIProgressView!
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var vwTop: UIView!
    
    // MARK: - VARIABLES
    
    var currentScreen: CurrentScreen = .history
    var audioVM = AudioViewModel()
    var isFromNoNet = false
    var isFromSuccess = false
    
    var downloader = MusicDownloader()
    var isDownloadProgress = false
    
    var arrOfDownloads = [LocalMusicModel]()
    
    var customVM = CreateCustomAudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        var str_Title = ""
        if self.currentScreen == .favourites {
            str_Title = "My Favorites"
            self.audioVM.currentAudioType = .liked
        }
        else if self.currentScreen == .history {
            str_Title = "My History"
        }
        else if self.currentScreen == .download {
            str_Title = "My Downloads"
        }
        else if self.currentScreen == .customAudio {
            str_Title = "My Custom Audios"
        }
        self.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: str_Title)
    }
    
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.changeStyle()
        
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: MyHistoryCVC.self)
        self.colleView.reloadData()
        
        if self.currentScreen == .download {
            self.fetchDownloadedData()
        }
        
        if self.isFromNoNet {
            self.btnBack.isHidden = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
            
        } else if self.currentScreen != .download {
            self.startAnimationColle()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if self.currentScreen == .customAudio {
                    self.getCustomAudio()
                } else {
                    self.getMusicList()
                }
            }
        }
    }
    
    func getCustomAudio() {
        self.customVM.type = "completed"
        self.customVM.getCustomAudioRequests { _ in
            
            self.customVM.arrOfCustomRequests.removeAll(where: {($0.requestStatus ?? "") != "Delivered"})
            
            self.colleView.hideSkeleton()
            self.colleView.reloadData()
            self.colleView.restore()
            
            if self.customVM.arrOfCustomRequests.count  == 0 {
                self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
            }
            
            self.audioVM.arrOfAudioList.removeAll()
            
            for current in self.customVM.arrOfCustomRequests {
                let newcurrent = CommonAudioList.init(json: "")
                newcurrent.file = current.audio_file
                newcurrent.narratedBy = "Dear Friends"
                newcurrent.title = current.meditationName ?? ""
                newcurrent.internalIdentifier = current.internalIdentifier ?? 0
                newcurrent.musicURL = URL(string: current.audio_file)
                newcurrent.audioDuration = current.audio_duration
                
                let category = Category.init(json: "")
                category.title = current.format ?? ""
                newcurrent.category = category
                
                self.audioVM.arrOfAudioList.append(newcurrent)
            }
            
            self.colleView.reloadData()
            
        } failure: { errorResponse in
            
        }
    }
    
    func fetchDownloadedData() {
        CommonCDFunctions.getProductInfoFromData { respose, errorr, count in
            print("respose", respose)
            self.arrOfDownloads.removeAll()
            respose.forEach { down in
                if (down.music_file != nil) {
                    self.arrOfDownloads.append(LocalMusicModel(userid: down.userid ?? "",
                                                               music_title: down.music_title ?? "",
                                                               music_id: down.music_id ?? "",
                                                               music_duration: down.music_duration ?? "",
                                                               music_duration_secods: down.music_duration_secods ?? "",
                                                               narrated_by: down.narrated_by ?? "",
                                                               category: down.category ?? "",
                                                               category_id: down.category_id ?? "",
                                                               music_local_url: down.music_local_url ?? "",
                                                               female_music_local_url: down.female_music_local_url ?? "",
                                                               forStr: down.forStr ?? "",
                                                               female_music_duration_secods: down.female_music_duration_secods ?? "",
                                                               music_file: down.music_file,
                                                               female_file: down.female_file,
                                                               music_image: down.music_image,
                                                               is_background_audio: down.is_background_audio ?? "",
                                                               isForCustom: down.isForCustom == true ? 1 : 0,
                                                               defaultBGMusic: down.backgrounds as? [BackgroundsList] ?? []))
                }
            }
            
            self.colleView.reloadData()
            self.colleView.restore()
            
            if self.arrOfDownloads.count == 0 {
                self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
            }
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let status = userInfo["Status"] as? String {
                print("CURRENT NETWORK :-- ", status)
                if status == "Offline" {
                    self.btnBack.isHidden = true
                } else {
                    if appDelegate.isNetRootSet {
                        appDelegate.setTabbarRoot()
                    } else {
                        if let topvc = UIApplication.topViewController2() {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                NotificationCenter.default.post(name: Notification.Name("BottomView"), object: nil, userInfo: ["hide": "0"])
                            }
                            topvc.navigationController?.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    private func startAnimationColle() {
        
        let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#353b48"))
        self.colleView.isSkeletonable = true
        self.colleView.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    func getMusicList() {
        if self.currentScreen == .history {
            self.audioVM.getPlayedAudioList { _ in
                
                self.colleView.hideSkeleton()
                self.colleView.reloadData()
                self.colleView.restore()
                
                if self.audioVM.arrOfAudioList.count == 0 {
                    self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
                }
                
            } failure: { errorResponse in
                
            }
            
        } else {
            self.audioVM.getAudioList { _ in
                
                self.colleView.hideSkeleton()
                self.colleView.reloadData()
                self.colleView.restore()
                
                if self.audioVM.arrOfAudioList.count == 0 {
                    self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
                }
                
            } failure: { errorResponse in
                
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if self.isFromSuccess {
            appDelegate.setTabbarRoot()
        } else {
            self.goBack(isGoingTab: true)
        }
    }
}

// MARK: - Collection Methods

extension MyHistoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.currentScreen == .download {
            return self.arrOfDownloads.count
        }
        if self.currentScreen == .customAudio {
            return self.customVM.arrOfCustomRequests.count
            
        } else {
            return self.audioVM.arrOfAudioList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyHistoryCVC", for: indexPath) as? MyHistoryCVC else { return UICollectionViewCell() }
        
        cell.currentScreen = self.currentScreen
        
        if self.currentScreen == .download {
            cell.btnMore.setImage(UIImage(named: "ic_delete_3"), for: .normal)
            
        } else if self.currentScreen == .favourites {
            cell.btnMore.setImage(UIImage(named: "ic_download3"), for: .normal)
            
        } else if self.currentScreen == .history {
            cell.btnMore.setImage(UIImage(named: "ic_download3"), for: .normal)
            cell.isLiked = (self.audioVM.arrOfAudioList[indexPath.row].isLiked ?? 0) == 1
        }
        
        if self.currentScreen == .customAudio {
            let current = self.customVM.arrOfCustomRequests[indexPath.row]
            
            cell.lblTitle.text = current.meditationName ?? ""
            let ddd = current.audio_duration.doubleValue
            if ddd > 0 {
                cell.lblDuration.text = TimeInterval(ddd).formatDuration()
            } else {
                cell.lblDuration.text = "0 Seconds"
            }
            cell.imgMain.image = UIImage(named: "ic_pref_temp")
            
            cell.newMenuTapped = { ind in
                if ind == 0 {
                    if !appDelegate.isPlanPurchased {
                        let popupVC: CommonBottomPopupVC = CommonBottomPopupVC.instantiate(appStoryboard: .Profile)
                        popupVC.height = 260
                        popupVC.presentDuration = 0.5
                        popupVC.dismissDuration = 0.5
                        popupVC.leftStr = "Not Yet"
                        popupVC.rightStr = "Proceed To Premium"
                        popupVC.titleStr = "To download content for offline use,  please subcribe to our premium membership"
                        popupVC.yesTapped = {
                            let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        DispatchQueue.main.async {
                            self.present(popupVC, animated: true, completion: nil)
                        }
                        
                    } else if current.isDownloaded == true {
                        GeneralUtility().showErrorMessage(message: "This music '\(current.meditationName ?? "")' already downloaded in your account.")
                        
                    } else if self.isDownloadProgress {
                        GeneralUtility().showErrorMessage(message: "Downloading is in progresss, Please wait.")
                        
                    } else {
                        let newcurrent = CommonAudioList.init(json: "")
                        newcurrent.file = current.audio_file
                        newcurrent.narratedBy = "Dear Friends"
                        newcurrent.title = current.meditationName ?? ""
                        newcurrent.internalIdentifier = current.internalIdentifier ?? 0
                        newcurrent.musicURL = URL(string: current.audio_file)
                        newcurrent.audioDuration = current.audio_duration
                        
                        let category = Category.init(json: "")
                        category.title = current.format ?? ""
                        newcurrent.category = category
                        
                        self.downloadTapped(current: newcurrent, isFromCustom: true)
                    }
                } else if ind == 1 {
                    self.customVM.pinAudio(audio_id: "\(current.internalIdentifier ?? 0)") { _ in
                        self.getCustomAudio()
                    } failure: { errorResponse in
                        
                    }
                }
            }
            
        } else {
            if self.audioVM.arrOfAudioList.count > 0 {
                let current = self.audioVM.arrOfAudioList[indexPath.row]
                cell.dataBind(current: current)
                
                if (current.forSTr ?? "") == "premium" && !appDelegate.isPlanPurchased {
                    cell.vwPremium.isHidden = false
                } else {
                    cell.vwPremium.isHidden = true
                }

                cell.newMenuTapped = { ind in
                    if ind == 1 {
                        
                        if current.isLiked == 0 {
                            self.audioVM.arrOfAudioList[indexPath.row].isLiked = 1
                        } else {
                            self.audioVM.arrOfAudioList[indexPath.row].isLiked = 0
                        }
                        
                        if self.currentScreen == .favourites {
                            
                            self.audioVM.arrOfAudioList.remove(at: indexPath.row)
                            self.colleView.reloadData()
                            
                            if self.audioVM.arrOfAudioList.count == 0 {
                                self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
                            }
                            
                            self.audioVM.addOrRemoveLike(id: "\(current.internalIdentifier ?? 0)") { _ in
                            } failure: { errorResponse in
                            }
                            
                        } else {
                            
                            self.colleView.reloadData()
                            self.audioVM.addOrRemoveLike(id: "\(current.internalIdentifier ?? 0)") { _ in
                            } failure: { errorResponse in
                            }
                        }
                        
                    } else if ind == 0 {
                        if !appDelegate.isPlanPurchased {
                            let popupVC: CommonBottomPopupVC = CommonBottomPopupVC.instantiate(appStoryboard: .Profile)
                            popupVC.height = 260
                            popupVC.presentDuration = 0.5
                            popupVC.dismissDuration = 0.5
                            popupVC.leftStr = "Not Yet"
                            popupVC.rightStr = "Proceed To Premium"
                            popupVC.titleStr = "To download content for offline use,  please subcribe to our premium membership"
                            popupVC.yesTapped = {
                                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                                vc.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            DispatchQueue.main.async {
                                self.present(popupVC, animated: true, completion: nil)
                            }
                            
                        } else if current.isDownloaded == true {
                            GeneralUtility().showErrorMessage(message: "This music '\(current.title ?? "")' already downloaded in your account.")
                            
                        } else if self.isDownloadProgress {
                            GeneralUtility().showErrorMessage(message: "Downloading is in progresss, Please wait.")
                            
                        } else {
                            self.downloadTapped(current: current)
                        }
                    }
                }
                
                cell.playTapped = {
                    GeneralUtility().addButtonTapHaptic()
                    let vc: MusicVC = MusicVC.instantiate(appStoryboard: .Explore)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            if self.currentScreen == .download {
                let current = self.arrOfDownloads[indexPath.row]
                
                cell.lblTitle.text = current.music_title
                
                let ddd = current.music_duration.doubleValue
                cell.lblDuration.text = TimeInterval(ddd).formatDuration()
                
                if let music_image = current.music_image {
                    cell.imgMain.image = UIImage(data: music_image)
                } else {
                    cell.imgMain.image = UIImage(named: "ic_pref_temp")
                }
                
                if self.arrOfDownloads[indexPath.row].forStr == "premium" && !appDelegate.isPlanPurchased {
                    cell.vwPremium.isHidden = false
                } else {
                    cell.vwPremium.isHidden = true
                }
                
                cell.playTapped = {
                    GeneralUtility().addButtonTapHaptic()
                    let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                    vc.hidesBottomBarWhenPushed = true
                    vc.isFromDownload = true
                    vc.arrOfDownloads = self.arrOfDownloads
                    vc.currentSongIndex = indexPath.row
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                cell.deleteTapped = {
                    GeneralUtility().addButtonTapHaptic()
                    let popupVC: CommonBottomPopupVC = CommonBottomPopupVC.instantiate(appStoryboard: .Profile)
                    popupVC.height = 260
                    popupVC.presentDuration = 0.5
                    popupVC.dismissDuration = 0.5
                    popupVC.titleStr = "Are you sure you want to delete this?"
                    popupVC.yesTapped = {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            CommonCDFunctions.deleteProduct(currentProduct: current) { saved, error in
                                if saved {
                                    GeneralUtility().showSuccessMessage(message: "'\(current.music_title)' deleted successfully.")
                                    self.arrOfDownloads.remove(at: indexPath.row)
                                    self.colleView.reloadData()
                                    
                                    if self.arrOfDownloads.count == 0 {
                                        self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.present(popupVC, animated: true, completion: nil)
                    }
                }
            }
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width), height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.currentScreen == .download {
            if self.arrOfDownloads[indexPath.row].forStr == "premium" && !appDelegate.isPlanPurchased {
                
                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                vc.isFromDownload = true
                vc.arrOfDownloads = self.arrOfDownloads
                vc.currentSongIndex = indexPath.row
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if self.currentScreen == .customAudio {
            
//            if appDelegate.isPlanPurchased {
//                let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
//                vc.currentSong = self.audioVM.arrOfAudioList[indexPath.row]
//                vc.isFromDownload = false
//                vc.audioVM = self.audioVM
//                vc.isFromCustom = true
//                vc.currentSongIndex = indexPath.row
//                vc.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
//                
//            } else {
//                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
//                vc.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
            vc.currentSong = self.audioVM.arrOfAudioList[indexPath.row]
            vc.isFromDownload = false
            vc.audioVM = self.audioVM
            vc.isFromCustom = true
            vc.currentSongIndex = indexPath.row
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let current = self.audioVM.arrOfAudioList[indexPath.row]
            
            if (current.forSTr ?? "") == "premium" && !appDelegate.isPlanPurchased {
                
                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                vc.currentSong = self.audioVM.arrOfAudioList[indexPath.row]
                vc.isFromDownload = false
                vc.audioVM = self.audioVM
                if self.currentScreen == .favourites {
                    vc.likedTapped = { liked in
                        self.audioVM.arrOfAudioList.remove(at: indexPath.row)
                        self.colleView.reloadData()
                        self.colleView.restore()
                        if self.audioVM.arrOfAudioList.count == 0 {
                            self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
                        }
                    }
                }
                vc.currentSongIndex = indexPath.row
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentScreen != .download && self.currentScreen != .customAudio {
            if self.colleView.contentOffset.y >= (self.colleView.contentSize.height - self.colleView.bounds.size.height) {
                if (self.audioVM.arrOfAudioList.count) >= 10 {
                    if !(self.audioVM.isAPICalling) {
                        self.audioVM.isAPICalling = true
                        if self.audioVM.haseMoreData {
                            self.audioVM.offset += self.audioVM.limit
                            self.getMusicList()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Download Music

extension MyHistoryVC {
    
    func downloadTapped(current: CommonAudioList, isFromCustom: Bool = false) {
        
        self.vwTop.isHidden = false
        self.isDownloadProgress = true
        self.lblSongName.text = current.title ?? ""
        GeneralUtility().setImage(imgView: self.imgSong, imgPath: current.image ?? "")
        self.lblPer.text = "0%"
        self.vwProgress.progress = 0.01
        
        self.view.layoutIfNeeded()
        self.consTop.constant = -6
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        CommonCDFunctions.CheckandSavePrododuct(currentProduct: current) { saved, error in
            if saved == true {
                self.downloadMusic(current: current, isFromCustom: isFromCustom)
            }
        }
    }
    
    private func downloadImage(current: CommonAudioList, directThis: Bool = false) {
        
        let music_id = "\(current.internalIdentifier ?? 0)"
        
        if let oldDown = self.arrOfDownloads.first(where: {$0.music_id == music_id}) {
            if oldDown.music_image != nil {
                GeneralUtility().showSuccessMessage(message: "Download Completed Successfully.")
                self.isDownloadProgress = false
                return
            }
        }
        
        DispatchQueue.main.async {
            if let musicURL = URL(string: current.image ?? "") {
                print("Image Downloading...")
                DispatchQueue.main.async {
                    self.downloader.downloadMusic(fromURL: musicURL)
                }
                
                self.downloader.progressHandler = { progress in
                    // Update your progress bar with the progress value (0.0 - 1.0)
                    
                    DispatchQueue.main.async {
                        if directThis {
                            
                            self.vwProgress.setProgress(Float(progress), animated: true)
                            let gerPer = Int(100 * progress)
                            self.lblPer.text = "\(gerPer)%"
                            
                        } else {
                            if URL(string: current.femaleAudioStr ?? "") != nil {
                                if Float(progress) < 0.6 {
                                    self.vwProgress.setProgress(Float(progress), animated: true)
                                    let gerPer = Int(100 * progress)
                                    self.lblPer.text = "\(gerPer)%"
                                }
                                
                            } else {
                                if Float(progress) < 0.8 {
                                    self.vwProgress.setProgress(Float(progress), animated: true)
                                    let gerPer = Int(100 * progress)
                                    self.lblPer.text = "\(gerPer)%"
                                }
                            }
                        }
                    }
                }
                
                self.downloader.completionHandler = { location, error in
                    if let location = location {
                        do {
                            let imageData = try Data(contentsOf: location)
                            CommonCDFunctions.updateMyProduct(music_id: music_id,
                                                              myData: imageData,
                                                              key: "music_image",
                                                              music_local_url: location.absoluteString,
                                                              key2: "music_image_local_url") { saved, error in
                                if saved == true {
                                    DispatchQueue.main.async {
                                        self.view.layoutIfNeeded()
                                        self.consTop.constant = 120
                                        
                                        UIView.animate(withDuration: 0.5, animations: {
                                            self.view.layoutIfNeeded()
                                            self.vwTop.isHidden = true
                                        })
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            GeneralUtility().showSuccessMessage(message: "Download Completed Successfully.")
                                            self.isDownloadProgress = false
                                        }
                                    }
                                }
                            }
                            
                        } catch {
                            print("Unable to load data: \(error)")
                        }
                        
                    } else if let error = error {
                        // Handle the download error.
                        print("Unable to load data: \(error)")
                    }
                }
            } else {
                
            }
        }
    }
    
    private func downloadFemaleMusic(current: CommonAudioList) {
        
        let music_id = "\(current.internalIdentifier ?? 0)"
        var isDownloadContinue = true
        
        if let oldDown = self.arrOfDownloads.first(where: {$0.music_id == music_id}) {
            if oldDown.female_file != nil {
                isDownloadContinue = false
                self.downloadImage(current: current, directThis: true)
            }
        }
        
        if isDownloadContinue {
            DispatchQueue.main.async {
                if let musicURL = URL(string: current.femaleAudioStr ?? "") {
                    print("Female Music Downloading...")
                    DispatchQueue.main.async {
                        self.downloader.downloadMusic(fromURL: musicURL)
                    }
                    
                    self.downloader.progressHandler = { progress in
                        
                        // Update your progress bar with the progress value (0.0 - 1.0)
                        DispatchQueue.main.async {
                            if Float(progress) > 0.6 {
                                self.vwProgress.setProgress(Float(progress), animated: true)
                                let gerPer = Int(100 * progress)
                                self.lblPer.text = "\(gerPer)%"
                            }
                        }
                    }
                    
                    self.downloader.completionHandler = { location, error in
                        if let location = location {
                            do {
                                let imageData = try Data(contentsOf: location)
                                CommonCDFunctions.updateMyProduct(music_id: music_id,
                                                                  myData: imageData,
                                                                  key: "female_file",
                                                                  music_local_url: location.absoluteString,
                                                                  key2: "female_music_local_url") { saved, error in
                                    if saved == true {
                                        self.downloadImage(current: current)
                                    }
                                }
                                
                            } catch {
                                print("Unable to load data: \(error)")
                            }
                            
                        } else if let error = error {
                            // Handle the download error.
                            print("Unable to load data: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    private func downloadMusic(current: CommonAudioList, isFromCustom: Bool = false) {
        
        let music_id = "\(current.internalIdentifier ?? 0)"
        var isDownloadContinue = true
        
        if let oldDown = self.arrOfDownloads.first(where: {$0.music_id == music_id}), isFromCustom == false {
            if oldDown.music_file != nil {
                isDownloadContinue = false
                self.downloadImage(current: current, directThis: true)
            }
        }
        
        if isDownloadContinue {
            DispatchQueue.main.async {
                if let musicURL = URL(string: current.file ?? "") {
                    print("Music Downloading...")
                    DispatchQueue.main.async {
                        self.downloader.downloadMusic(fromURL: musicURL)
                    }
                    
                    self.downloader.progressHandler = { progress in
                        
                        // Update your progress bar with the progress value (0.0 - 1.0)
                        DispatchQueue.main.async {
                            if self.currentScreen == .customAudio {
                                self.vwProgress.setProgress(Float(progress), animated: true)
                                let gerPer = Int(100 * progress)
                                self.lblPer.text = "\(gerPer)%"
                                
                            } else {
                                if Float(progress) < 0.8 {
                                    self.vwProgress.setProgress(Float(progress), animated: true)
                                    let gerPer = Int(100 * progress)
                                    self.lblPer.text = "\(gerPer)%"
                                }
                            }
                        }
                    }
                    
                    self.downloader.completionHandler = { location, error in
                        if let location = location {
                            do {
                                let imageData = try Data(contentsOf: location)
                                CommonCDFunctions.updateMyProduct(music_id: music_id,
                                                                  myData: imageData,
                                                                  key: "music_file",
                                                                  music_local_url: location.absoluteString,
                                                                  key2: "music_local_url",
                                                                  isForCustom: self.currentScreen == .customAudio) { saved, error in
                                    if saved == true {
                                        if self.currentScreen == .customAudio {
                                            DispatchQueue.main.async {
                                                self.view.layoutIfNeeded()
                                                self.consTop.constant = 120
                                                
                                                UIView.animate(withDuration: 0.5, animations: {
                                                    self.view.layoutIfNeeded()
                                                    self.vwTop.isHidden = true
                                                })
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    GeneralUtility().showSuccessMessage(message: "Download Completed Successfully.")
                                                    self.isDownloadProgress = false
                                                }
                                            }
                                            
                                        } else {
                                            if saved == true {
                                                if URL(string: current.femaleAudioStr ?? "") != nil {
                                                    self.downloadFemaleMusic(current: current)
                                                } else {
                                                    self.downloadImage(current: current)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            } catch {
                                print("Unable to load data: \(error)")
                            }
                            
                        } else if let error = error {
                            // Handle the download error.
                            print("Unable to load data: \(error)")
                        }
                    }
                }
            }
        }
    }
}
