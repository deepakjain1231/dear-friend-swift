//
//  YogaListTVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/09/23.
//

import UIKit
import AVFoundation
import AVKit
import GoogleMobileAds

class YogaListTVC: UITableViewCell {

    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var colleView: UICollectionView!
    
    var current: VideoSectionListingModel?
    var yogaTapped: voidCloser?
    var interstitial: GADInterstitialAd?
    var currentVideo: VideoSectionVideo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTheView()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.colleView.delegate = self
        self.colleView.dataSource = self
        self.colleView.registerCell(type: HomeListCVC.self)
        self.colleView.reloadData()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblName.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "")
        self.lblType.configureLable(textColor: hexStringToUIColor(hex: "D2CDF3"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "")
    }
    
    @IBAction func btnRightTapped(_ sender: UIButton) {
        self.yogaTapped?()
    }
}

// MARK: - Collection Methods

extension YogaListTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.current?.video?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
        
        let currentVideo = self.current?.video?[indexPath.row]
        
        if currentVideo?.accessType == "paid" && !appDelegate.isPlanPurchased {
            cell.vwPremium.isHidden = false
        } else {
            cell.vwPremium.isHidden = true
        }
        
        let ddd = currentVideo?.video_duration?.doubleValue ?? 0
        
        let strvideoTitle = currentVideo?.title ?? ""
        cell.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_SemiBold, fontSize: 14, text: strvideoTitle)
        
        cell.lblTime.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: TimeInterval(ddd).formatDuration())
        
        GeneralUtility().setImage(imgView: cell.imgMain, imgPath: currentVideo?.image ?? "")
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 195, height: 195)
    }
    
    func extractYouTubeVideoID(from url: String) -> String? {
        guard let range = url.range(of: "v=") else {
            return nil
        }

        let startIndex = range.upperBound
        let endIndex = url.index(startIndex, offsetBy: 11, limitedBy: url.endIndex) ?? url.endIndex
        let videoID = url[startIndex..<endIndex]

        return String(videoID)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentVideo = self.current?.video?[indexPath.row]
        if currentVideo?.accessType == "paid" && !appDelegate.isPlanPurchased {
         
            if let top = UIApplication.topViewController2() {
                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                vc.hidesBottomBarWhenPushed = true
                top.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            self.currentVideo = currentVideo
            if !appDelegate.isPlanPurchased {
                self.openVideoScreen()
                
            } else {
                SHOW_CUSTOM_LOADER()
                self.setupFullAD { success in
                    if success {
                        self.showAD { success in
                            
                        }
                    }
                }
            }
        }
    }
    
    func setupFullAD(success: @escaping (Bool) -> Void) {
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
    
    func showAD(success: @escaping (Bool) -> Void) {
        if let top = UIApplication.topViewController2() {
            if self.interstitial != nil {
                self.interstitial?.fullScreenContentDelegate = self
                self.interstitial?.present(fromRootViewController: top)
                success(true)
            } else {
                print("Ad wasn't ready")
                success(false)
            }
        }
    }
    
    func getVideoURL(vc: UIViewController, url: URL, completion: @escaping (_ video: URL?, _ error:Error?) -> Void) {
        vc.SHOW_CUSTOM_LOADER()
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { ( video:HCVimeoVideo?, error:Error?) -> Void in
            if let err = error {
                
                print("Error = \(err.localizedDescription)")
                
                DispatchQueue.main.async() {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    vc.present(alert, animated: true, completion: nil)
                }
                completion(nil, nil)
                return
            }
            
            guard let vid = video else {
                print("Invalid video object")
                completion(nil, nil)
                return
            }
            
            print("Title = \(vid.title), url = \(vid.videoURL), thumbnail = \(vid.thumbnailURL)")
            DispatchQueue.main.async() {
                completion(vid.videoURL[.quality1080p], nil)
            }
        })
    }
}

extension YogaListTVC: GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        HIDE_CUSTOM_LOADER()
        print("Ad did fail to present full screen content. ERR :", error.localizedDescription)
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        HIDE_CUSTOM_LOADER()
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openVideoScreen()
        }
    }
    
    func openVideoScreen() {
        if let top = UIApplication.topViewController2() {
        
            if let video_id = currentVideo?.video_id {
                appDelegate.callAPIforVimeoExtracter(vimeo_id: video_id, current_view: top) { is_success, str_videoURL in
                    if is_success {
                        guard let videoURL = URL(string: str_videoURL) else {
                            return
                        }
                        top.HIDE_CUSTOM_LOADER()
                        let player = AVPlayer(url: videoURL)
                        let playerController = LandscapeAVPlayerController()
                        playerController.player = player
                        playerController.modalPresentationStyle = .overFullScreen
                        top.present(playerController, animated: true) {
                            player.play()
                        }
                    }
                    else {
                        top.HIDE_CUSTOM_LOADER()
                        let alert = UIAlertController(title: "Error", message: "Invalid video URL", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        top.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else {
                top.HIDE_CUSTOM_LOADER()
                let alert = UIAlertController(title: "Error", message: "Invalid video URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                top.present(alert, animated: true, completion: nil)
            }
        
            
//            if let url = URL(string: "https://vimeo.com/\(currentVideo?.video_id ?? "")") {
//                self.getVideoURL(vc: top, url: url) { videoURL, error in
//                    if let url = videoURL {
//                        top.HIDE_CUSTOM_LOADER()
//                        let player = AVPlayer(url: url)
//                        let playerController = LandscapeAVPlayerController()
//                        playerController.player = player
//                        playerController.modalPresentationStyle = .overFullScreen
//                        top.present(playerController, animated: true) {
//                            player.play()
//                        }
//                    } else {
//                        top.HIDE_CUSTOM_LOADER()
//                        let alert = UIAlertController(title: "Error", message: "Invalid video URL", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                        top.present(alert, animated: true, completion: nil)
//                    }
//                }
//            }
            
        }
    }
}
