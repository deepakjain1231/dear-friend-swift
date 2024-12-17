//
//  ExploreSoundListVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 17/05/23.
//

import UIKit
import SkeletonView
import GoogleMobileAds

class ExploreSoundListVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consTop: NSLayoutConstraint!
    @IBOutlet weak var vwProgress: UIProgressView!
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var imgSubCat: UIImageView!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lbltitle2: UILabel!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var colleView: UICollectionView!
    
    // MARK: - VARIABLES
    
    var audioVM = AudioViewModel()
    var downloader = MusicDownloader()
    
    var arrOfDownloads = [LocalMusicModel]()
    var isDownloadProgress = false
    var currentSongIndex = 0
    
    var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupAD() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Constant.INTERAD,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
        })
    }
    
    func setupUI() {
        self.changeStyle()
        self.dataBind()
        self.setupAD()
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: MyHistoryCVC.self)
        self.colleView.registerCell(type: LoadingCVC.self)
        self.colleView.reloadData()
        
        let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#353b48"))
        self.vwTop.backgroundColor = hexStringToUIColor(hex: "#535c68")
        
        self.colleView.showAnimatedGradientSkeleton(usingGradient: gradient)
        self.fetchDownloadedData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getMusicList()
        }
    }
    
    func fetchDownloadedData() {
        CommonCDFunctions.getProductInfoFromData { respose, errorr, count in
            print("respose", respose)
            self.arrOfDownloads.removeAll()
            respose.forEach { down in
                self.arrOfDownloads.append(LocalMusicModel(userid: down.userid ?? "",
                                                           music_title: down.music_title ?? "",
                                                           music_id: down.music_id ?? "",
                                                           music_duration: down.music_duration ?? "",
                                                           narrated_by: down.narrated_by ?? "",
                                                           category: down.category ?? "",
                                                           category_id: down.category_id ?? "",
                                                           forStr: down.forStr ?? "",
                                                           music_file: down.music_file,
                                                           music_image: down.music_image,
                                                           defaultBGMusic: down.backgrounds as? [BackgroundsList] ?? []))
            }
        }
    }
    
    func dataBind() {
        self.lbltitle2.text = self.audioVM.currentSubCategory?.title ?? ""
        self.lblMainTitle.text = self.audioVM.currentCategory?.title ?? ""
        UIView.performWithoutAnimation {
            GeneralUtility().setImage(imgView: self.imgTop, imgPath: self.audioVM.currentCategory?.image ?? "")
            GeneralUtility().setImage(imgView: self.imgSubCat, imgPath: self.audioVM.currentSubCategory?.image ?? "")
        }
    }
    
    func getMusicList() {
        self.audioVM.getAudioList { _ in
            
            var index = 0
            for it in self.audioVM.arrOfAudioList {
                self.arrOfDownloads.forEach { item in
                    if it.internalIdentifier == Int(item.music_id) && (item.music_file != nil && item.music_image != nil) {
                        self.audioVM.arrOfAudioList[index].isDownloaded = true
                    }
                }
                index += 1
            }
            
            self.colleView.hideSkeleton()
            self.colleView.reloadData()
            
            if self.audioVM.arrOfAudioList.count == 0 {
                self.colleView.setEmptyMessage("No Content Has Been Added Here Yet")
            }
            
        } failure: { errorResponse in
            
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: false)
    }
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        let popupVC: FilterVC = FilterVC.instantiate(appStoryboard: .Explore)
        popupVC.height = 340
        popupVC.audioVM = self.audioVM
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.submitted = { model in
            self.audioVM = model
            self.audioVM.arrOfAudioList.removeAll()
            self.setupUI()
        }
        DispatchQueue.main.async {
            self.present(popupVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Collection Methods

extension ExploreSoundListVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.audioVM.arrOfAudioList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MyHistoryCVC"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        if indexPath.section == 0 {
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "MyHistoryCVC", for: indexPath) as? MyHistoryCVC else { return UICollectionViewCell() }
                        
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "LoadingCVC", for: indexPath) as? LoadingCVC else { return UICollectionViewCell() }
            
            if self.audioVM.haseMoreData {
                cell.loader.startAnimating()
            } else {
                cell.loader.stopAnimating()
            }
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyHistoryCVC", for: indexPath) as? MyHistoryCVC else { return UICollectionViewCell() }
            
            cell.btnMore.setImage(UIImage(named: "ic_download3"), for: .normal)
            
            if self.audioVM.arrOfAudioList.count > 0 {
                let current = self.audioVM.arrOfAudioList[indexPath.row]
                cell.dataBind(current: current)
                
                cell.favTapped = {
                    GeneralUtility().addButtonTapHaptic()
                    if current.isLiked == 0 {
                        self.audioVM.arrOfAudioList[indexPath.row].isLiked = 1
                    } else {
                        self.audioVM.arrOfAudioList[indexPath.row].isLiked = 0
                    }
                    
                    self.colleView.reloadItems(at: [indexPath])
                    
                    self.audioVM.addOrRemoveLike(id: "\(current.internalIdentifier ?? 0)") { _ in
                    } failure: { errorResponse in
                    }
                }
                
                cell.moreTapped = {
                    GeneralUtility().addButtonTapHaptic()
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
                
                cell.playTapped = {
                    GeneralUtility().addButtonTapHaptic()
                    self.currentSongIndex = indexPath.row
                    let vc: MusicVC = MusicVC.instantiate(appStoryboard: .Explore)
                    vc.hidesBottomBarWhenPushed = true
                    vc.audioVM = self.audioVM
                    vc.interstitial = self.interstitial
                    vc.currentSongIndex = self.currentSongIndex
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCVC", for: indexPath) as? LoadingCVC else { return UICollectionViewCell() }
            
            if self.audioVM.haseMoreData {
                cell.loader.startAnimating()
            } else {
                cell.loader.stopAnimating()
            }
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: (self.view.frame.size.width - 20) / 2, height: 190)
        }
        return CGSize(width: self.view.frame.size.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = self.audioVM.arrOfAudioList[indexPath.row]
        
        if current.forSTr != "free" && appDelegate.isPlanPurchased == false {
            let popupVC: CommonBottomPopupVC = CommonBottomPopupVC.instantiate(appStoryboard: .Profile)
            popupVC.height = 260
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.titleStr = "You need to subscribe our premium membership to access this song."
            popupVC.yesTapped = {
                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            DispatchQueue.main.async {
                self.present(popupVC, animated: true, completion: nil)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

// MARK: - Download Music

extension ExploreSoundListVC {
    
    func downloadTapped(current: CommonAudioList) {
        
        self.isDownloadProgress = true
        self.lblSongName.text = current.title ?? ""
        GeneralUtility().setImage(imgView: self.imgSong, imgPath: current.image ?? "")
        self.lblPer.text = "0%"
        self.vwProgress.progress = 0.0
        
        self.view.layoutIfNeeded()
        self.consTop.constant = 6
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        CommonCDFunctions.CheckandSavePrododuct(currentProduct: current) { saved, error in
            if saved == true {
                self.downloadMusic(current: current)
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
                            if Float(progress) > 0.8 {
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
                                                              key: "music_image",
                                                              music_local_url: location.absoluteString,
                                                              key2: "music_image_local_url") { saved, error in
                                if saved == true {
                                    DispatchQueue.main.async {
                                        self.view.layoutIfNeeded()
                                        self.consTop.constant = -120
                                        
                                        UIView.animate(withDuration: 0.5, animations: {
                                             self.view.layoutIfNeeded()
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
            }
        }
    }
    
    private func downloadMusic(current: CommonAudioList) {
        
        let music_id = "\(current.internalIdentifier ?? 0)"
        var isDownloadContinue = true
        
        if let oldDown = self.arrOfDownloads.first(where: {$0.music_id == music_id}) {
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
                            if Float(progress) < 0.8 {
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
                                                                  key: "music_file",
                                                                  music_local_url: location.absoluteString,
                                                                  key2: "music_local_url") { saved, error in
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
}

extension ExploreSoundListVC: GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.HIDE_CUSTOM_LOADER()
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.HIDE_CUSTOM_LOADER()
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        
        let vc: MusicVC = MusicVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        vc.audioVM = self.audioVM
        vc.currentSongIndex = self.currentSongIndex
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
