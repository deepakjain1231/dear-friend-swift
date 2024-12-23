//
//  ExploreVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 02/05/23.
//

import UIKit
import SkeletonView

class ExploreVC: BaseVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var colleView: UICollectionView!
    
    // MARK: - VARIABLES
    
    var refreshControl = UIRefreshControl()
    var indexx: IndexPath?
    var homeVM = HomeViewModel()
    
    static var newInstance: ExploreVC {
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "ExploreVC"
        ) as! ExploreVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setTheView()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Explore")
    }
    
    // MARK: - Other Functions
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.homeVM.homedataModel?.category?.count ?? 0) == 0 {
            self.setupUI()
        }
    }
    
    func setupUI() {
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: ExploreCVC.self)
        self.colleView.reloadData()
        self.colleView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 100, right: 0)
        self.colleView.alwaysBounceVertical = true
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.colleView.addSubview(self.refreshControl)
        
        self.getHomeData()
    }
    
    @objc func loadData() {
        self.colleView.refreshControl?.beginRefreshing()
        self.getHomeData()
    }
    
    func getHomeData() {
        let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#212159"))
        self.colleView.isSkeletonable = true
        self.colleView.showAnimatedGradientSkeleton(usingGradient: gradient)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.homeVM.getHomeData { _ in
                self.refreshControl.endRefreshing()
                self.colleView.hideSkeleton()
                self.colleView.reloadData()
                self.colleView.restore()
                
                if (self.homeVM.homedataModel?.category?.count ?? 0) == 0 {
                    self.colleView.setEmptyMessage("No Categories Found")
                }
                
                self.view.layoutIfNeeded()
                
            } failure: { errorResponse in
                
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        popupVC?.height = 310
        popupVC?.presentDuration = 0.5
        popupVC?.dismissDuration = 0.5
        DispatchQueue.main.async {
            self.present(popupVC!, animated: true, completion: nil)
        }
    }
}

// MARK: - Collection Methods

extension ExploreVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeVM.homedataModel?.category?.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ExploreCVC"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: "ExploreCVC", for: indexPath) as? ExploreCVC else { return UICollectionViewCell() }
        
        cell.layoutIfNeeded()
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCVC", for: indexPath) as? ExploreCVC else { return UICollectionViewCell() }
        
        cell.vwMain2.layer.cornerRadius = 20
        cell.vwMain2.layer.borderWidth = 1
        cell.vwMain2.layer.borderColor = hexStringToUIColor(hex: "#776ADA").cgColor
        cell.vwMain2.backgroundColor = .primary?.withAlphaComponent(0.7)
        
//        if self.indexx == indexPath {
//            cell.vwMain2.backgroundColor = hexStringToUIColor(hex: "#776ADA")
//        } else {
//            cell.vwMain2.backgroundColor = hexStringToUIColor(hex: "#212159")
//        }
                        
        let current = self.homeVM.homedataModel?.category?[indexPath.row]
        cell.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 30, text: current?.title ?? "")
        GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.image ?? "")
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width - 40), height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexx = indexPath
        self.colleView.reloadData()
        let current = self.homeVM.homedataModel?.category?[indexPath.row]
        if current?.access_type == "video" {
            var yogaVM = VideoViewModel()
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

            if self.homeVM.homedataModel?.category?[indexPath.row].themeCategory?.count != 0 && self.homeVM.homedataModel?.category?[indexPath.row].themeCategory != nil{
                let vc: ExploreThemeCategoryVC = ExploreThemeCategoryVC.instantiate(appStoryboard: .Explore)
                vc.hidesBottomBarWhenPushed = true
                self.homeVM.currentCategory = self.homeVM.homedataModel?.category?[indexPath.row]
                vc.homeVM = self.homeVM
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc: ExploreSubCategoryVC = ExploreSubCategoryVC.instantiate(appStoryboard: .Explore)
                vc.hidesBottomBarWhenPushed = true
                vc.strTitle = self.homeVM.homedataModel?.category?[indexPath.row].title ?? ""
                self.homeVM.currentCategory = self.homeVM.homedataModel?.category?[indexPath.row]
                vc.homeVM = self.homeVM
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

