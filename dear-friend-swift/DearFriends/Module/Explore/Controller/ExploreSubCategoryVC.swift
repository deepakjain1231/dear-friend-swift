//
//  ExploreSubCategoryVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 16/05/23.
//

import UIKit
import CollectionViewPagingLayout

class ExploreSubCategoryVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var colleView: UICollectionView!
    
    // MARK: - VARIABLES
    
    var currentIndex = 0
    var homeVM = HomeViewModel()
    var strTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: TopCategoryCVC.self)
        self.colleView.reloadData()
        self.lblTitle.text = self.strTitle
        
        self.colleView.restore()
        if (self.homeVM.currentCategory?.subCategory?.count ?? 0) == 0 {
            self.colleView.setEmptyMessage("No Sub Categories found")
        }
    }
        
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

extension ExploreSubCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeVM.currentCategory?.subCategory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryCVC", for: indexPath) as? TopCategoryCVC else { return UICollectionViewCell() }
       
        let current = self.homeVM.currentCategory?.subCategory?[indexPath.row]
        GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.icon ?? "")
        cell.lblTitle.text = current?.title ?? ""
//        cell.consWidth.isActive = false
//        cell.consHeight.isActive = false
        
//        cell.consHeight.constant = 100
        
        cell.layoutIfNeeded()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width - 20) / 3, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        self.homeVM.currentFilterType = .none
        self.homeVM.currentAudioType = .normal
        self.homeVM.currentSubCategory = self.homeVM.currentCategory?.subCategory?[indexPath.row]
        vc.homeVM = self.homeVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
