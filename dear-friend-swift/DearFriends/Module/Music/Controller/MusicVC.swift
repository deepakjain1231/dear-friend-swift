//
//  MusicVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 18/05/23.
//

import UIKit
import MSCircularSlider
import GoogleMobileAds
import AVFoundation
import MediaPlayer

enum CurrentRepeatMode {
    case None
    case SingleRepeat
}

class MusicVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var consBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var vwCircular: MSCircularSlider!
    @IBOutlet weak var vwSong: UIView!
    @IBOutlet weak var vwBanner: UIView!
    @IBOutlet weak var lblTotalMins: GradientLabel!
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet var lblMaker: GradientLabel!
    
    // MARK: - VARIABLES
    
    var bannerView: GADBannerView!
    var audioVM = AudioViewModel()
    
    var audioPlayer: AVPlayer?
    var currentSongIndex = 0
    var songs: [URL] = []
    var timer: Timer?
    var currentSong: CommonAudioList?
    var currentRepeatMode: CurrentRepeatMode = .None
    
    var backGroundPlayer: AVPlayer?
    var currentBG: BackgroundsList?
    
    var isFromDownload = false
    var arrOfDownloads = [LocalMusicModel]()
    
    var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func showAD() {
        if self.interstitial != nil {
            self.interstitial?.fullScreenContentDelegate = self
            self.interstitial?.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func setupUI() {
        self.changeStyle()
        if !appDelegate.isPlanPurchased {
            self.setupAd()
            self.showAD()
        }
        self.lblMaker.gradientColors = [hexStringToUIColor(hex: "#F29A56").cgColor,
                                        hexStringToUIColor(hex: "#FFE1AC").cgColor]
        self.lblTotalMins.gradientColors = [hexStringToUIColor(hex: "#F29A56").cgColor,
                                            hexStringToUIColor(hex: "#FFE1AC").cgColor]
        self.addBorder()
        self.vwCircular.backgroundColor = .clear
        
        let colors = [hexStringToUIColor(hex: "#B05148").cgColor,
                      hexStringToUIColor(hex: "#F29A56").cgColor,
                      hexStringToUIColor(hex: "#FFE1AC").cgColor,
                      hexStringToUIColor(hex: "#8D3B33").cgColor]
        vwCircular.filledColor = drawGradientColor(in: self.vwCircular.frame, colors: colors)!
        vwCircular.unfilledColor = UIColor.white.withAlphaComponent(0.3)
        vwCircular.maximumAngle = 300
        vwCircular.rotationAngle = 28
        vwCircular.lineWidth = 6
        vwCircular.slidingDirection = .clockwise
        self.vwCircular.minimumValue = 1
        vwCircular.handleImage = UIImage(named: "ic_thumb_slider2")
        
        self.btnPlay.setBackgroundImage(UIImage(named: "ic_music_play"), for: .normal)
        self.btnPlay.setBackgroundImage(UIImage(named: "ic_pause_new"), for: .selected)
        
        self.initPlayer()
    }
    
    func addBorder() {
        
        self.vwBG.layer.cornerRadius = self.vwBG.frame.size.height / 2
        self.vwBG.clipsToBounds = true
        self.vwBG.borderColor = hexStringToUIColor(hex: "F29A56")
        self.vwBG.borderWidth = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the timer when the view is about to disappear
        
        self.pause()
        self.stopTimer()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }
        
        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vwSong.layer.cornerRadius = self.vwSong.frame.size.height / 2
        self.imgSong.layer.cornerRadius = self.imgSong.frame.size.height / 2
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: !self.isFromDownload)
    }
    
    @IBAction func btnListTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnRepeatTapped(_ sender: UIButton) {
        if self.currentRepeatMode == .None {
            self.currentRepeatMode = .SingleRepeat
            self.btnRepeat.setImage(UIImage(named: "ic_music_repeat_1"), for: .normal)
            
        } else if self.currentRepeatMode == .SingleRepeat {
            self.btnRepeat.setImage(UIImage(named: "ic_music_repeat_all"), for: .normal)
        }
    }
    
    @IBAction func btnPreviousTapped(_ sender: UIButton) {
        self.previousSong()
    }
    
    @IBAction func btnPlayTapped(_ sender: UIButton) {
        if ((self.audioPlayer?.rate != 0) && (self.audioPlayer?.error == nil)) {
            self.pause()
        } else {
            self.play()
        }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        self.nextSong()
    }
    
    @IBAction func btnLikeTapped(_ sender: UIButton) {
        self.previousSong()
    }
    
    @IBAction func btnRemoveBG(_ sender: UIButton) {
        self.btnBG.setTitle("Choose Background", for: .normal)
        self.btnClose.isHidden = true
        self.backGroundPlayer?.pause()
    }
    
    @IBAction func btnChooseTapped(_ sender: UIButton) {
        let array = self.currentSong?.backgrounds?.compactMap({$0.title ?? ""}) ?? []
        if array.count > 0 {
            let vc: ChooseBackgroundVC = ChooseBackgroundVC.instantiate(appStoryboard: .Explore)
            vc.height = 500
            vc.arrOfBackgroundMusic = array
            vc.presentDuration = 0.5
            vc.dismissDuration = 0.5
            vc.fileSelected = { ind in
                self.btnBG.layoutIfNeeded()
                self.btnBG.setTitle(self.currentSong?.backgrounds?[ind].title ?? "", for: .normal)
                self.btnClose.isHidden = false
                self.currentBG = self.currentSong?.backgrounds?[ind]
                self.initBackMusic()
            }
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        } else {
            GeneralUtility().showSuccessMessage(message: "No Background Audios found!")
        }
    }
}

// MARK: - Music Player

extension MusicVC: AVAudioPlayerDelegate {
    
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
        let songURL = songs[index]
        self.manageButtons()
        self.managePlayerBeforePlay(destinationUrl: songURL)
        self.managePlayer()
        self.backGroundPlayer?.pause()
    }

    func managePlayerBeforePlay(destinationUrl: URL) {
        
        if self.isFromDownload {
            do {
                
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
                
                let audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                audioPlayer.prepareToPlay()
                audioPlayer.delegate = self
                audioPlayer.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        } else {
            let playerItem2 = AVPlayerItem(url: destinationUrl)
            self.audioPlayer = AVPlayer(playerItem: playerItem2)
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.play()
            }
        }
        
        self.lblTotalMins.text = self.formatTime(self.audioPlayer?.currentItem?.asset.duration.seconds ?? 0.0)
        self.vwCircular.maximumValue = self.audioPlayer?.currentItem?.asset.duration.seconds ?? 0.0
        self.lblCurrentTime.text = "00:00"
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        self.nextSong()
    }
    
    func managePlayer() {
        DispatchQueue.main.async {
            if self.isFromDownload {
                let current = self.arrOfDownloads[self.currentSongIndex]
                self.lblCat.text = current.category
                self.lblSongName.text = current.music_title
                self.lblMaker.text = current.narrated_by
                
                if let music_image = current.music_image {
                    self.imgSong.image = UIImage(data: music_image)
                    self.imgBg.image = UIImage(data: music_image)
                }                
            } else {
                self.currentSong = self.audioVM.arrOfAudioList[self.currentSongIndex]
                
                if let current = self.currentSong {
                    self.lblCat.text = current.category?.title ?? ""
                    self.lblSongName.text = current.title ?? ""
                    self.lblMaker.text = current.narratedBy ?? ""
                    GeneralUtility().setImage(imgView: self.imgSong, imgPath: current.image ?? "")
                    GeneralUtility().setImage(imgView: self.imgBg, placeHolderImage: nil, imgPath: current.image ?? "", isWithoutFade: true)
                    self.setupNowPlaying()
                    self.setupRemoteCommandCenter()
                }
            }
        }
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            self.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.pause()
            return .success
        }
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget {event in
            self.nextSong()
            return .success
        }
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget {event in
            self.previousSong()
            return .success
        }
    }
    
    func setupNowPlayingInfoCenter() {
        // Define the metadata for the now playing info center
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Song Title" // Replace with the current song title
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Artist Name" // Replace with the current artist name
        
        if let image = UIImage(named: "album_artwork") {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.audioPlayer?.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer?.isPlaying ?? false ? 1.0 : 0.0
        
        // Set the now playing info center's info
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        if self.isFromDownload {
            let current = self.arrOfDownloads[self.currentSongIndex]
            nowPlayingInfo[MPMediaItemPropertyTitle] = current.music_title
            nowPlayingInfo[MPMediaItemPropertyArtist] = current.narrated_by
            
        } else {
            nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentSong?.title ?? ""
            nowPlayingInfo[MPMediaItemPropertyArtist] = self.currentSong?.narratedBy ?? ""
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.audioPlayer?.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.audioPlayer?.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.audioPlayer?.rate
        
        // Set the metadata
        
        if let image = self.imgSong.image { // Replace with actual song artwork image
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
        }
        
        nowPlayingInfo[MPMediaItemPropertyAlbumTrackCount] = self.songs.count
        nowPlayingInfo[MPMediaItemPropertyAlbumTrackNumber] = self.currentSongIndex + 1
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    
    func play() {
        self.updateCurrentTimeLabel()
        self.startTimer()
        self.audioPlayer?.play()
        self.btnPlay.isSelected = self.audioPlayer?.isPlaying ?? false
    }
    
    func pause() {
        self.audioPlayer?.pause()
        self.stopTimer()
        self.btnPlay.isSelected = self.audioPlayer?.isPlaying ?? false
        self.backGroundPlayer?.pause()
    }
    
    func nextSong() {
        currentSongIndex += 1
        self.pause()
        if self.currentSongIndex >= (self.songs.count - 1) {
            
            if self.currentRepeatMode == .SingleRepeat {
                
                self.currentSongIndex = 0
                self.loadSong(index: currentSongIndex)
                self.play()
                
            } else {
                self.loadSong(index: currentSongIndex)
                self.play()
            }
            
        } else {
            self.loadSong(index: currentSongIndex)
            self.play()
        }
        
        self.btnBG.setTitle("Choose Background", for: .normal)
        self.btnClose.isHidden = true
    }
    
    func previousSong() {
        self.pause()
        currentSongIndex -= 1
        loadSong(index: currentSongIndex)
        play()
        
        self.btnBG.setTitle("Choose Background", for: .normal)
        self.btnClose.isHidden = true
    }
    
    // MARK: AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag && player == self.audioPlayer {
            nextSong()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCurrentTimeLabel), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        self.audioPlayer?.pause()
    }
    
    @objc func updateCurrentTimeLabel() {
        guard let currentTime = audioPlayer?.currentItem?.currentTime().seconds else { return }
        self.lblCurrentTime.text = formatTime(currentTime)
        
        guard let totalTime = self.audioPlayer?.currentItem?.asset.duration.seconds else { return }
        let progress = currentTime
        self.vwCircular.maximumValue = totalTime
        self.vwCircular.minimumValue = 0
        self.vwCircular.maximumRevolutions = 1
        self.vwCircular.delegate = self
        self.vwCircular.currentValue = progress
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Background Music

extension MusicVC {
    
    func initBackMusic() {
        if let songURL = URL(string: self.currentBG?.file ?? "") {
            do {
                // Initialize the audio player
                
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                self.managePlayerBeforeBGPlay(destinationUrl: songURL)
                
            } catch {
                print("Failed to load song: \(error)")
            }
        }
    }
    
    func managePlayerBeforeBGPlay(destinationUrl: URL) {
        do {
            // Initialize the audio player
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let playerItem = AVPlayerItem(url: destinationUrl)
            self.backGroundPlayer = AVPlayer(playerItem:playerItem)
            self.backGroundPlayer?.volume = 0.8
            self.backGroundPlayer?.play()
            
        } catch {
            print("Failed to load song: \(error)")
        }
    }
}

// MARK: - Slider Methods

extension MusicVC: MSCircularSliderDelegate {
    
    func circularSlider(_ slider: MSCircularSlider, valueChangedTo value: Double, fromUser: Bool) {
        
    }
    
    func circularSlider(_ slider: MSCircularSlider, endedTrackingWith value: Double) {
        print("value", value)
        self.vwCircular.currentValue = value
        self.stopTimer()
        let newTime = CMTimeMakeWithSeconds(value, preferredTimescale: 600)
        self.audioPlayer?.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        self.audioPlayer?.play()
        self.startTimer()
    }
}

// MARK: - Googlead Methods

extension MusicVC: GADBannerViewDelegate {
    
    func setupAd() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.size.width, height: 50))
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
        self.consBannerHeight.constant = 50
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
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return image.withRenderingMode(self.renderingMode)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension MusicVC: GADFullScreenContentDelegate {
    
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
    }
}







extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
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
