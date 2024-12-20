//
//  ExploreDetailsVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 18/10/23.
//

import UIKit
import ExpandableLabel

class ExploreDetailsVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consTop: NSLayoutConstraint!
    @IBOutlet weak var vwProgress: UIProgressView!
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwDec: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDecs: AppExpandableLabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    // MARK: - VARIABLES
    
    var homeVM = HomeViewModel()
    var downloader = MusicDownloader()
    var audioVM = AudioViewModel()
    var arrOfDownloads = [LocalMusicModel]()
    var isDownloadProgress = false
    var currentSongIndex = 0
    
    var isExpanded = false
    var isFromViewAll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.homeVM.arrOfAudioList.removeAll()
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: NewMusicListTVC.self)
        self.tblMain.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMain.reloadData()
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        self.dataBind()
    }
    
    func dataBind() {
        if !self.isFromViewAll {
            self.lblTitle.text = self.homeVM.currentSubCategory?.title ?? ""
            self.lblTitle2.text = self.homeVM.currentSubCategory?.title ?? ""
            self.lblDecs.setupLabel()
            self.lblDecs.collapsed = !self.isExpanded
            self.lblDecs.text = self.homeVM.currentSubCategory?.info ?? ""
            self.lblDecs.delegate = self
            self.lblSubTitle.text = self.homeVM.currentCategory?.title ?? ""
            GeneralUtility().setImage(imgView: self.imgMain, imgPath: self.homeVM.currentSubCategory?.image ?? "")
            
            if (self.homeVM.currentSubCategory?.info ?? "") == "" {
                self.vwDec.isHidden = true
            }
            
        } else {
            self.btnFilter.isHidden = true
            self.lblSubTitle.isHidden = true
            self.lblTitle.text = self.homeVM.homeDynamic?.name
            self.lblDecs.setupLabel()
            self.lblDecs.collapsed = !self.isExpanded
            self.lblDecs.text = self.homeVM.homeDynamic?.description == "" ? self.homeVM.homeDynamic?.name : self.homeVM.homeDynamic?.description ?? ""
            self.lblDecs.delegate = self
            GeneralUtility().setImage(imgView: self.imgMain, imgPath: self.homeVM.homeDynamic?.image ?? "")
            self.lblTitle2.text = self.lblTitle.text
        }
        
        self.getAudioList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    func fetchDownloadedData() {
        CommonCDFunctions.getProductInfoFromData { respose, errorr, count in
            print("respose", respose)
            self.arrOfDownloads.removeAll()
            respose.forEach { down in
                if (down.music_file != nil && down.music_image != nil) {
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
                                                               defaultBGMusic: down.backgrounds as? [BackgroundsList] ?? []))
                }
            }
            
            var index = 0
            for it in self.homeVM.arrOfAudioList {
                self.arrOfDownloads.forEach { item in
                    if it.internalIdentifier == Int(item.music_id) && (item.music_file != nil && item.music_image != nil) {
                        self.homeVM.arrOfAudioList[index].isDownloaded = true
                    }
                }
                index += 1
            }
            self.tblMain.reloadData()
        }
    }
    
    func getAudioList() {
        self.homeVM.getAudioList { _ in
            self.tblMain.restore()
            self.tblMain.reloadData()
            if self.homeVM.arrOfAudioList.count == 0 {
                self.tblMain.setEmptyMessage("No Content Has Been Added Here Yet")
            }
            
            self.fetchDownloadedData()
            
        } failure: { errorResponse in
            
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        popupVC?.height = 350
        popupVC?.presentDuration = 0.5
        popupVC?.audioVM = self.audioVM
        popupVC?.dismissDuration = 0.5
        popupVC?.topCornerRadius = 16
        popupVC?.submitted = { model in
            self.audioVM = model
            self.homeVM.currentFilterType = model.currentFilterType
            self.homeVM.arrOfAudioList.removeAll()
            self.setupUI()
        }
        DispatchQueue.main.async {
            self.present(popupVC!, animated: true, completion: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblMain {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if self.homeVM.arrOfAudioList.count == 0 {
                        self.consHeight.constant = 100
                    } else {
                        self.consHeight.constant = newSize.height
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: - Tableview Methods

extension ExploreDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeVM.arrOfAudioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "NewMusicListTVC") as? NewMusicListTVC else { return UITableViewCell() }
        
        let current = self.homeVM.arrOfAudioList[indexPath.row]
        
        cell.lblTitle.text = current.title ?? ""
        cell.isCount1 = self.homeVM.arrOfAudioList.count == 1
        
        let ddd = current.audioDuration?.doubleValue ?? 0
        cell.lblSub.text = TimeInterval(ddd).formatDuration()
        
        GeneralUtility().setImage(imgView: cell.img, imgPath: current.image ?? "")
        
        cell.isUnFav = (current.isLiked ?? 0) == 1
        
        if current.forSTr == "premium" && !appDelegate.isPlanPurchased {
            cell.vwPremius.isHidden = false
        } else {
            cell.vwPremius.isHidden = true
        }
        
        cell.progress.isHidden = true
        cell.imgPlayed.isHidden = true
        if appDelegate.isPlanPurchased{
            cell.progress.isHidden = !(current.audioProgress ?? "" != "")
            if let currentTime = current.audioProgress, let duration = current.audioDuration {
                let progress = (Float(currentTime) ?? 0.0) / (Float(duration) ?? 0.0)
                cell.progress.tintColor = progress <= 1 ? hexStringToUIColor(hex: "#7884E0") : hexStringToUIColor(hex: "#838383")
                cell.imgPlayed.isHidden = progress <= 1
                cell.progress.setProgress(Float(progress), animated: true)
            }
        }
       
        cell.isPined = ((current.pin_date ?? "") != "")
        
        cell.indexTapped = { ind in
            if ind == 2 {
                self.homeVM.pinAudio(audio_id: "\(current.internalIdentifier ?? 0)") { _ in
                    self.homeVM.limit = 10
                    self.homeVM.offset = 0
                    self.homeVM.haseMoreData = false
                    self.homeVM.isAPICalling = false
                    self.getAudioList()
                } failure: { errorResponse in
                    
                }
                
            } else if ind == 1 {
                self.homeVM.addOrRemoveLike(audio_id: "\(current.internalIdentifier ?? 0)") { _ in
                    self.homeVM.limit = 10
                    self.homeVM.offset = 0
                    self.homeVM.haseMoreData = false
                    self.homeVM.isAPICalling = false
                    self.getAudioList()
                } failure: { error in
                    
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
                } else {
                    if current.isDownloaded == true {
                        GeneralUtility().showErrorMessage(message: "This music '\(current.title ?? "")' already downloaded in your account.")
                        
                    } else if self.isDownloadProgress {
                        GeneralUtility().showErrorMessage(message: "Downloading is in progresss, Please wait.")
                        
                    } else {
                        self.downloadTapped(current: current)
                    }
                }
            }
        }
        
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.homeVM.arrOfAudioList[indexPath.row].forSTr == "premium" && !appDelegate.isPlanPurchased {
            
            let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
            let audioVM = AudioViewModel()
            vc.currentSong = self.homeVM.arrOfAudioList[indexPath.row]
            audioVM.arrOfAudioList = self.homeVM.arrOfAudioList
            vc.audioVM = audioVM
            vc.likedTapped = { like in
                self.homeVM.arrOfAudioList[indexPath.row].isLiked = like
            }
            vc.currentSongIndex = indexPath.row
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

// MARK: - Download Music

extension ExploreDetailsVC {
    
    func downloadTapped(current: CommonAudioList) {
        
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
        
        DispatchQueue.main.async {
            CommonCDFunctions.CheckandSavePrododuct(currentProduct: current) { saved, error in
                if saved == true {
                    self.downloadMusic(current: current)
                }
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
                                        if URL(string: current.femaleAudioStr ?? "") != nil {
                                            self.downloadFemaleMusic(current: current)
                                        } else {
                                            self.downloadImage(current: current)
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
}

extension ExploreDetailsVC: ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        self.view.layoutIfNeeded()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        self.isExpanded = true
        self.lblDecs.collapsed = !self.isExpanded
        self.view.layoutIfNeeded()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.view.layoutIfNeeded()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        self.isExpanded = false
        self.lblDecs.collapsed = !self.isExpanded
        self.view.layoutIfNeeded()
    }
}
