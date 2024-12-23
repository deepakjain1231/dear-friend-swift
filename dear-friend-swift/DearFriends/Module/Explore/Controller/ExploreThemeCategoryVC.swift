//
//  ExploreThemeCategoryVC.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 29/11/24.
//

import UIKit
import CollectionViewPagingLayout

class ExploreThemeCategoryVC: BaseVC {

    // MARK: - OUTLETS
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var colleView: UICollectionView!
   
    // MARK: - VARIABLES
    
    var currentIndex = 0
    var homeVM = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
    }

    // MARK: - Other Functions
    
    func setupUI() {
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: TopCategoryCVC.self)
        self.colleView.reloadData()
        self.lblTitle.text = self.homeVM.currentCategory?.title ?? ""
        
        self.colleView.restore()
        if (self.homeVM.currentCategory?.themeCategory?.count ?? 0) == 0 {
            self.colleView.setEmptyMessage("No Theme Categories found")
        }
    }
        
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
}


// MARK: - Tableview Methods

// MARK: - Collection Methods

extension ExploreThemeCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeVM.currentCategory?.themeCategory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryCVC", for: indexPath) as? TopCategoryCVC else { return UICollectionViewCell() }
       
        //SET VIEW
        cell.vwMain.viewCorneRadius(radius: 40)
        cell.vwMain.backgroundColor = .primary?.withAlphaComponent(0.7)
        cell.vwMain.viewBorderCorneRadius(borderColour: .secondary)
        
        let current = self.homeVM.currentCategory?.themeCategory?[indexPath.row]
        GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.icon ?? "")
        cell.lblTitle.text = current?.title ?? ""
        
        cell.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 20, text: current?.title ?? "")
//        cell.consWidth.isActive = false
//        cell.consHeight.isActive = false
        
//        cell.consHeight.constant = 100
        
        cell.layoutIfNeeded()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width - 20), height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ExploreSubCategoryVC = ExploreSubCategoryVC.instantiate(appStoryboard: .Explore)
        vc.hidesBottomBarWhenPushed = true
        vc.strTitle = self.homeVM.currentCategory?.themeCategory?[indexPath.row].title ?? ""
        self.homeVM.currentThemeCategory = self.homeVM.currentCategory?.themeCategory?[indexPath.row]
        self.homeVM.currentCategory?.subCategory = self.homeVM.currentCategory?.themeCategory?[indexPath.row].subCategory
//        self.homeVM.currentSubCategory = self.homeVM.currentCategory?.subCategory?[indexPath.row]
        vc.homeVM = self.homeVM
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
