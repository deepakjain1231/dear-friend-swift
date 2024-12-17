//
//  VideoPlayerVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 26/12/23.
//

import UIKit
import YoutubePlayerView

class VideoPlayerVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var playerView: YoutubePlayerView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - VARIABLES
    
    var titleStr = ""
    var videoID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            if #available(iOS 16.0, *) {
//                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
//                
//                appDelegate.deviceOrientation = .landscapeRight
//                
//            } else {
//                appDelegate.deviceOrientation = .landscapeRight
//                let value = UIInterfaceOrientation.landscapeRight.rawValue
//                UIDevice.current.setValue(value, forKey: "orientation")
//            }
//        }
    }
    
    func setupUI() {
        
        self.lblTitle.text = self.titleStr
        self.playerView.backgroundColor = .clear
        let playerVars: [String: Any] = [
            "playsinline": 0,
            "autoplay": 1
        ]
        self.playerView.loadWithVideoId(self.videoID, with: playerVars)
        self.playerView.delegate = self
        self.playerView.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.setupUI()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        appDelegate.deviceOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.goBack(isGoingTab: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

extension VideoPlayerVC: YoutubePlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.play()
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
}
