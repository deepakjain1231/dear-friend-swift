//
//  NewHomeVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 06/09/23.
//

import UIKit
import SkeletonView
import GoogleMobileAds

class NewHomeVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNoti: UIControl!
    @IBOutlet weak var viewNotiIndicator: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var stackPicks: UIStackView!
    @IBOutlet weak var stackRecm: UIStackView!
    @IBOutlet weak var stackBeginner: UIStackView!
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var colleBeginner: UICollectionView!
    @IBOutlet weak var colleTopPicks: UICollectionView!
    @IBOutlet weak var colleRec: UICollectionView!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var con_headerCollectionView: NSLayoutConstraint!

    // MARK: - VARIABLES
    
    var homeVM = HomeViewModel()
    var interstitial: GADInterstitialAd?
    var refreshControl = UIRefreshControl()
    
    static var newInstance: NewHomeVC {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "NewHomeVC"
        ) as! NewHomeVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHomeScreen = true

        GADMobileAds.sharedInstance().start()
        self.setTheView()
        self.setupUI()
        self.showRatingPromptIfNeeded()
//        self.homeVM.updateTokenAPI()

        
        //OPEN NOTIFICATION SCREEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            if dicNotificationData.count != 0{
                GlobalConstants.appDelegate?.moveToNotificaitonScreen(dicData: dicNotificationData)
            }
        }
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.con_headerCollectionView.constant = manageWidth(size: 160)
        
        self.lblName.text = "Hello \(CurrentUser.shared.user?.firstName ?? "") 👋"
        
        self.tblView.setDefaultProperties(vc: self)
        self.tblView.registerCell(type: HomeContentTVC.self)
        
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: HomeCategoryCVC.self)
        self.colleView.reloadData()
        
        self.colleBeginner.setDefaultProperties(vc: self)
        self.colleBeginner.registerCell(type: HomeListCVC.self)
        self.colleBeginner.reloadData()
        
        self.colleRec.setDefaultProperties(vc: self)
        self.colleRec.registerCell(type: HomeListCVC.self)
        self.colleRec.reloadData()
        
        self.colleTopPicks.setDefaultProperties(vc: self)
        self.colleTopPicks.registerCell(type: HomeListCVC.self)
        self.colleTopPicks.reloadData()
        
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0)
        
        self.getHomeData()
        
        self.refreshControl.tintColor = .white
        self.refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        self.vwScroll.refreshControl = self.refreshControl
        
        if appDelegate.isOpenedFromNoti {
            self.openNotiPopup()
        }
        tableHeightManage()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblName.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20, text: "")
        self.lblSubTitle.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Welcome Back")
    }
    
    func tableHeightManage() {
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblView {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.tblHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
        
    func openNotiPopup() {
        let vc: NotificationPopupVC = NotificationPopupVC.instantiate(appStoryboard: .main)
        vc.titleText = appDelegate.titleText
        vc.descText = appDelegate.descText
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }

    
    @objc func handleRefreshControl() {
        
        self.homeVM.homedataModel = .init(json: "")
        self.tblView.restore()
        self.colleView.restore()
        self.colleBeginner.restore()
        self.colleRec.restore()
        self.colleTopPicks.restore()
        
        self.colleView.reloadData()
        self.colleBeginner.reloadData()
        self.colleRec.reloadData()
        self.colleTopPicks.reloadData()
        self.tblView.reloadData()
        self.getHomeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("MusicClose"), object: nil)

        self.viewNotiIndicator.isHidden = appDelegate.unread_count == 0 ? true : false
        self.colleRec.reloadData()
        self.colleView.reloadData()
        self.colleBeginner.reloadData()
        self.colleTopPicks.reloadData()
        self.tblView.reloadData()
        
        LogoutService.shared.callAPIforCheckAnotherDeviceLogin()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnNotificationTapped(_ sender: UIControl) {
        let vc: NotificationsVC = NotificationsVC.instantiate(appStoryboard: .Home)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRecViewAllTapped(_ sender: UIButton) {
        let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        vc.isFromViewAll = true
        self.homeVM.currentFilterType = .none
        self.homeVM.currentAudioType = .recommended
        vc.homeVM = self.homeVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBeggiViewAllTapped(_ sender: UIButton) {
        let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        vc.isFromViewAll = true
        self.homeVM.currentFilterType = .none
        self.homeVM.currentAudioType = .beginner
        vc.homeVM = self.homeVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnToppicViewAllTapped(_ sender: UIButton) {
        let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        vc.isFromViewAll = true
        self.homeVM.currentFilterType = .none
        self.homeVM.currentAudioType = .top_picks
        vc.homeVM = self.homeVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - API Data
    
    func getHomeData() {
        
        self.homeVM.getHomeDynamicList { _ in
            self.tblView.reloadData()
        } failure: { errorResponse in
            
        }

        let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#212159"))
        self.colleView.isSkeletonable = true
        self.colleView.showAnimatedGradientSkeleton(usingGradient: gradient)
        
        self.colleBeginner.isSkeletonable = true
        self.colleBeginner.showAnimatedGradientSkeleton(usingGradient: gradient)
        
        self.colleRec.isSkeletonable = true
        self.colleRec.showAnimatedGradientSkeleton(usingGradient: gradient)
        
        self.colleTopPicks.isSkeletonable = true
        self.colleTopPicks.showAnimatedGradientSkeleton(usingGradient: gradient)
        
        self.stackBeginner.isHidden = true
        self.stackPicks.isHidden = true
        self.stackRecm.isHidden = true
        
        //_ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            self.homeVM.getHomeData { model in
                
                self.viewNotiIndicator.isHidden = appDelegate.unread_count == 0 ? true : false
                self.colleView.hideSkeleton()
                self.colleBeginner.hideSkeleton()
                self.colleRec.hideSkeleton()
                self.colleTopPicks.hideSkeleton()
                
                if (self.homeVM.homedataModel?.category?.count ?? 0) == 0 {
                    self.colleView.isHidden = true
                } else {
                    self.colleView.isHidden = false
                    self.colleView.reloadData()
                }
                
                /*if (self.homeVM.homedataModel?.beginnerPath?.count ?? 0) == 0 {
                    self.stackBeginner.isHidden = true
                } else {
                    self.stackBeginner.isHidden = false
                    self.colleBeginner.reloadData()
                    self.colleBeginner.reloadData()
                }
                
                if (self.homeVM.homedataModel?.recommended?.count ?? 0) == 0 {
                    self.stackRecm.isHidden = true
                } else {
                    self.stackRecm.isHidden = false
                    self.colleRec.reloadData()
                    self.colleRec.reloadData()
                }
                
                if (self.homeVM.homedataModel?.topPicks?.count ?? 0) == 0 {
                    self.stackPicks.isHidden = true
                } else {
                    self.stackPicks.isHidden = false
                    self.colleTopPicks.reloadData()
                    self.colleTopPicks.reloadData()
                }
                */
                self.vwScroll.refreshControl?.endRefreshing()
                
            } failure: { errorResponse in
                
            }
        //})
    }
    
}

// MARK: - Collection Methods

extension NewHomeVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colleView {
            return self.homeVM.homedataModel?.category?.count ?? 0
            
        } else if collectionView == self.colleBeginner {
            return self.homeVM.homedataModel?.beginnerPath?.count ?? 0
            
        } else if collectionView == self.colleRec {
            return self.homeVM.homedataModel?.recommended?.count ?? 0
            
        } else if collectionView == self.colleTopPicks {
            return self.homeVM.homedataModel?.topPicks?.count ?? 0
        }
        return 0
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == self.colleView {
            return "HomeCategoryCVC"
            
        } else if skeletonView == self.colleBeginner {
            return "HomeListCVC"
            
        } else if skeletonView == self.colleRec {
            return "HomeListCVC"
            
        } else if skeletonView == self.colleTopPicks {
            return "HomeListCVC"
        }
        return "ExploreCVC"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        
        if skeletonView == self.colleView {
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCVC", for: indexPath) as? HomeCategoryCVC else { return UICollectionViewCell() }
            
            cell.layoutIfNeeded()
            return cell
            
        } else if skeletonView == self.colleBeginner {
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
                        
            cell.vwPremium.isHidden = true
            
            cell.layoutIfNeeded()
            return cell
            
        } else if skeletonView == self.colleRec {
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            cell.vwPremium.isHidden = true
            
            cell.layoutIfNeeded()
            return cell
            
        } else if skeletonView == self.colleTopPicks {
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            cell.vwPremium.isHidden = true
            
            cell.layoutIfNeeded()
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colleView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCVC", for: indexPath) as? HomeCategoryCVC else { return UICollectionViewCell() }
            
            cell.backgroundColor = .clear
            let current = self.homeVM.homedataModel?.category?[indexPath.row]
            cell.lblTitle.text = current?.title ?? ""
            cell.imgMain.image = nil
            GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.image ?? "")
            cell.viewImgBG.backgroundColor = .clear
            
            
            cell.layoutIfNeeded()
            return cell
            
        } else if collectionView == self.colleBeginner {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = self.homeVM.homedataModel?.beginnerPath?[indexPath.row]
            cell.lblTitle.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 18, text: current?.title ?? "")

            GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.image ?? "")
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            if current?.forSTr == "premium" && !appDelegate.isPlanPurchased {
                cell.vwPremium.isHidden = false
            } else {
                cell.vwPremium.isHidden = true
            }
            
            cell.layoutIfNeeded()
            return cell
            
        } else if collectionView == self.colleRec {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = self.homeVM.homedataModel?.recommended?[indexPath.row]
            cell.lblTitle.text = current?.title ?? ""
            GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.image ?? "")
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            if current?.forSTr == "premium" && !appDelegate.isPlanPurchased {
                cell.vwPremium.isHidden = false
            } else {
                cell.vwPremium.isHidden = true
            }
            
            cell.layoutIfNeeded()
            return cell
            
        } else if collectionView == self.colleTopPicks {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = self.homeVM.homedataModel?.topPicks?[indexPath.row]
            cell.lblTitle.text = current?.title ?? ""
            GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.image ?? "")
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            if current?.forSTr == "premium" && !appDelegate.isPlanPurchased {
                cell.vwPremium.isHidden = false
            } else {
                cell.vwPremium.isHidden = true
            }
            
            cell.layoutIfNeeded()
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.colleView {
            return CGSize(width: manageWidth(size: 130), height: manageWidth(size: 160))
            
        } else if collectionView == self.colleBeginner || collectionView == self.colleTopPicks || collectionView == self.colleRec {
            return CGSize(width: 226, height: 500)
            
        } else {
            return CGSize.zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? HomeCategoryCVC {
            //SET VIEW
            currentCell.viewImgBG.viewCorneRadius(radius: 10)
            currentCell.viewImgBG.backgroundColor = UIColor.init(hexString: "A8A8DF").withAlphaComponent(0.7)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? HomeCategoryCVC {
            //SET VIEW
            currentCell.viewImgBG.viewCorneRadius(radius: 10)
            currentCell.viewImgBG.backgroundColor = .clear
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.homeVM.currentContentId = 0
        if self.colleView == collectionView {
            
            if let currentCell = self.colleView.cellForItem(at: indexPath) as? HomeCategoryCVC {
                currentCell.viewImgBG.viewCorneRadius(radius: 10)
                currentCell.viewImgBG.backgroundColor = UIColor.init(hexString: "A8A8DF").withAlphaComponent(0.7)
                
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { tiemrss in
                    tiemrss.invalidate()
                    self.goTo_category_screen(indx: indexPath.row)
                }
            }

        } else {
            if collectionView == self.colleBeginner {
                if (self.homeVM.homedataModel?.beginnerPath?[indexPath.row].forSTr ?? "") == "premium" && !appDelegate.isPlanPurchased {
                    
                    let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                    vc.hidesBottomBarWhenPushed = true
                    vc.interstitial = self.interstitial
                    let audioVM = AudioViewModel()
                    vc.currentSong = self.homeVM.homedataModel?.beginnerPath?[indexPath.row]
                    vc.likedTapped = { like in
                        self.homeVM.homedataModel?.beginnerPath?[indexPath.row].isLiked = like
                    }
                    audioVM.arrOfAudioList = self.homeVM.homedataModel?.beginnerPath ?? []
                    vc.audioVM = audioVM
                    vc.currentSongIndex = indexPath.row
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } else if collectionView == self.colleRec {
                if (self.homeVM.homedataModel?.recommended?[indexPath.row].forSTr ?? "") == "premium" && !appDelegate.isPlanPurchased {
                    
                    let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                    vc.hidesBottomBarWhenPushed = true
                    vc.interstitial = self.interstitial
                    let audioVM = AudioViewModel()
                    vc.currentSong = self.homeVM.homedataModel?.recommended?[indexPath.row]
                    vc.likedTapped = { like in
                        self.homeVM.homedataModel?.recommended?[indexPath.row].isLiked = like
                    }
                    audioVM.arrOfAudioList = self.homeVM.homedataModel?.recommended ?? []
                    vc.audioVM = audioVM
                    vc.currentSongIndex = indexPath.row
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } else if collectionView == self.colleTopPicks {
                if (self.homeVM.homedataModel?.topPicks?[indexPath.row].forSTr ?? "") == "premium" && !appDelegate.isPlanPurchased {
                    
                    let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                    vc.hidesBottomBarWhenPushed = true
                    vc.interstitial = self.interstitial
                    let audioVM = AudioViewModel()
                    vc.currentSong = self.homeVM.homedataModel?.topPicks?[indexPath.row]
                    vc.likedTapped = { like in
                        self.homeVM.homedataModel?.topPicks?[indexPath.row].isLiked = like
                    }
                    audioVM.arrOfAudioList = self.homeVM.homedataModel?.topPicks ?? []
                    vc.audioVM = audioVM
                    vc.currentSongIndex = indexPath.row
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func goTo_category_screen(indx: Int) {
        let current = self.homeVM.homedataModel?.category?[indx]
        if current?.access_type == "video" {
            let yogaVM = VideoViewModel()
            yogaVM.catID = "\(current?.internalIdentifier ?? 0)"
            yogaVM.getVideoList { _ in
                
                if yogaVM.arrOfVideosList.count == 1 {
                    
                    let vc: YogaInstructorVC = YogaInstructorVC.instantiate(appStoryboard: .Yoga)
                    vc.titleStr = current?.title ?? ""
                    yogaVM.instructor_id = "\(yogaVM.arrOfVideosList[0].internalIdentifier ?? 0)"
                    vc.yogaVM = yogaVM
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc: YogaVC = YogaVC.instantiate(appStoryboard: .Yoga)
                    vc.hidesBottomBarWhenPushed = true
                    vc.yogaVM = yogaVM
                    vc.titleStr = current?.title ?? ""
                    vc.catID = "\(current?.internalIdentifier ?? 0)"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } failure: { errorResponse in
                
            }
        } else {
            if self.homeVM.homedataModel?.category?[indx].themeCategory?.count != 0 && self.homeVM.homedataModel?.category?[indx].themeCategory != nil {
                let vc: ExploreThemeCategoryVC = ExploreThemeCategoryVC.instantiate(appStoryboard: .Explore)
                vc.hidesBottomBarWhenPushed = true
                self.homeVM.currentCategory = self.homeVM.homedataModel?.category?[indx]
                vc.homeVM = self.homeVM
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc: ExploreSubCategoryVC = ExploreSubCategoryVC.instantiate(appStoryboard: .Explore)
                vc.hidesBottomBarWhenPushed = true
                vc.strTitle = self.homeVM.homedataModel?.category?[indx].title ?? ""
                self.homeVM.currentCategory = self.homeVM.homedataModel?.category?[indx]
                vc.homeVM = self.homeVM
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension NewHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeVM.arrOfHomeDynamic.first(where: { $0.name == "Recommended" })?.data?.count ?? 0 > 0 ? self.homeVM.arrOfHomeDynamic.count : self.homeVM.arrOfHomeDynamic.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblView.dequeueReusableCell(withIdentifier: "HomeContentTVC") as? HomeContentTVC else { return UITableViewCell() }
        let audioList = self.homeVM.arrOfHomeDynamic[indexPath.row].data ?? []
        cell.lblTitle.text = self.homeVM.arrOfHomeDynamic[indexPath.row].name
        let str_img = self.homeVM.arrOfHomeDynamic[indexPath.row].image ?? ""
        GeneralUtility().setImage(imgView: cell.img_Bg, imgPath: str_img)
        
        DispatchQueue.main.async {
//            cell.con_CollectionView.constant = manageWidth(size: 190)
        }
        
        cell.strHomeImage = self.homeVM.arrOfHomeDynamic[indexPath.row].image ?? ""
        cell.arrAudio = audioList
        cell.setupCollection()
        cell.btnSeeAll.tag = indexPath.row
        cell.interstitial = interstitial
        cell.onButtonTapped = { index in
            if (self.homeVM.arrOfHomeDynamic[indexPath.row].data?[index].forSTr ?? "") == "premium" && !appDelegate.isPlanPurchased {
                
                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                vc.hidesBottomBarWhenPushed = true
                vc.interstitial = self.interstitial
                let audioVM = AudioViewModel()
                vc.currentSong = self.homeVM.arrOfHomeDynamic[indexPath.row].data?[index]
                vc.likedTapped = { like in
                    self.self.homeVM.arrOfHomeDynamic[indexPath.row].data?[index].isLiked = like
                }
                audioVM.arrOfAudioList = self.homeVM.arrOfHomeDynamic[indexPath.row].data ?? []
                vc.audioVM = audioVM
                vc.currentSongIndex = indexPath.row
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.btnSeeAll.addTarget(self, action: #selector(seeAllTapped(_ :)), for: .touchUpInside)
        return cell
    }
    
    @objc func seeAllTapped(_ sender: UIButton) {
        let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        vc.isFromViewAll = true
        self.homeVM.currentFilterType = .none
        self.homeVM.currentAudioType = self.homeVM.arrOfHomeDynamic[sender.tag].name == "Recommended" ? .recommended : .normal
        self.homeVM.currentContentId = self.homeVM.arrOfHomeDynamic[sender.tag].id ?? 0
        self.homeVM.homeDynamic = self.homeVM.arrOfHomeDynamic[sender.tag]
        vc.homeVM = self.homeVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - OPNE POPUP

extension NewHomeVC : PreferenceProtocol{
    
    //SHOW RATING POPUP
    private func showRatingPromptIfNeeded() {
        if shouldShowRatingPrompt() {
            // Show your rating popup here
            showRatingPopup()
            let promptCount = UserDefaults.standard.integer(forKey: maxPromptCountKey)
            // Update the last prompt date and increment the prompt count
            UserDefaults.standard.set(Date(), forKey: lastPromptKey)
            UserDefaults.standard.set(promptCount + 1, forKey: maxPromptCountKey)
        }
        else{
            self.showPreferencePromptIfNeeded()
        }
    }
    
    private func shouldShowRatingPrompt() -> Bool {
        UserDefaults.standard.set(nil, forKey: userRatedApp)
        UserDefaults.standard.set(nil, forKey: lastPromptKey)
        UserDefaults.standard.set(nil, forKey: maxPromptCountKey)
        
        // Check if the user has already rated the app (replace with your rating logic)
        if UserDefaults.standard.bool(forKey: userRatedApp) {
            return false
        }

        // Get the last prompt date and prompt count
        if let lastPromptDate = UserDefaults.standard.object(forKey: lastPromptKey) as? Date {
            let promptCount = UserDefaults.standard.integer(forKey: maxPromptCountKey)
            
            // Calculate the time elapsed since the last prompt
            let timeElapsed = Date().timeIntervalSince(lastPromptDate)
            
            // Check if 7 days have passed and the prompt count is less than the maximum
            return timeElapsed >= 7 * 24 * 60 * 60 && promptCount < maxPromptCount
        } else {
            UserDefaults.standard.set(Date(), forKey: lastPromptKey)
            return false
        }
    }

   
    
    
    func showRatingPopup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            //POPUP
            let window = UIApplication.shared.keyWindow!
            window.endEditing(true)
            let popupView = AppRatePopup(frame: CGRect(x: 0, y: 0 ,width : window.frame.width, height: window.frame.height))
            popupView.loadPopUpView()
            window.addSubview(popupView)
        }
    }
    
    
    
    
    //SHOW PREFERNCE POPUP
    private func showPreferencePromptIfNeeded() {
        if shouldShowPreferencePrompt() {
            // Show your rating popup here
            showPreferencePopup()
            // Update the last prompt date and increment the prompt count
            UserDefaults.standard.set(Date(), forKey: lastPreferenceDate)
        }
    }
    
    private func shouldShowPreferencePrompt() -> Bool {
        
        // Get the last prompt date and prompt count
        if let lastPromptDate = UserDefaults.standard.object(forKey: lastPreferenceDate) as? Date {
            
            // Calculate the time elapsed since the last prompt
            let timeElapsed = Date().timeIntervalSince(lastPromptDate)
            
            // Check if 14 days have passed and the prompt count is less than the maximum
            return timeElapsed >= 14 * 24 * 60 * 60
        } else {
            UserDefaults.standard.set(Date(), forKey: lastPreferenceDate)
            return false
        }
    }
    
   
    
    func showPreferencePopup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            //POPUP
            let window = UIApplication.shared.keyWindow!
            window.endEditing(true)
            let popupView = PreferencePopup(frame: CGRect(x: 0, y: 0 ,width : window.frame.width, height: window.frame.height))
            popupView.delegate = self
            popupView.loadPopUpView()
            window.addSubview(popupView)
        }
    }
    
    func btnUpdatePreferenceClicked() {
        let vc: MyPreferencesVC = MyPreferencesVC.instantiate(appStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
