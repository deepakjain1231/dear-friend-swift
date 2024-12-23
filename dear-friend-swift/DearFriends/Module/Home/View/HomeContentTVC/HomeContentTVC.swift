//
//  HomeContentTVC.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 19/10/24.
//

import UIKit
import SkeletonView
import GoogleMobileAds

class HomeContentTVC: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var img_Bg: UIImageView!
    @IBOutlet weak var colletView: UICollectionView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    var timer: Timer?
    var indxPosition: Int = 0
    var arrAudio = [CommonAudioList]()
    var interstitial: GADInterstitialAd?
    var onButtonTapped: ((Int) -> Void)?
    var strHomeImage : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#212159"))
        self.colletView.isSkeletonable = true
        self.colletView.showAnimatedGradientSkeleton(usingGradient: gradient)
        
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 18, text: "")
        self.btnSeeAll.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 12.0, text: "See all")
    }

    func setupCollection() {
        self.colletView.delegate = self
        self.colletView.dataSource = self
        self.colletView.registerCell(type: HomeListCVC.self)
        self.colletView.reloadData()
        self.colletView.hideSkeleton()
        self.pagecontrol.numberOfPages = self.arrAudio.count
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HomeContentTVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        DispatchQueue.main.async {
            if self.arrAudio.count == 1 {
                return
            }
            if self.indxPosition < (self.arrAudio.count - 1) {
                self.indxPosition = self.indxPosition + 1

                let desiredOffset = CGPoint(x: self.indxPosition * (Int(screenWidth) - 40), y: 0)
                self.colletView.setContentOffset(desiredOffset, animated: true)
            }
            else {
                self.indxPosition = 0
                let desiredOffset = CGPoint(x: 0, y: 0)
                self.colletView.setContentOffset(desiredOffset, animated: false)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.colletView.contentOffset, size: self.colletView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.colletView.indexPathForItem(at: visiblePoint) {
            self.pagecontrol.currentPage = visibleIndexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAudio.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "HomeListCVC"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
        cell.vwPremium.isHidden = true
        cell.layoutIfNeeded()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
        
        let current = self.arrAudio[indexPath.row]
        let ddd = current.audioDuration?.doubleValue ?? 0
        
        cell.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14, text: current.title ?? "")
        cell.lblTime.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: TimeInterval(ddd).formatDuration())
        
        //GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current.image ?? "")
        
        if current.forSTr == "premium" && !appDelegate.isPlanPurchased {
            cell.vwPremium.isHidden = false
        } else {
            cell.vwPremium.isHidden = true
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: manageWidth(size: 180))

//        return CGSize(width: 226, height: 236)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (arrAudio[indexPath.item].forSTr ?? "") == "premium" && !appDelegate.isPlanPurchased {
            
            let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
            vc.hidesBottomBarWhenPushed = true
            if let topVc = UIApplication.topViewController2() {
                topVc.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
            vc.hidesBottomBarWhenPushed = true
            vc.interstitial = self.interstitial
            let audioVM = AudioViewModel()
            vc.currentSong = arrAudio[indexPath.item]
            vc.isHomePage = true
            vc.strHomeTitle = self.lblTitle.text ?? ""
            vc.strHomeImage = self.strHomeImage
            vc.likedTapped = { like in
                self.arrAudio[indexPath.item].isLiked = like
            }
            audioVM.arrOfAudioList = arrAudio
            vc.audioVM = audioVM
            vc.currentSongIndex = indexPath.row
            if let topVc = UIApplication.topViewController2() {
                topVc.navigationController?.pushViewController(vc, animated: true)
            }
        }
//        onButtonTapped?(indexPath.row)
    }
    
    
}
