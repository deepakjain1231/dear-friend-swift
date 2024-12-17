//
//  HomeVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 02/05/23.
//

import UIKit
import SkeletonView

class HomeVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var vwRec: UIView!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBeg: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var colleTopPicks: UICollectionView!
    @IBOutlet weak var colleRec: UICollectionView!
    @IBOutlet weak var colleBeginner: UICollectionView!
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var consTopHeight: NSLayoutConstraint!
    @IBOutlet weak var consColleHeight: NSLayoutConstraint!
    
    // MARK: - VARIABLES
    var refreshControl = UIRefreshControl()
    var isAPICalling = true
    
    static var newInstance: HomeVC {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "HomeVC"
        ) as! HomeVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        definesPresentationContext = true
        
        self.setupUI()
        
        appDelegate.verifyPlanRecipt(productId: appDelegate.planIDs.first ?? "", transactionId: "") { succes in
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.relosdMYPage(_:)), name: Notification.Name("ReloadHome"), object: nil)
    }
    
    // MARK: - Other Functions
    
    @objc func relosdMYPage(_ notification: NSNotification) {
        self.getHomeData(isShowLoader: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getUser()
        self.colleRec.reloadData()
        self.colleView.reloadData()
        self.colleBeginner.reloadData()
        self.colleTopPicks.reloadData()
    }
    
    private func getUser() {
        self.lblName.text = "Hello \(CurrentUser.shared.user?.firstName ?? "")"
        CurrentUser.shared.getUserProfile { _ in
            self.lblName.text = "Hello \(CurrentUser.shared.user?.firstName ?? "")"
        } failure: { _ in
            
        }
    }
    
    private func reloadAndHide() {
        
        self.colleView.hideSkeleton()
        self.colleBeginner.hideSkeleton()
        self.colleRec.hideSkeleton()
        self.colleTopPicks.hideSkeleton()
        
        self.isAPICalling = false
        
        self.colleView.reloadData()
        self.colleBeginner.reloadData()
        self.colleRec.reloadData()
        self.colleTopPicks.reloadData()
    }
    
    private func startAnimationColle() {
        
        let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#353b48"))
        
        self.colleView.showAnimatedGradientSkeleton(usingGradient: gradient)
        self.colleBeginner.showAnimatedGradientSkeleton(usingGradient: gradient)
        self.colleRec.showAnimatedGradientSkeleton(usingGradient: gradient)
        self.colleTopPicks.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    func getHomeData(isShowLoader: Bool = true) {
        if isShowLoader {
            self.startAnimationColle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (isShowLoader ? 2 : 0)) {
            HomeViewModel.shared.getHomeData { _ in
                self.refreshControl.endRefreshing()
                self.reloadAndHide()
                
                if (HomeViewModel.shared.homedataModel?.beginnerPath?.count ?? 0) == 0 {
                    self.vwBeg.isHidden = true
                }
                
                if (HomeViewModel.shared.homedataModel?.topPicks?.count ?? 0) == 0 {
                    self.vwTop.isHidden = true
                }
                
                if (HomeViewModel.shared.homedataModel?.recommended?.count ?? 0) == 0 {
                    self.vwRec.isHidden = true
                }
                
                if (HomeViewModel.shared.homedataModel?.category?.count ?? 0) == 0 {
                    self.colleView.isHidden = true
                }
                
            } failure: { errorResponse in
                
            }
        }
    }
    
    func setupUI() {
        self.changeStyle()
        self.consTopHeight.constant = 205
        self.view.layoutIfNeeded()
        
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: HomeCategoryCVC.self)
        self.colleView.reloadData()
        self.colleView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colleView.reloadData()
        
        self.colleBeginner.setDefaultProperties(vc: self)
        self.colleBeginner.registerCell(type: HomeListCVC.self)
        self.colleBeginner.registerCell(type: ViewAllCVC.self)
        self.colleBeginner.reloadData()
        
        self.colleRec.setDefaultProperties(vc: self)
        self.colleRec.registerCell(type: HomeListCVC.self)
        self.colleRec.registerCell(type: ViewAllCVC.self)
        self.colleRec.reloadData()
        
        self.colleTopPicks.setDefaultProperties(vc: self)
        self.colleTopPicks.registerCell(type: HomeListCVC.self)
        self.colleTopPicks.registerCell(type: ViewAllCVC.self)
        self.colleTopPicks.reloadData()
        
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.vwScroll.isHidden = false
        
        self.colleRec.isSkeletonable = true
        self.colleTopPicks.isSkeletonable = true
        self.colleBeginner.isSkeletonable = true
        self.colleView.isSkeletonable = true
        
        self.refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.refreshControl.tintColor = .white
        self.vwScroll.refreshControl = self.refreshControl
        
        self.getHomeData()
    }
    
    @objc func refreshPage() {
        HomeViewModel.shared.homedataModel = nil
        self.colleView.reloadData()
        self.colleBeginner.reloadData()
        self.colleRec.reloadData()
        self.colleTopPicks.reloadData()
        self.getHomeData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UICollectionView {
            if obj == self.colleView {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if newSize.height == 0 && self.isAPICalling {
                        self.consColleHeight.constant = 300
                    } else {
                        self.consColleHeight.constant = newSize.height + 20
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnNotificationTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnchatTapped(_ sender: UIButton) {
//        let vc: ChatVC = ChatVC.instantiate(appStoryboard: .Home)
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Collection Methods

extension HomeVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if skeletonView == self.colleBeginner {
            return HomeViewModel.shared.homedataModel?.beginnerPath?.count ?? 3
            
        } else if skeletonView == self.colleTopPicks {
            return HomeViewModel.shared.homedataModel?.topPicks?.count ?? 3
            
        } else if skeletonView == self.colleRec {
            return HomeViewModel.shared.homedataModel?.recommended?.count ?? 3
        }
        return HomeViewModel.shared.homedataModel?.category?.count ?? 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colleBeginner {
            return HomeViewModel.shared.homedataModel?.beginnerPath?.count ?? 3
            
        } else if collectionView == self.colleTopPicks {
            return HomeViewModel.shared.homedataModel?.topPicks?.count ?? 3
            
        } else if collectionView == self.colleRec {
            return HomeViewModel.shared.homedataModel?.recommended?.count ?? 3
        }
        return HomeViewModel.shared.homedataModel?.category?.count ?? 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colleBeginner {
            if indexPath.row == 5 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCVC", for: indexPath) as? ViewAllCVC else { return UICollectionViewCell() }
                
                cell.layoutIfNeeded()
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = HomeViewModel.shared.homedataModel?.beginnerPath?[indexPath.row]
            
            cell.lblTitle.text = current?.title ?? ""
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
//            GeneralUtility().setImage(imgView: cell.imgUser, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            
            cell.layoutIfNeeded()
            return cell
            
        }  else if collectionView == self.colleRec {
            if indexPath.row == 5 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCVC", for: indexPath) as? ViewAllCVC else { return UICollectionViewCell() }
                
                cell.layoutIfNeeded()
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = HomeViewModel.shared.homedataModel?.recommended?[indexPath.row]
            
            cell.lblTitle.text = current?.title ?? ""
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
//            GeneralUtility().setImage(imgView: cell.imgUser, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            
            cell.layoutIfNeeded()
            return cell
            
        } else if collectionView == self.colleTopPicks {
            if indexPath.row == 5 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCVC", for: indexPath) as? ViewAllCVC else { return UICollectionViewCell() }
                
                cell.layoutIfNeeded()
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = HomeViewModel.shared.homedataModel?.topPicks?[indexPath.row]
            
            cell.lblTitle.text = current?.title ?? ""
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
//            GeneralUtility().setImage(imgView: cell.imgUser, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCVC", for: indexPath) as? HomeCategoryCVC else { return UICollectionViewCell() }
                    
            cell.imgMain.layer.cornerRadius = 25
            
            let current = HomeViewModel.shared.homedataModel?.category?[indexPath.row]
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            cell.lblTitle.text = current?.title ?? ""
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == self.colleBeginner {
            if indexPath.row == 5 {
                return "ViewAllCVC"
                
            } else {
                return "HomeListCVC"
            }
            
        } else if skeletonView == self.colleRec {
            if indexPath.row == 5 {
                return "ViewAllCVC"
                
            } else {
                return "HomeListCVC"
            }
            
        } else if skeletonView == self.colleTopPicks {
            if indexPath.row == 5 {
                return "ViewAllCVC"
                
            } else {
                return "HomeListCVC"
            }
        } else {
            return "HomeCategoryCVC"
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        
        if skeletonView == self.colleBeginner {
            if indexPath.row == 5 {
                guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "ViewAllCVC", for: indexPath) as? ViewAllCVC else { return UICollectionViewCell() }
                
                cell.layoutIfNeeded()
                return cell
            }
            
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = HomeViewModel.shared.homedataModel?.beginnerPath?[indexPath.row]
            
            cell.lblTitle.text = current?.title ?? ""
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
//            GeneralUtility().setImage(imgView: cell.imgUser, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            
            cell.layoutIfNeeded()
            return cell
            
        }  else if skeletonView == self.colleRec {
            if indexPath.row == 5 {
                guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "ViewAllCVC", for: indexPath) as? ViewAllCVC else { return UICollectionViewCell() }
                
                cell.layoutIfNeeded()
                return cell
            }
            
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = HomeViewModel.shared.homedataModel?.recommended?[indexPath.row]
            
            cell.lblTitle.text = current?.title ?? ""
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
//            GeneralUtility().setImage(imgView: cell.imgUser, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            
            cell.layoutIfNeeded()
            return cell
            
        } else if skeletonView == self.colleTopPicks {
            if indexPath.row == 5 {
                guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "ViewAllCVC", for: indexPath) as? ViewAllCVC else { return UICollectionViewCell() }
                
                cell.layoutIfNeeded()
                return cell
            }
            
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeListCVC", for: indexPath) as? HomeListCVC else { return UICollectionViewCell() }
            
            let current = HomeViewModel.shared.homedataModel?.topPicks?[indexPath.row]
            
            cell.lblTitle.text = current?.title ?? ""
            let ddd = current?.audioDuration?.doubleValue ?? 0
            cell.lblTime.text = TimeInterval(ddd).formatDuration()
            
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
//            GeneralUtility().setImage(imgView: cell.imgUser, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCVC", for: indexPath) as? HomeCategoryCVC else { return UICollectionViewCell() }
                    
            cell.imgMain.layer.cornerRadius = 25
            
            let current = HomeViewModel.shared.homedataModel?.category?[indexPath.row]
            GeneralUtility().setImage(imgView: cell.imgMain, placeHolderImage: placeholderImage, imgPath: current?.image ?? "")
            cell.lblTitle.text = current?.title ?? ""
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.colleView {
            return CGSize(width: (self.view.frame.size.width - 16) / 3, height: 115)
        } else {
            if collectionView == self.colleRec && indexPath.row == 5 {
                return CGSize(width: 157, height: 193)
            }
            if collectionView == self.colleTopPicks && indexPath.row == 5 {
                return CGSize(width: 157, height: 193)
            }
            if collectionView == self.colleBeginner && indexPath.row == 5 {
                return CGSize(width: 157, height: 193)
            }
            return CGSize(width: 200, height: 230)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.colleView {
            if indexPath.row == 0 {
                let vc: YogaVC = YogaVC.instantiate(appStoryboard: .Yoga)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
//                let vc: ExploreSubCategoryVC = ExploreSubCategoryVC.instantiate(appStoryboard: .Explore)
//                vc.hidesBottomBarWhenPushed = true
//                HomeViewModel.shared.currentCategory = HomeViewModel.shared.homedataModel?.category?[indexPath.row]
//                vc.currentIndex = indexPath.row
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else if indexPath.row == 5 && collectionView != self.colleView {
            let vc: TopPicsListVC = TopPicsListVC.instantiate(appStoryboard: .Home)
            vc.hidesBottomBarWhenPushed = true
            let audioVM = AudioViewModel()
            if collectionView == self.colleRec {
                audioVM.currentAudioType = .recommended
            }
            if collectionView == self.colleTopPicks {
                audioVM.currentAudioType = .top_picks
            }
            if collectionView == self.colleBeginner {
                audioVM.currentAudioType = .beginner
            }
            vc.audioVM = audioVM
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
        }
    }
}
