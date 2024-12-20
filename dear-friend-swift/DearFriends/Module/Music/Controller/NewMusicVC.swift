//
//  NewMusicVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 24/10/23.
//

import UIKit
import MSCircularSlider
import GoogleMobileAds
import AVFoundation
import MediaPlayer
import PopMenu
import MarqueeLabel
import SDWebImage

class NewMusicVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consThumbHeight: NSLayoutConstraint!
    @IBOutlet weak var vwSpace: UIView!
//    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRepeat2: UIButton!
    @IBOutlet weak var vwRepeat2: UIView!
    @IBOutlet weak var vwRepeat: UIView!
    @IBOutlet weak var acti2: UIActivityIndicatorView!
    @IBOutlet weak var stackMore: UIStackView!
    @IBOutlet weak var stackControls: UIStackView!
    @IBOutlet weak var acti: UIActivityIndicatorView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var vwSlider: UISlider!
    @IBOutlet weak var vwBanner: UIView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblNarrated: UILabel!
    @IBOutlet weak var btnCat: UIButton!
    @IBOutlet weak var lblName: MarqueeLabel!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var imgThumb: UIImageView!
    
    // MARK: - VARIABLES
    
    var bannerView: GADBannerView!
    var audioVM = AudioViewModel()
    var observer: Any?
    var arrOFTitle = [String]()
    var currentSongIndex = 0
    var songs: [URL] = []
    var songsForBG: [URL] = []
    var timer = Timer()
    var currentSong: CommonAudioList?
    var currentRepeatMode: CurrentRepeatMode = .None
    
    var backGroundPlayer: AVPlayer?
    var isReadyForPlay = false
    var currentBG: BackgroundsList?
    var isUserTapped = false
    var isNextTapped = false
    
    var isFromDownload = false
    var arrOfDownloads = [LocalMusicModel]()
    var currentDownload: LocalMusicModel?
    var arrDownloadedBGAudio = [BackgroundsList]()
    
    var genderSelected = 0
    var backgrondSelec = -1
    
    var interstitial: GADInterstitialAd?
    var likedTapped: intCloser?
    
    var isTimeUpAndSongOver = false
    var isFromCustom = false
    var isPlayable = false
    var isPreviousTapped = false
    var isFromFeedback = false
    var controller: PopMenuViewController?
    
    /// New Player Related
    var durationId: UInt?
    var bufferId: UInt?
    var playingStatusId: UInt?
    var queueId: UInt?
    var elapsedId: UInt?
    
    var newplayer = AudioPlayer()
    var homeVM = HomeViewModel()
    var strShareURL : String = ""
    var isHomePage : Bool = false
    var strHomeTitle : String = ""
    var strHomeImage : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        self.setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromFeedback {
            self.newplayer.resume()
            self.backGroundPlayer?.play()
        }
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.btnPlay.setBackgroundImage(UIImage(named: "ic_music_play"), for: .normal)
        self.btnPlay.setBackgroundImage(UIImage(named: "ic_pause_new"), for: .selected)
        
        self.btnLike.setImage(UIImage(named: "ic_like"), for: .normal)
        self.btnLike.setImage(UIImage(named: "ic_liked"), for: .selected)
        self.btnLike.isSelected = false
        
        if (self.currentSong?.isLiked ?? 0) == 1 {
            self.btnLike.isSelected = true
        }
        isFromFeedback = false
        self.dataBind(isForTimer: false)
        
        if !appDelegate.isPlanPurchased && !self.isFromDownload {
            self.setupAd()
            self.setupFullAD { success in
                if success {
                    if let topVc = UIApplication.topViewController2(), topVc is NewMusicVC {
                        self.showAD { success in
                            if success {
                                self.initPlayer()
                            }
                        }
                    }
                }
            }
        } else {
            self.initPlayer()
            let songURL = self.songs[self.currentSongIndex]
            self.managePlayerBeforePlay(destinationUrl: songURL)
            var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
            if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
                currentTime = 0
            }
            
            self.lblCurrentTime.text = formatTime(currentTime)
            self.vwSlider.setValue(Float(currentTime), animated: false)
            self.vwSlider.value = Float(currentTime)
            self.newplayer.seek(to: currentTime)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: currentTime)
        }
        
        CurrentUser.shared.arrOfDownloadedBGAudios = CurrentUser.shared.arrOfDownloadedBGAudios.uniqued()
        
        if self.isFromDownload {
            self.btnLike.isHidden = true
            self.vwRepeat.isHidden = true
            self.vwRepeat2.isHidden = false
            self.btnFeedBack.isHidden = true
            for it in arrDownloadedBGAudio {
                if let url = URL(string: it.file ?? "") {
                    self.songsForBG.append(url)
                }
            }
            
        } else {
            self.songsForBG.removeAll()
            for it in currentSong?.backgrounds ?? [] {
                if let url = URL(string: it.file ?? "") {
                    self.songsForBG.append(url)
                }
            }
           /* if CurrentUser.shared.arrOfDownloadedBGAudios.count == CurrentUser.shared.arrOfBGAudios.count {
                for it in CurrentUser.shared.arrOfDownloadedBGAudios {
                    if let url = URL(string: it.file ?? "") {
                        self.songsForBG.append(url)
                    }
                }
            } else {
                for it in CurrentUser.shared.arrOfBGAudios {
                    if let url = URL(string: it.file ?? "") {
                        self.songsForBG.append(url)
                    }
                }
            }*/
        }
        
        self.newplayer.delegate = self
        self.vwSlider.isContinuous = false
        
        self.updateThumb()
    }
    
    func updateThumb() {
  
        self.consThumbHeight.constant = manageWidth(size: 330)
        self.imgThumb.layoutIfNeeded()
        self.imgThumb.layer.cornerRadius = self.imgThumb.frame.size.height / 2
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        print("setupNowPlaying")
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
        
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.lblName.text ?? ""
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.vwSlider.maximumValue
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
//        nowPlayingInfo[MPMediaItemPropertyArtist] = self.lblNarrated.text?.replace(strGuidedBy, withString: "") ?? "Your Dear Friend"
        nowPlayingInfo[MPMediaItemPropertyArtist] = self.btnCat.titleLabel?.text ?? "Your Dear Friend"
        
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = self.lblTitle.text ?? ""
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        
        if self.isFromDownload {
            
            if let dtaa = self.currentDownload?.music_image {
                let image = UIImage(data: dtaa)
                let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100), requestHandler: { (size) -> UIImage in
                    return (image!)
                })
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
            }
            
        } else {
            if let url = URL.init(string: self.currentSong?.image ?? "") {
                DispatchQueue.main.async {
                    SDWebImageManager.shared.loadImage(with: url, options: [.preloadAllFrames], progress: nil) { (image, data, error, cacheType, finished, imageURL) in
                        
                        if let image = image {
                            let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100), requestHandler: { (size) -> UIImage in
                                return (image)
                            })
                            
                            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
                            
                        } else {
//                            print("error", error)
                        }
                    }
                }
            }
        }
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
        
        self.setupRemoteCommandCenter()
    }
    
    func setupRemoteCommandCenter() {
        print("setupRemoteCommandCenter")
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            self.timer.invalidate()
            self.updateCurrentTimeLabel()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.updateCurrentTimeLabel()
            })
            self.newplayer.resume()
            self.backGroundPlayer?.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.timer.invalidate()
            self.newplayer.pause()
            self.backGroundPlayer?.pause()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget(
            self, action:#selector(changePlaybackPositionCommand(_:)))
    }
    
    @objc func changePlaybackPositionCommand(_ event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        let time = event.positionTime
        print("time", time)
        self.timer.invalidate()
        self.newplayer.seek(to: time)
        self.updateCurrentTimeLabel()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateCurrentTimeLabel()
        })
        self.vwSlider.value = Float(time)
        return MPRemoteCommandHandlerStatus.success
    }
    
//    func managePlayerBuffer() {
//        self.bufferId = SAPlayer.Updates.StreamingBuffer.subscribe{ [weak self] buffer in
//            guard let self = self else { return }
//            
//            print("Buffer", buffer.bufferingProgress)
//            self.progress.isHidden = true
//            self.acti.startAnimating()
//
//            self.isPlayable = buffer.isReadyForPlaying
//            
//            if self.isPlayable {
//                self.acti.stopAnimating()
//            }
//            
//            if self.isPlayable && self.isUserTapped == false {
//                SAPlayer.shared.play()
//            }
//        }
//    }
//    
//    func manageDuration() {
//        durationId = SAPlayer.Updates.Duration.subscribe { [weak self] (duration) in
//            guard let self = self else { return }
//            self.lblEndTime.text = TimeInterval(duration).formatDuration(isForMusic: true)
//        }
//    }
//    
//    func manageSeconds() {
//        self.elapsedId = SAPlayer.Updates.ElapsedTime.subscribe({ ElapsedTime in
//            print("ElapsedTime", ElapsedTime)
//            self.updateCurrentTimeLabel()
//        })
//    }
//    
//    func managePlayStatus() {
//        playingStatusId = SAPlayer.Updates.PlayingStatus.subscribe2({ playing in
//            print("playing", playing)
//            switch playing {
//            case .playing:
//                self.isPlayable = true
//                self.btnPlay.isSelected = true
//                return
//            case .paused:
//                self.isPlayable = true
//                self.btnPlay.isSelected = false
//                return
//            case .buffering:
//                self.isPlayable = false
//                self.btnPlay.isSelected = false
//                self.acti.startAnimating()
//                return
//            case .ended:
//                if self.currentRepeatMode == .SingleRepeat {
//                    
//                }
//                return
//            @unknown default:
//                print("")
//            }
//        })
//    }
    
    func manageCustomAudioView() {
        self.btnBG.isHidden = true
        self.btnLike.isHidden = true
        self.vwRepeat.isHidden = true
        self.btnMore.isHidden = true
        self.vwRepeat2.isHidden = false
    }
    
    func setupFullAD(success: @escaping (Bool) -> Void) {
//#if DEBUG
//        return
//#endif
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Constant.INTERAD,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                success(false)
                return
            }
            self.interstitial = ad
            success(true)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MarqueeLabel.controllerViewDidAppear(self)
    }
    
    func dataBind(isForTimer: Bool = true) {
        if let current = self.currentSong {
            self.lblTitle.text = current.category?.title ?? ""
            
            self.lblName.text = current.title ?? ""
            self.btnCat.setTitle(current.subCategory?.title ?? "", for: .normal)
            self.btnBG.isHidden = current.is_background_audio == strNo || (isFromDownload ? self.arrDownloadedBGAudio.count == 0 : current.backgrounds?.count == 0 || self.currentSong?.backgrounds?.count == nil) || self.isHomePage
            self.btnMore.isHidden = (current.file == "" || current.femaleAudioStr == "")
            self.lblNarrated.isHidden = current.narratedBy == ""
            
            self.btnCat.isHidden = false
            if self.isHomePage && self.strHomeTitle != ""{
                self.lblTitle.text = self.strHomeTitle
                self.btnCat.isHidden = true
            }
            
            if (current.narratedBy ?? "") != "" {
                self.lblNarrated.text = "\(strGuidedBy)\(current.narratedBy ?? "")"
            }
            if self.isFromCustom {
                self.imgThumb.image = UIImage(named: "ic_custom_place")
                
            } else {
                if self.strHomeImage != ""{
                    GeneralUtility().setImage(imgView: self.imgThumb, imgPath: self.strHomeImage)
                }else{
                    GeneralUtility().setImage(imgView: self.imgThumb, imgPath: current.image ?? "")
                }
                
            }
            
            if self.genderSelected == 0 {
                self.vwSlider.maximumValue = Float(self.currentSong?.audioDuration ?? "") ?? 0
            } else {
                self.vwSlider.maximumValue = Float(self.currentSong?.female_audio_duration ?? "") ?? 0
            }
            self.lblEndTime.text = TimeInterval(self.vwSlider.maximumValue).formatDuration(isForMusic: true)
            
            if isForTimer {
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.updateCurrentTimeLabel()
                })
            }
 
            self.btnBG.isHidden = current.is_background_audio == strNo || (isFromDownload ? self.arrDownloadedBGAudio.count == 0 : current.backgrounds?.count == 0 || self.currentSong?.backgrounds?.count == nil)
          

            self.btnMore.isHidden = (current.file == "" || current.femaleAudioStr == "")
            self.lblNarrated.isHidden = current.narratedBy == ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
    }
    
    func showAD(success: @escaping (Bool) -> Void) {
        if self.interstitial != nil {
            self.interstitial?.fullScreenContentDelegate = self
            self.interstitial?.present(fromRootViewController: self)
            success(true)
        } else {
            print("Ad wasn't ready")
            success(false)
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.audioPlayed(toBack: true)
        self.backGroundPlayer?.pause()
        self.backGroundPlayer = nil
        self.backgrondSelec = -1
        self.newplayer.stop()
        self.timer.invalidate()
        self.clearLockScreenInfo()
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.showOptionsOfForFemaleMale(sender: sender)
    }
    
    @IBAction func btnBackgroundTapped(_ sender: UIButton) {
        self.showOptionsOfForBackgroundNew(sender: sender)
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        self.btnLike.isSelected = !self.btnLike.isSelected
        
        self.currentSong?.isLiked = self.btnLike.isSelected ? 1 : 0
        self.likedTapped?(self.currentSong?.isLiked ?? 0)
        
        if (self.currentSong?.internalIdentifier ?? 0) != 0 {
            self.audioVM.addOrRemoveLike(id: "\(self.currentSong?.internalIdentifier ?? 0)") { _ in
            } failure: { errorResponse in
            }
        }
    }
    
    @IBAction func btnPlayTapped(_ sender: UIButton) {
        if self.isTimeUpAndSongOver {
            self.isTimeUpAndSongOver = false
            self.newplayer.seek(to: 0)
            
        } else {
            self.isUserTapped = true
            self.btnPlay.isSelected = !self.btnPlay.isSelected
            if self.newplayer.state == .playing {
                self.timer.invalidate()
                self.newplayer.pause()
            } else {
                self.timer.invalidate()
                self.updateCurrentTimeLabel()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.updateCurrentTimeLabel()
                })
                self.newplayer.resume()
            }
            if !self.btnPlay.isSelected {
                self.backGroundPlayer?.pause()
            } else {
                self.backGroundPlayer?.play()
            }
        }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        self.audioPlayed()
        if self.currentRepeatMode == .SingleRepeat {
            self.currentRepeatMode = .AllRepeat
            self.btnRepeat.setImage(UIImage(named: "ic_music_repeat_all"), for: .normal)
            self.btnRepeat2.setImage(UIImage(named: "ic_music_repeat_all"), for: .normal)
        }
        self.nextSong()
    }
    
    @IBAction func btnPreviousTapped(_ sender: UIButton) {
        self.audioPlayed()
        if self.currentRepeatMode == .SingleRepeat {
            self.currentRepeatMode = .AllRepeat
            self.btnRepeat.setImage(UIImage(named: "ic_music_repeat_all"), for: .normal)
            self.btnRepeat2.setImage(UIImage(named: "ic_music_repeat_all"), for: .normal)
        }
        self.previousSong()
    }
    
    @IBAction func btnRepeatTapped(_ sender: UIButton) {
        if self.currentRepeatMode == .None {
            self.currentRepeatMode = .SingleRepeat
            self.btnRepeat.setImage(UIImage(named: "ic_music_repeat_1"), for: .normal)
            self.btnRepeat2.setImage(UIImage(named: "ic_music_repeat_1"), for: .normal)
            
        } else if self.currentRepeatMode == .SingleRepeat {
            self.currentRepeatMode = .AllRepeat
            self.btnRepeat.setImage(UIImage(named: "ic_music_repeat_all"), for: .normal)
            self.btnRepeat2.setImage(UIImage(named: "ic_music_repeat_all"), for: .normal)
            
        } else if self.currentRepeatMode == .AllRepeat {
            self.currentRepeatMode = .None
            self.btnRepeat.setImage(UIImage(named: "ic_music_repeat"), for: .normal)
            self.btnRepeat2.setImage(UIImage(named: "ic_music_repeat"), for: .normal)
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        print("Current sliderChanged", sender.value)
        self.newplayer.seek(to: Double(sender.value))
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: Double(sender.value))
    }
    
    @IBAction func btnFeedbackTapped(_ sender: UIButton) {
        self.showOptionsOfMenu(sender: sender)
      
    }
    
    
    @IBAction func btnTabSubCategory(_ sender: Any) {
        self.newplayer.pause()
        self.backGroundPlayer?.pause()
  
        let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        self.homeVM.currentFilterType = .none
        self.homeVM.currentAudioType = .normal
        self.homeVM.currentCategory = self.audioVM.arrOfAudioList[self.currentSongIndex].category
        self.homeVM.currentThemeCategory = self.audioVM.arrOfAudioList[self.currentSongIndex].themeCategory
        self.homeVM.currentSubCategory = self.audioVM.arrOfAudioList[self.currentSongIndex].subCategory
        vc.homeVM = self.homeVM
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

// MARK: - Music Player

extension NewMusicVC: AVAudioPlayerDelegate {
    
    func initPlayer() {
        if self.isFromDownload {
            self.songs = self.arrOfDownloads.compactMap({URL(string: $0.music_local_url)})
        } else {
            self.songs = self.audioVM.arrOfAudioList.compactMap({$0.musicURL})
        }
        self.loadSong(index: self.currentSongIndex)
    }
    
    func manageButtons() {
        if self.currentSongIndex == 0 {
            self.btnPrevious.alpha = 0.5
            self.btnPrevious.isUserInteractionEnabled = false
        } else {
            self.btnPrevious.alpha = 1
            self.btnPrevious.isUserInteractionEnabled = true
        }
        
        if self.currentSongIndex == self.songs.count - 1 {
            self.btnNext.alpha = 0.5
            self.btnNext.isUserInteractionEnabled = false
        } else {
            self.btnNext.alpha = 1
            self.btnNext.isUserInteractionEnabled = true
        }
    }
    
    func loadSong(index: Int) {
        if self.isFromCustom {
            self.manageCustomAudioView()
        }
        
        self.manageButtons()
        self.managePlayer()
        self.backGroundPlayer?.pause()
        
        self.btnBG.isHidden = self.currentSong?.is_background_audio == strNo || (isFromDownload ? self.arrDownloadedBGAudio.count == 0 : self.currentSong?.backgrounds?.count == 0 || self.currentSong?.backgrounds?.count == nil)
      
        self.btnMore.isHidden = (self.currentSong?.file == "" || self.currentSong?.femaleAudioStr == "")
        self.lblNarrated.isHidden = self.currentSong?.narratedBy == ""
        
        CurrentUser.shared.arrOfDownloadedBGAudios.forEach { model in
            model.isShow = true
        }
        
        if self.isFromDownload {
            if (self.arrOfDownloads[index].is_background_audio) == "no" {
                arrDownloadedBGAudio.forEach { model in
                    if model.title != "Music" {
                        model.isShow = false
                    }
                }
            }
            
        } else {
            if (self.currentSong?.is_background_audio ?? "") == "no" {
                CurrentUser.shared.arrOfDownloadedBGAudios.forEach { model in
                    if model.title != "Music" {
                        model.isShow = false
                    }
                }
            }
        }
    }
    
    func managePremium() {
        self.timer.invalidate()
        
        var isPremim = (self.currentSong?.forSTr ?? "") == "premium"
        if self.isFromDownload {
            isPremim = (self.arrOfDownloads[self.currentSongIndex].forStr) == "premium"
        }
        
        if isPremim && !appDelegate.isPlanPurchased {
            
            self.stackControls.alpha = 0.5
            self.stackControls.isUserInteractionEnabled = false
            self.stackMore.alpha = 0.5
            self.stackMore.isUserInteractionEnabled = false
            self.vwSlider.alpha = 0.5
            self.vwSlider.isUserInteractionEnabled = false
            
            let popupVC: CommonBottomPopupVC = CommonBottomPopupVC.instantiate(appStoryboard: .Profile)
            popupVC.height = 260
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.leftStr = "Not Yet"
            popupVC.rightStr = "Proceed To Premium"
            popupVC.titleStr = "To play this meditation, subcribe today!"
            popupVC.noTapped = {
                self.goBack(isGoingTab: true)
            }
            popupVC.yesTapped = {
                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                vc.hidesBottomBarWhenPushed = true
                vc.isFromPlayer = true
                vc.reloadView = {
                    self.setupUI()
                }
                vc.goBack = {
                    self.managePremium()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            DispatchQueue.main.async {
                self.present(popupVC, animated: true, completion: nil)
            }
            return
        }
    }
    
    func managePlayerBeforePlay(destinationUrl: URL) {
        self.newplayer.pause()
        var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
        if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased{
            currentTime = 0
        }
        self.vwSlider.setValue(Float(currentTime), animated: false)
        self.vwSlider.value = Float(currentTime)
        self.newplayer.seek(to: currentTime)
        self.setupNowPlaying()
        if self.isFromDownload {
            var finalURL = destinationUrl
            if !FileManager().fileExists(atPath: destinationUrl.path) {
                if let docURL = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first as? NSString {
                    let newPath = docURL.appendingPathComponent(destinationUrl.lastPathComponent)
                    finalURL = URL(fileURLWithPath: newPath)
                }
            }
            
            self.newplayer.play(url: finalURL, seekingTIme: currentTime)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.newplayer.seek(to: currentTime)
            }
            
            self.timer.invalidate()
            self.updateCurrentTimeLabel()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.updateCurrentTimeLabel()
            })
            if self.genderSelected == 0 {
                self.vwSlider.maximumValue = Float(self.currentDownload?.music_duration_secods ?? "") ?? 0
            } else {
                self.vwSlider.maximumValue = Float(self.currentDownload?.female_music_duration_secods ?? "") ?? 0
            }
            self.lblCurrentTime.text = "00:00"
            
            if self.currentDownload?.isForCustom == 1 {
                self.btnMore.isHidden = true
            } else {
                self.btnMore.isHidden = (self.currentDownload?.music_file == nil || self.currentDownload?.female_file == nil)
            }
            
            if arrDownloadedBGAudio.count > 0 {
                if let defaultIndex = arrDownloadedBGAudio.firstIndex(where: { $0.isDefault == 1 }), let firstBG = arrDownloadedBGAudio[safe: defaultIndex] {
                    if let bgURL = URL(string: firstBG.file ?? "") {
                        self.backgrondSelec = defaultIndex
                        self.manageBGPlayerBeforePlay(destinationUrl: bgURL)
                    }
                    print("Default background found at index \(defaultIndex)")
                } else {
                    print("No default background found")
                }
            }
            
        } else {
            self.stackControls.alpha = 0.5
            self.stackControls.isUserInteractionEnabled = false
            
            self.btnBG.alpha = 0.5
            self.btnBG.isUserInteractionEnabled = false
            
            self.btnMore.alpha = 0.5
            self.btnMore.isUserInteractionEnabled = false

            var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
            if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
                currentTime = 0
            }
            self.newplayer.play(url: destinationUrl, seekingTIme: currentTime)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.newplayer.seek(to: currentTime)
            }
            

            self.lblCurrentTime.text = formatTime(currentTime)
            self.stackControls.alpha = 1
            self.stackControls.isUserInteractionEnabled = true
            self.stackMore.alpha = 1
            self.stackMore.isUserInteractionEnabled = true
            self.vwSlider.alpha = 1
            self.vwSlider.isUserInteractionEnabled = true
            
            self.btnBG.alpha = 1
            self.btnBG.isUserInteractionEnabled = true
            
            self.btnMore.alpha = 1
            self.btnMore.isUserInteractionEnabled = true
            
            if (self.currentSong?.backgrounds?.count ?? 0) > 0 {
                if let defaultIndex = self.currentSong?.backgrounds?.firstIndex(where: { $0.isDefault == 1 }), let firstBG = self.currentSong?.backgrounds?[defaultIndex] {
                    if let bgURL = URL(string: firstBG.file ?? "") {
                        self.backgrondSelec = defaultIndex
                        self.manageBGPlayerBeforePlay(destinationUrl: bgURL)
                    }
                    print("Default background found at index \(defaultIndex)")
                } else {
                    self.backGroundPlayer?.pause()
                    self.backGroundPlayer = nil
                    self.backgrondSelec = -1
                }
            } else {
                self.backGroundPlayer?.pause()
                self.backGroundPlayer = nil
                self.backgrondSelec = -1
            }
        }
    }

    func audioPlayed(toBack: Bool = false) {
        let isPremium = (self.currentSong?.forSTr ?? "") == "premium"
        if !self.isFromCustom && !self.isFromDownload {
            if let objAudio = self.audioVM.arrOfAudioList[safe: currentSongIndex] {
                print("\(Float(ceil((self.vwSlider.value + 1)))), ", currentSongIndex)
                objAudio.audioProgress = "\(Float(ceil((self.vwSlider.value + 1))))"
                self.currentSong = objAudio
                self.audioVM.arrOfAudioList[currentSongIndex] = objAudio
            }
            if !isPremium || appDelegate.isPlanPurchased {
                self.audioVM.playMusic(audio_id: "\(self.currentSong?.internalIdentifier ?? 0)", audioProgress: "\(Float(ceil((self.vwSlider.value + 1))))") { _ in
                    if toBack {
                        self.backGroundPlayer?.pause()
                        self.goBack(isGoingTab: true)
                    }
                } failure: { error in
                    if toBack {
                        self.backGroundPlayer?.pause()
                        self.goBack(isGoingTab: true)
                    }
                }
            }
        } else {
            if toBack {
                self.backGroundPlayer?.pause()
                self.goBack(isGoingTab: true)
            }
        }
    }
    
    func managePlayer() {
        if self.isFromDownload {
            self.currentDownload = self.arrOfDownloads[self.currentSongIndex]
            self.arrDownloadedBGAudio = self.arrOfDownloads[self.currentSongIndex].defaultBGMusic
            self.btnCat.setTitle(self.currentDownload?.category, for: .normal)
            self.lblName.text = self.currentDownload?.music_title
            if (self.currentDownload?.narrated_by ?? "") != "" {
                self.lblNarrated.text = "\(strGuidedBy)\(self.currentDownload?.narrated_by ?? "")"
            }
            self.lblCurrentTime.text = "00:00"
            self.btnCat.isHidden = false
            self.lblTitle.text = self.currentDownload?.category
            if self.isHomePage && self.strHomeTitle != ""{
                self.lblTitle.text = self.strHomeTitle
                self.btnCat.isHidden = true
            }
            
            if let music_image = self.currentDownload?.music_image {
                self.imgThumb.image = UIImage(data: music_image)
            } else {
                self.imgThumb.image = UIImage(named: "ic_custom_place")
            }
            
        } else {
            self.currentSong = self.audioVM.arrOfAudioList[self.currentSongIndex]
            var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
            if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
                currentTime = 0
            }
            self.newplayer.seek(to: currentTime)
            self.dataBind()
        }
    }
   
    func prepareForNextSong() {
        if self.currentSongIndex == self.songs.count - 1 {
            if self.currentRepeatMode == .AllRepeat {
                self.currentSongIndex = 0
            }
        } else {
            if self.currentSongIndex >= (self.songs.count - 1) {
                if self.currentRepeatMode == .AllRepeat {
                    self.currentSongIndex = 0
                }
            } else {
                if self.currentRepeatMode != .SingleRepeat {
                    self.currentSongIndex += 1
                }
                print("currentSongIndex += \(currentSongIndex)")
            }
        }
    }
    
    func clearLockScreenInfo() {
        print("clearLockScreenInfo")
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.nextTrackCommand.removeTarget(nil)
        commandCenter.previousTrackCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    func nextSong() {
        self.isPreviousTapped = false
        self.clearLockScreenInfo()
        self.timer.invalidate()
        self.newplayer.pause()
        var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
        if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
            currentTime = 0
        }
        self.newplayer.seek(to: currentTime)
        self.lblCurrentTime.text = formatTime(currentTime)
//        self.prepareForNextSong()
        
        if !appDelegate.isPlanPurchased {
            self.prepareForNextSong()
            self.SHOW_CUSTOM_LOADER()
            self.setupFullAD { success in
                if success {
                    self.showAD { success in
                        self.HIDE_CUSTOM_LOADER()
                        if success {
                            self.initPlayer()
                        }
                    }
                } else {
                    self.HIDE_CUSTOM_LOADER()
                }
            }
        } else {
            self.perfomeNext()
            let songURL = self.songs[self.currentSongIndex]
            var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
            if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
                currentTime = 0
            }
            self.newplayer.seek(to: currentTime)
            self.lblCurrentTime.text = formatTime(currentTime)
            self.managePlayerBeforePlay(destinationUrl: songURL)
        }
    }
    
    func perfomeNext() {
        self.controller?.dismiss(animated: true)
        if self.currentRepeatMode == .SingleRepeat {
            var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
            if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
                currentTime = 0
            }
            self.newplayer.seek(to: currentTime)
            self.newplayer.resume()
            
        } else {
            if self.currentSongIndex == self.songs.count - 1 {
                if self.currentRepeatMode == .AllRepeat {
                    self.currentSongIndex = 0
                    self.dataBind()
                    self.initPlayer()
                } else {
                    self.isTimeUpAndSongOver = true
                }
            } else {
                if self.currentSongIndex >= (self.songs.count - 1) {
                    if self.currentRepeatMode == .AllRepeat {
                        self.currentSongIndex = 0
                    }
                } else {
                    self.currentSongIndex += 1
                    print("currentSongIndex += \(currentSongIndex)")
                }
                
                self.dataBind()
                self.initPlayer()
            }
        }
    }
    
    func previousSong() {
        self.isPreviousTapped = true
        self.timer.invalidate()
        updateCurrentTimeLabel()
        self.clearLockScreenInfo()
        self.newplayer.pause()
        self.currentSongIndex -= 1
        self.initPlayer()
        var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
        if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
            currentTime = 0
        }
        self.newplayer.seek(to: currentTime)
        self.lblCurrentTime.text = formatTime(currentTime)
        
        var isPremim = (self.currentSong?.forSTr ?? "") == "premium"
        if self.isFromDownload {
            isPremim = (self.currentDownload?.forStr) == "premium"
        }
        if isPremim && !appDelegate.isPlanPurchased {
            self.managePremium()
            
        } else {
            let songURL = self.songs[self.currentSongIndex]
            self.managePlayerBeforePlay(destinationUrl: songURL)
        }
    }
    
    // MARK: AVAudioPlayerDelegate
    
    @objc func updateCurrentTimeLabel() {
        let currentTime = self.newplayer.progress
        print("currentTime", currentTime)
        UserDefaults.standard.set("\(currentTime)", forKey: lastProgressKey)
        UserDefaults.standard.set("\(self.currentSong?.internalIdentifier ?? 0)", forKey: lastAudioIdKey)
        if Float(ceil((currentTime.rounded(toPlaces: 1)))) < self.vwSlider.maximumValue {
            self.lblCurrentTime.text = formatTime(currentTime)
        } else if Float(ceil((currentTime.rounded(toPlaces: 1)))) >= Float(ceil((self.vwSlider.maximumValue))) {
            self.audioPlayed(toBack: true)
            self.isPreviousTapped = false
            self.clearLockScreenInfo()
            self.timer.invalidate()
            var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
            if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
                currentTime = 0
            }
            self.lblCurrentTime.text = formatTime(currentTime)
            self.newplayer.seek(to: currentTime)
            self.newplayer.pause()
        } else {
            self.audioPlayed(toBack: true)
            self.isPreviousTapped = false
            self.clearLockScreenInfo()
            self.timer.invalidate()
            var currentTime =  Double(self.currentSong?.audioProgress ?? "0") ?? 0
            if currentTime >= (Double(self.currentSong?.audioDuration ?? "0") ?? 0) || !appDelegate.isPlanPurchased {
                currentTime = 0
            }
            self.lblCurrentTime.text = formatTime(currentTime)
            self.newplayer.seek(to: currentTime)
            self.newplayer.pause()
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: Double(currentTime))
                
        if self.isFromDownload {
            
            if self.genderSelected == 0 {
                self.vwSlider.maximumValue = Float(self.currentDownload?.music_duration_secods ?? "") ?? 0
            } else {
                self.vwSlider.maximumValue = Float(self.currentDownload?.female_music_duration_secods ?? "") ?? 0
            }
            
        } else {
            if self.genderSelected == 0 {
                self.vwSlider.maximumValue = Float(self.currentSong?.audioDuration ?? "") ?? 0
            } else {
                self.vwSlider.maximumValue = Float(self.currentSong?.female_audio_duration ?? "") ?? 0
            }
        }
        self.vwSlider.value = Float(ceil((currentTime.rounded(toPlaces: 1))))
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(ceil((time.truncatingRemainder(dividingBy: 60)).roundedValues(toPlaces: 1)))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - AD Methods

extension NewMusicVC: GADBannerViewDelegate {
    
    func setupAd() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.size.width, height: 70))
        bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = Constant.BANNERAD
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.vwBanner.addSubview(bannerView)
        self.vwBanner.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self.vwBanner.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: self.vwBanner,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.vwBanner.isHidden = false
        self.vwSpace.isHidden = true
        self.view.layoutIfNeeded()
        self.bannerView.alpha = 0
        self.addBannerViewToView(bannerView)
        UIView.animate(withDuration: 1, animations: {
            self.bannerView.alpha = 1
        })
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        self.vwBanner.isHidden = true
        self.vwSpace.isHidden = false
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
        self.vwBanner.isHidden = true
        self.vwSpace.isHidden = false
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}

extension NewMusicVC: GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.HIDE_CUSTOM_LOADER()
        print("Ad did fail to present full screen content. ERR :", error.localizedDescription)
        print("INDEX error", self.currentSongIndex)
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.HIDE_CUSTOM_LOADER()
        self.newplayer.pause()
        print("INDEX will", self.currentSongIndex)
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        var isPremim = (self.currentSong?.forSTr ?? "") == "premium"
        if self.isFromDownload {
            isPremim = (self.currentDownload?.forStr ?? "") == "premium"
        }
        if isPremim && !appDelegate.isPlanPurchased {
            self.managePremium()
            
        } else {
            if self.songs.count != 0 {
                let songURL = self.songs[self.currentSongIndex]
                self.managePlayerBeforePlay(destinationUrl: songURL)
            }
        }
    }
}

// MARK: - PopMenuViewControllerDelegate

extension NewMusicVC: PopMenuViewControllerDelegate, PopUpProtocol , UIPopoverPresentationControllerDelegate{
   
    func SelctMenuIndex(Index: Int, type: String) {
        if type.lowercased() == "premium" && !appDelegate.isPlanPurchased {
            
            let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            if self.backgrondSelec == Index {
                self.backGroundPlayer?.pause()
                self.backGroundPlayer = nil
                self.backgrondSelec = -1
            } else {
                self.backgrondSelec = Index
                self.backGroundPlayer?.pause()
                self.backGroundPlayer = nil

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.manageBGPlayerBeforePlay(destinationUrl: self.songsForBG[Index])
                }
            }
        }
       
    }
    
    func showOptionsOfForBackgroundNew(sender: UIButton){
        if CurrentUser.shared.arrOfDownloadedBGAudios.count == 0 && self.isFromDownload {
            GeneralUtility().showErrorMessage(message: "Background music not downloaded")
            return
        }
        
        self.arrOFTitle.removeAll()
        var arrType : [String] = []
        if self.isFromDownload {
            self.arrOFTitle = arrDownloadedBGAudio.filter({$0.isShow}).compactMap({$0.title})
            arrType = arrDownloadedBGAudio.filter({$0.isShow}).compactMap({$0.type})
        } else {
            self.arrOFTitle = currentSong?.backgrounds?.compactMap({$0.title}) ?? []
            arrType = currentSong?.backgrounds?.compactMap({$0.type}) ?? []
        }
        
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        let popVC = storyboard.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        popVC.arr_MenuList = self.arrOFTitle
        popVC.arr_TypeList = arrType
        popVC.selectIndex = self.backgrondSelec
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self

        let popOverVC = popVC.popoverPresentationController
        popOverVC?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popOverVC?.delegate = self
        popOverVC?.backgroundColor = hexStringToUIColor(hex: "#212159")
        popOverVC?.sourceView = sender
        popOverVC?.sourceRect = CGRect(x: -manageWidth(size: 60.0), y: (CGFloat(self.arrOFTitle.count) * manageWidth(size: 50.0))/2, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: manageWidth(size: 130.0), height: CGFloat(self.arrOFTitle.count) * manageWidth(size: 50.0))

        popVC.modalTransitionStyle = .crossDissolve
        self.present(popVC, animated: true)

        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    func showOptionsOfForBackground(sender: UIView) {
        
        if CurrentUser.shared.arrOfDownloadedBGAudios.count == 0 && self.isFromDownload {
            GeneralUtility().showErrorMessage(message: "Background music not downloaded")
            return
        }
        
        self.arrOFTitle.removeAll()
        if self.isFromDownload {
            self.arrOFTitle = arrDownloadedBGAudio.filter({$0.isShow}).compactMap({$0.title})
        } else {
            self.arrOFTitle = currentSong?.backgrounds?.compactMap({$0.title}) ?? []
        }
        
//        self.arrOFTitle = CurrentUser.shared.arrOfDownloadedBGAudios.filter({$0.isShow}).compactMap({$0.title})
        var arrays: [PopMenuAction] = self.arrOFTitle.map({PopMenuDefaultAction(title: $0, color: UIColor.white)})
        if self.backgrondSelec != -1 && self.arrOFTitle.count != 0 {
            
//            let action = PopMenuDefaultAction(title: self.arrOFTitle[self.backgrondSelec], image: UIImage(named: "ic_selected_check"), color: hexStringToUIColor(hex: "#776ADA"), highlighted: true, backgroundColor2: hexStringToUIColor(hex: "#212159"))

            let action = PopMenuDefaultAction(title: self.arrOFTitle[self.backgrondSelec], image: UIImage(named: "ic_selected_check"), color: hexStringToUIColor(hex: "#212159"))
            action.highlightActionView(true)
            action.tintColor = .white
            action.view.backgroundColor = .red
//            action.back
            
            arrays[self.backgrondSelec] = action
        }
        
        self.controller = PopMenuViewController(sourceView: sender, actions: arrays)
        // Customize appearance
        self.controller?.contentView.backgroundColor = hexStringToUIColor(hex: "#776ADA")
        self.controller?.appearance.popMenuFont = Font(.installed(.Medium), size: .standard(.S14)).instance
        self.controller?.accessibilityLabel = "Background"
        
        self.controller?.appearance.popMenuColor.actionColor = .tint(.clear)
        self.controller?.appearance.popMenuBackgroundStyle = .dimmed(color: UIColor.black, opacity: 0.5)
        self.controller?.appearance.popMenuColor.backgroundColor = PopMenuActionBackgroundColor.solid(fill: hexStringToUIColor(hex: "#776ADA"))
        self.controller?.appearance.popMenuCornerRadius = 10
        self.controller?.appearance.popMenuItemSeparator = .fill(hexStringToUIColor(hex: "#675BC8"), height: 1)
        
        // Configure options
        self.controller?.shouldDismissOnSelection = true
        self.controller?.delegate = self
        
        self.controller?.didDismiss = { selected in
            print("Menu dismissed: \(selected ? "selected item" : "no selection")")
        }
        
        // Present menu controller
        UIApplication.topViewController2()?.present(self.controller!, animated: true, completion: nil)
    }
    
    
    func showOptionsOfMenu(sender: UIView) {
        var arrOFTitle = [PopMenuArray]()
        arrOFTitle.append(PopMenuArray(title: "Meditation Feedback", image: "icon_feedback"))
        arrOFTitle.append(PopMenuArray(title: "Share", image: "icon_share"))

        
        let arrays: [PopMenuAction] = arrOFTitle.map({PopMenuDefaultAction(title: $0.title, image: UIImage(named: $0.image), color: UIColor.white)})
        
        let controller = PopMenuViewController(sourceView: sender, actions: arrays)
        // Customize appearance
        controller.contentView.backgroundColor = hexStringToUIColor(hex: "#776ADA")
        controller.appearance.popMenuFont = Font(.installed(.Medium), size: .standard(.S14)).instance
        controller.accessibilityLabel = "Menu"

        controller.appearance.popMenuColor.actionColor = .tint(.clear)
        controller.appearance.popMenuBackgroundStyle = .dimmed(color: UIColor.black, opacity: 0.5)
        controller.appearance.popMenuColor.backgroundColor = PopMenuActionBackgroundColor.solid(fill: hexStringToUIColor(hex: "#776ADA"))
        controller.appearance.popMenuCornerRadius = 10
        controller.appearance.popMenuItemSeparator = .fill(hexStringToUIColor(hex: "#675BC8"), height: 1)
        
        // Configure options
        controller.shouldDismissOnSelection = true
        controller.delegate = self
        
        controller.didDismiss = { selected in
            print("Menu dismissed: \(selected ? "selected item" : "no selection")")
        }
        
        // Present menu controller
        UIApplication.topViewController2()?.present(controller, animated: true, completion: nil)
    }
    
    func showOptionsOfForFemaleMale(sender: UIView) {
        
        self.arrOFTitle.removeAll()
        self.arrOFTitle.append("Male")
        var arrays: [PopMenuAction] = []
        
        if self.genderSelected == 0 {
            
//            let action = PopMenuDefaultAction(title: "Male", image: UIImage(named: "ic_selected_check"), color: hexStringToUIColor(hex: "#776ADA"), highlighted: true, backgroundColor2: hexStringToUIColor(hex: "#212159"))
            let action = PopMenuDefaultAction(title: "Male", image: UIImage(named: "ic_selected_check"), color: hexStringToUIColor(hex: "#776ADA"))

            action.highlightActionView(true)
            action.tintColor = .white
            arrays.append(action)
            
        } else {
            arrays.append(PopMenuDefaultAction(title: "Male", image: self.genderSelected == 0 ? UIImage(named: "ic_selected_check") : UIImage(named: ""), color: .white))
        }
        
        if self.isFromDownload {
            if (self.currentDownload?.female_music_local_url ?? "") != "" {
                self.arrOFTitle.append("Female")
                arrays.append(PopMenuDefaultAction(title: "Female", image: self.genderSelected == 1 ? UIImage(named: "ic_selected_check") : UIImage(named: ""), color: .white))
            }
        } else {
            
            if (self.currentSong?.femaleAudioStr ?? "") != "" {
                self.arrOFTitle.append("Female")
                
                if self.genderSelected == 1 {
                    let action = PopMenuDefaultAction(title: "Female", image: UIImage(named: "ic_selected_check"), color: hexStringToUIColor(hex: "#776ADA"))
                    action.highlightActionView(true)
                    action.tintColor = .white
                    arrays.append(action)
                    
                } else {
                    arrays.append(PopMenuDefaultAction(title: "Female", image: self.genderSelected == 1 ? UIImage(named: "ic_selected_check") : UIImage(named: ""), color: .white))
                }
            }
        }
        
        self.controller = PopMenuViewController(sourceView: sender, actions: arrays)
        // Customize appearance
        self.controller?.contentView.backgroundColor = hexStringToUIColor(hex: "#776ADA")
        self.controller?.appearance.popMenuFont = Font(.installed(.Medium), size: .standard(.S14)).instance
        self.controller?.accessibilityLabel = "Gender"
        
        self.controller?.appearance.popMenuColor.actionColor = .tint(.clear)
        self.controller?.appearance.popMenuBackgroundStyle = .dimmed(color: UIColor.black, opacity: 0.5)
        self.controller?.appearance.popMenuColor.backgroundColor = PopMenuActionBackgroundColor.solid(fill: hexStringToUIColor(hex: "#776ADA"))
        self.controller?.appearance.popMenuCornerRadius = 10
        self.controller?.appearance.popMenuItemSeparator = .fill(hexStringToUIColor(hex: "#675BC8"), height: 1)
        
        // Configure options
        self.controller?.shouldDismissOnSelection = true
        self.controller?.delegate = self
        
        self.controller?.didDismiss = { selected in
            print("Menu dismissed: \(selected ? "selected item" : "no selection")")
        }
        
        // Present menu controller
        UIApplication.topViewController2()?.present(self.controller!, animated: true, completion: nil)
    }
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        print("index tapped", index)
        popMenuViewController.dismiss(animated: true)
        if (popMenuViewController.accessibilityLabel ?? "") == "Gender" {
            if self.genderSelected != index {
                self.newplayer.pause()
                self.genderSelected = index
                self.backGroundPlayer?.pause()
                self.backGroundPlayer = nil
                self.backgrondSelec = -1
                if index == 0 {
                    if !self.isFromDownload {
                        if let url = self.currentSong?.musicURL {
                            self.songs[self.currentSongIndex] = url
                            self.loadSong(index: self.currentSongIndex)
                            let songURL = self.songs[self.currentSongIndex]
                            self.managePlayerBeforePlay(destinationUrl: songURL)
                        }
                    } else {
                        if let url = URL(string: self.currentDownload?.music_local_url ?? "") {
                            self.songs[self.currentSongIndex] = url
                            self.loadSong(index: self.currentSongIndex)
                            let songURL = self.songs[self.currentSongIndex]
                            self.managePlayerBeforePlay(destinationUrl: songURL)
                        }
                    }
                } else if index == 1 {
                    if !self.isFromDownload {
                        if let url = self.currentSong?.feMalemusicURL {
                            self.songs[self.currentSongIndex] = url
                            self.loadSong(index: self.currentSongIndex)
                            let songURL = self.songs[self.currentSongIndex]
                            self.managePlayerBeforePlay(destinationUrl: songURL)
                        }
                    } else {
                        if let url = URL(string: self.currentDownload?.female_music_local_url ?? "") {
                            self.songs[self.currentSongIndex] = url
                            self.loadSong(index: self.currentSongIndex)
                            let songURL = self.songs[self.currentSongIndex]
                            self.managePlayerBeforePlay(destinationUrl: songURL)
                        }
                    }
                }
            }
        } else if (popMenuViewController.accessibilityLabel ?? "") == "Menu" {
            if index == 0{
                //FEED BACK
                self.newplayer.pause()
                self.backGroundPlayer?.pause()
                isFromFeedback = true
                let vc: FeedbackVC = FeedbackVC.instantiate(appStoryboard: .Explore)
                vc.catId = self.currentSong?.categoryId
                vc.subCatId = self.currentSong?.subCategoryId
                vc.meditationId = self.currentSong?.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if index == 1{
            
                //Enter link to your app here
                self.strShareURL = "https://apps.apple.com/in/app/id\(GlobalConstants.appStoreId)"

//                let activityVC = UIActivityViewController(activityItems: [self], applicationActivities: nil)
////                activityVC.excludedActivityTypes = []
//                
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    activityVC.popoverPresentationController?.sourceView = self.view
//                    activityVC.popoverPresentationController?.sourceRect = self.btnFeedBack.frame
//                }
//                self.present(activityVC, animated: true, completion: nil)
//                
//                
//                
//                
                
                let someText:String = "Hey, I think you’ll like this, you can try the app for free for 7 days \n\n"
               let objectsToShare:URL = URL(string: strShareURL)!
               let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
               let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view
                if UIDevice.current.userInterfaceIdiom == .pad {
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    activityViewController.popoverPresentationController?.sourceRect = self.btnFeedBack.frame
                }
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]

               self.present(activityViewController, animated: true, completion: nil)

            }
        }
        else {
            if self.backgrondSelec == index {
                self.backGroundPlayer?.pause()
                self.backGroundPlayer = nil
                self.backgrondSelec = -1
            } else {
                self.backgrondSelec = index
                self.manageBGPlayerBeforePlay(destinationUrl: self.songsForBG[index])
            }
        }
    }
    
    // The placeholder the share sheet will use while metadata loads
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        if let displayName = Bundle.main.displayAppName {
            return displayName
        }
        return "Dear Friends"
    }
    
    // The item we want the user to act on.
    // In this case, it's the URL to the Wikipedia page
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        return URL(string: strShareURL)
    }
}

extension Bundle {
    var displayAppName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}


extension NewMusicVC {
    
    func manageBGPlayerBeforePlay(destinationUrl: URL) {
        
        var finalURL = destinationUrl
        if !FileManager().fileExists(atPath: destinationUrl.path) {
            if let docURL = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first as? NSString {
                let newPath = docURL.appendingPathComponent(destinationUrl.lastPathComponent)
                finalURL = URL(fileURLWithPath: newPath)
            }
        }
        
        self.removeObserver()
        self.backGroundPlayer = nil
        let playerItem2 = AVPlayerItem(url: finalURL)
        self.backGroundPlayer = AVPlayer(playerItem: playerItem2)
        self.backGroundPlayer?.volume = 0.8
        self.backGroundPlayer?.playImmediately(atRate: 1.0)
        self.loopVideo(videoPlayer: (self.backGroundPlayer)!)
        self.newplayer.resume()

    }
    
    
    func loopVideo(videoPlayer: AVPlayer) {
       
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    

    func removeObserver() {
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    }
}

public enum Result<T> {
    case success(T)
    case failure
}

class CacheManager {
    
    static let shared = CacheManager()
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {
        let file = directoryFor(stringUrl: stringUrl)
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(Result.success(file))
            return
        }
        
        DispatchQueue.global().async {
            
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)
                
                DispatchQueue.main.async {
                    completionHandler(Result.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(Result.failure)
                }
            }
        }
    }
    
    private func directoryFor(stringUrl: String) -> URL {
        let fileURL = URL(string: stringUrl)!.lastPathComponent
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        
        return file
    }
}

extension TimeInterval {
    func formatDuration(isForMusic: Bool = false) -> String {
        let hours = Int(self / 3600)
        let minutes = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
        let remainingSeconds = Int(self.truncatingRemainder(dividingBy: 60))
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        var formatString = ""
        var components: [String] = []
        
        if hours > 0 {
            formatString += "HH:"
            components.append(String(format: "%02d", hours))
        }
        
        if minutes > 0 || (hours == 0 && remainingSeconds == 0) {
            formatString += "mm:"
            components.append(String(format: "%02d", minutes))
        }
        
        if remainingSeconds > 0 && hours == 0 && minutes == 0 {
            
            formatString += "ss"
            components.append(String(format: "%02d", remainingSeconds))
            
        } else {
            formatString += "ss"
            components.append(String(format: "%02d", remainingSeconds))
        }
        
        formatter.dateFormat = formatString
        let dateString = components.joined(separator: ":")
        let formattedDuration = formatter.string(from: formatter.date(from: dateString)!) // Force unwrapping is safe here
        
        if isForMusic {
            if remainingSeconds > 0 && hours == 0 && minutes == 0 {
                return "00:\(formattedDuration)"
                
            } else {
                return "\(formattedDuration)"
            }
            
        } else {
            var durationText = ""
            
            if Double(self) > 86400 {
                durationText = "hours"
                
            } else if Double(self) < 3600 && Double(self) > 60 {
                durationText = "mins"
                
            } else if Double(self) < 60 {
                durationText = "seconds"
            }
            
            return "\(formattedDuration) \(durationText.trimmingCharacters(in: .whitespacesAndNewlines))"
        }
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension NewMusicVC: AudioPlayerDelegate {
    
    func audioPlayerDidStartPlaying(player: AudioPlayer, with entryId: AudioEntryId) {
        self.btnPlay.isSelected = true
        self.acti.stopAnimating()
    }
    
    func audioPlayerDidFinishBuffering(player: AudioPlayer, with entryId: AudioEntryId) {
        
    }
    
    func audioPlayerStateChanged(player: AudioPlayer, with newState: AudioPlayerState, previous: AudioPlayerState) {
        
        if newState == .playing {
            self.btnPlay.isSelected = true
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
            self.acti.stopAnimating()
            
        } else if newState == .paused {
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
            self.btnPlay.isSelected = false
            
        } else if newState == .stopped {
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
            self.btnPlay.isSelected = false
            
        } else {
            self.btnPlay.isSelected = false
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
            if newState == .bufferring {
                self.acti.startAnimating()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AudioPlayer, entryId: AudioEntryId, stopReason: AudioPlayerStopReason, progress: Double, duration: Double) {
        
//        print("audioPlayerDidFinishPlaying", stopReason)
//        if stopReason != .userAction && !self.isPreviousTapped {
//            self.nextSong()
//        }
    }
    
    func audioPlayerUnexpectedError(player: AudioPlayer, error: AudioPlayerError) {
        
    }
    
    func audioPlayerDidCancel(player: AudioPlayer, queuedItems: [AudioEntryId]) {
        
    }
    
    func audioPlayerDidReadMetadata(player: AudioPlayer, metadata: [String : String]) {
        
    }
}
