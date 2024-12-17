//
//  YogaInstructorVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/09/23.
//

import UIKit
import ExpandableLabel
import AVFoundation
import AVKit
import GoogleMobileAds

class YogaInstructorVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var lblDesc: AppExpandableLabel!
    @IBOutlet weak var btnSchedule: AppButton!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var tblMain: UITableView!
    
    // MARK: - VARIABLES
    
    var titleStr = ""
    var yogaVM = VideoViewModel()
    var isExpanded = false
    var interstitial: GADInterstitialAd?
    var currentVideo: VideoSectionVideo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblType.text = "\(self.titleStr) videos"
        self.btnSchedule.isHidden = true
        self.consBtnHeight.constant = 0
        self.vwScroll.isHidden = true
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: YogaVideosTVC.self)
        self.tblMain.registerCell(type: LoadingTVC.self)
        self.tblMain.reloadData()
        self.tableHeightManage()
        
        self.yogaVM.getInstructorVideoDetails { _ in
            self.dataBind()
//            self.btnSchedule.isHidden = false
            self.vwScroll.isHidden = false
            self.tblMain.reloadData()
            self.tblMain.restore()
            
//            if (self.yogaVM.currentInstructorDetails?.session ?? 0) == 0 {
//                self.btnSchedule.isHidden = true
//                self.consBtnHeight.constant = 0
//            } else {
//                self.btnSchedule.isHidden = false
//                self.consBtnHeight.constant = 54
//            }
            
            self.view.layoutIfNeeded()
            
            if (self.yogaVM.currentInstructorDetails?.video?.count ?? 0) == 0 {
                self.tblMain.setEmptyMessage("No Videos Found!")
            }
            
        } failure: { errorResponse in
            
        }
    }
    
    func dataBind() {
        self.lblName.text = self.yogaVM.currentInstructorDetails?.name ?? ""
        GeneralUtility().setImage(imgView: self.imgUser, imgPath: self.yogaVM.currentInstructorDetails?.profileImage ?? "")
        self.lblSub.text = self.yogaVM.currentInstructorDetails?.title ?? ""
        self.lblDesc.setupLabel()
        self.lblDesc.collapsed = !self.isExpanded
        self.lblDesc.text = self.yogaVM.currentInstructorDetails?.about_instructor ?? ""
        self.lblDesc.delegate = self
    }
    
    func tableHeightManage() {
        self.tblMain.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMain.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblMain {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.consHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnScheTapped(_ sender: UIButton) {
        let vc: RescheduleCalendarVC = RescheduleCalendarVC.instantiate(appStoryboard: .MyBookings)
        vc.isFromYoga = true
        self.yogaVM.instructor_id = "\(self.yogaVM.currentInstructorDetails?.internalIdentifier ?? 0)"
        vc.yogaVM = self.yogaVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Tableview Methods

extension YogaInstructorVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.yogaVM.currentInstructorDetails?.video?.count ?? 0
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LoadingTVC") as? LoadingTVC else { return UITableViewCell() }
            
            cell.loader.stopAnimating()
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "YogaVideosTVC") as? YogaVideosTVC else { return UITableViewCell() }
            
            let current = self.yogaVM.currentInstructorDetails?.video?[indexPath.row]
            
            cell.lblTitle.text = current?.title ?? ""
            GeneralUtility().setImage(imgView: cell.imgThumb, imgPath: current?.image ?? "")
            cell.imgThumb.isHidden = false
            
            let ddd = current?.video_duration?.doubleValue ?? 0
            if ddd != 0 {
                cell.lblDuration.text = TimeInterval(ddd).formatDuration()
            }
            
            if (current?.accessType ?? "") == "paid" && !appDelegate.isPlanPurchased {
                cell.imgPremium.isHidden = false
                cell.isPremium = true
            } else {
                cell.imgPremium.isHidden = true
                cell.isPremium = false
            }
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func getVideoURL(url: URL, completion: @escaping (_ video: URL?, _ error:Error?) -> Void) {
        self.SHOW_CUSTOM_LOADER()
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { ( video:HCVimeoVideo?, error:Error?) -> Void in
            self.HIDE_CUSTOM_LOADER()
            if let err = error {
                
                print("Error = \(err.localizedDescription)")
                
                DispatchQueue.main.async() {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = self.yogaVM.currentInstructorDetails?.video?[indexPath.row]
        
        if (current?.accessType ?? "") == "paid" && !appDelegate.isPlanPurchased {
            let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.currentVideo = current
            
            if !appDelegate.isPlanPurchased {
                SHOW_CUSTOM_LOADER()
                self.setupFullAD { succes in
                    if succes {
                        self.showAD { success2 in
                            if success2 {
                                
                            }
                        }
                    }
                }
            } else {
                self.openVideoScreen()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension YogaInstructorVC: ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        self.view.layoutIfNeeded()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        self.isExpanded = true
        self.lblDesc.collapsed = !self.isExpanded
        self.view.layoutIfNeeded()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.view.layoutIfNeeded()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        self.isExpanded = false
        self.lblDesc.collapsed = !self.isExpanded
        self.view.layoutIfNeeded()
    }
}

class LandscapeAVPlayerController: AVPlayerViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}

extension YogaInstructorVC: GADFullScreenContentDelegate {
    
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
            if let url = URL(string: "https://vimeo.com/\(currentVideo?.video_id ?? "")") {
                self.getVideoURL(url: url) { videoURL, error in
                    if let url = videoURL {
                        top.HIDE_CUSTOM_LOADER()
                        let player = AVPlayer(url: url)
                        let playerController = LandscapeAVPlayerController()
                        playerController.player = player
                        playerController.modalPresentationStyle = .overFullScreen
                        top.present(playerController, animated: true) {
                            player.play()
                        }
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Invalid video URL", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        top.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
