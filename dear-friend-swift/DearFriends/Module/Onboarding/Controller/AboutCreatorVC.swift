//
//  lbl_about_creator_title.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 27/12/24.
//

import UIKit
import AVFAudio
import AVFoundation

class AboutCreatorVC: BaseVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblsubTitle: UILabel!
    @IBOutlet weak var viewBottomBG: UIView!
    @IBOutlet weak var music_slider: UISlider!
    @IBOutlet weak var lblrunningTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var lbl_musicName: UILabel!
    
    var audioPlayer: AVPlayer?
    var playerItem: AVPlayerItem?
    var timeObserver: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.create_gradient()
        
        setupAudioPlayer()
        setupSlider()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_SemiBold, fontSize: 18, text: "About the Creator")
        self.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 28, text: "Meet Your Guide")
        self.lblsubTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: dic_aboutCreator.about ?? "")
        self.lblrunningTime.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "00:00")
        self.lblTotalTime.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "")
        self.lbl_musicName.configureLable(textColor: hexStringToUIColor(hex: "D1D0D5"), fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14, text: dic_aboutCreator.title ?? "")

        self.lblTotalTime.text = formatTime(seconds: dic_aboutCreator.audio_duration ?? 0)
    }
    
    func create_gradient() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if let gradientColor = CAGradientLayer.init(frame: self.viewBottomBG.frame, colors: About_GradientBGColors, direction: GradientDirection.Bottom).creatGradientImage() {
                self.viewBottomBG.backgroundColor = UIColor.init(patternImage: gradientColor)
                self.viewBottomBG.layoutIfNeeded()
            }
//        }
    }
    
    func setupAudioPlayer() {
        guard let url = URL(string: dic_aboutCreator.file ?? "") else {
            print("Invalid URL")
            return
        }

        playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        
        // Add observer to update slider based on audio playback
        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if let duration = self.playerItem?.duration.seconds, duration > 0 {
                let currentTime = time.seconds
                self.music_slider.value = Float(currentTime / duration)
                self.lblTotalTime.text = formatTime(seconds: Int(duration))
                self.lblrunningTime.text = formatTime(seconds: Int(currentTime))
            }
        }
        
        // Observe when the player finishes playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    func setupSlider() {
        self.music_slider.minimumValue = 0
        self.music_slider.maximumValue = 1
        self.music_slider.value = 0
        self.music_slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
                
        self.music_slider.minimumTrackTintColor = hexStringToUIColor(hex: "4F4791")
        self.music_slider.maximumTrackTintColor = hexStringToUIColor(hex: "B2B1B9")

        // Create a custom thumb image
        let thumbImage = createThumbImage(size: CGSize(width: 12, height: 12), color: hexStringToUIColor(hex: "776ADA"))

        // Set the custom thumb image
        self.music_slider.setThumbImage(thumbImage, for: .normal)
        self.music_slider.setThumbImage(thumbImage, for: .highlighted)
    }

    func createThumbImage(size: CGSize, color: UIColor) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fillEllipse(in: rect)
        }
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        guard let duration = playerItem?.duration.seconds, duration > 0 else { return }
        let newTime = CMTime(seconds: Double(sender.value) * duration, preferredTimescale: 1)
        audioPlayer?.seek(to: newTime)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if audioPlayer?.rate == 0 {
            audioPlayer?.play()
            self.btnPlayPause.setImage(UIImage.init(named: "ic_pause_new"), for: .normal)
        } else {
            audioPlayer?.pause()
            self.btnPlayPause.setImage(UIImage.init(named: "ic_music_play"), for: .normal)
        }
    }
    
    @objc func playerDidFinishPlaying() {
        self.music_slider.value = 0
        self.lblrunningTime.text = "00:00"
        self.btnPlayPause.setImage(UIImage.init(named: "ic_music_play"), for: .normal)
    }
    
    deinit {
        if let timeObserver = timeObserver {
            audioPlayer?.removeTimeObserver(timeObserver)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.audioPlayer?.pause()
        self.navigationController?.popViewController(animated: true)
    }
}
