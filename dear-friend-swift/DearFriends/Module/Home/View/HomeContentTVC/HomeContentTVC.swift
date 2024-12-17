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
    @IBOutlet weak var colletView: UICollectionView!
    
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
    }

    func setupCollection() {
        self.colletView.delegate = self
        self.colletView.dataSource = self
        self.colletView.registerCell(type: HomeListCVC.self)
        self.colletView.reloadData()
        self.colletView.hideSkeleton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HomeContentTVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
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
        cell.lblTitle.text = current.title ?? ""
        GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current.image ?? "")
        let ddd = current.audioDuration?.doubleValue ?? 0
        cell.lblTime.text = TimeInterval(ddd).formatDuration()
        
        if current.forSTr == "premium" && !appDelegate.isPlanPurchased {
            cell.vwPremium.isHidden = false
        } else {
            cell.vwPremium.isHidden = true
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width - 40, height: manageWidth(size: 180))

        return CGSize(width: 226, height: 236)
        
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
