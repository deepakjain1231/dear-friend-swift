//
//  TopPicsListVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 17/05/23.
//

import UIKit
import SkeletonView
import GoogleMobileAds

class TopPicsListVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    
    // MARK: - VARIABLES
    
    private var interstitial: GADInterstitialAd?
    var audioVM = AudioViewModel()
    var currentSongIndex = 0
    
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
            self.interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func setupUI() {
        self.changeStyle()
        self.setupAD()
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: MyHistoryCVC.self)
        self.colleView.reloadData()
        self.colleView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
        self.lblTitle.text = self.audioVM.currentAudioType.rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
        self.lblTitle2.text = "For You"
        
        self.startAnimationColle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getMusicList()
        }
    }
    
    private func startAnimationColle() {
        
        let gradient = SkeletonGradient(baseColor: UIColor.midnightBlue)
        self.colleView.isSkeletonable = true
        self.colleView.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    func getMusicList() {
        self.audioVM.getAudioList { _ in
            
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
        self.goBack(isGoingTab: true)
    }
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

extension TopPicsListVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.audioVM.arrOfAudioList.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MyHistoryCVC"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                
            }
            
            cell.playTapped = {
                GeneralUtility().addButtonTapHaptic()
                self.currentSongIndex = indexPath.row
                if appDelegate.isPlanPurchased {
                    let vc: MusicVC = MusicVC.instantiate(appStoryboard: .Explore)
                    vc.hidesBottomBarWhenPushed = true
                    vc.audioVM = self.audioVM
                    vc.currentSongIndex = self.currentSongIndex
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if self.interstitial != nil {
                        self.interstitial?.present(fromRootViewController: self)
                    } else {
                        print("Ad wasn't ready")
                    }
                }
            }
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "MyHistoryCVC", for: indexPath) as? MyHistoryCVC else { return UICollectionViewCell() }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width - 36) / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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

extension TopPicsListVC: GADFullScreenContentDelegate {
    
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
