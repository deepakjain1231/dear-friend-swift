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
        self.colleView.registerCell(type: MusicCategoryCVC.self)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCategoryCVC", for: indexPath) as? MusicCategoryCVC else { return UICollectionViewCell() }
       
        let current = self.homeVM.currentCategory?.subCategory?[indexPath.row]
        GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.icon ?? "")
        
        //SET VIEW
        cell.vwMain.viewCorneRadius(radius: 25)
        cell.vwMain.backgroundColor = .primary?.withAlphaComponent(0.7)
        cell.vwMain.viewBorderCorneRadius(borderColour: .secondary)
        
        cell.lblTitle.configureLable(textAlignment: .center, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 18, text: current?.title ?? "")
        
        
//        cell.consWidth.isActive = false
//        cell.consHeight.isActive = false
        
//        cell.consHeight.constant = 100
        
        cell.layoutIfNeeded()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width - 20) / 2, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? MusicCategoryCVC {
            currentCell.vwMain.backgroundColor = hexStringToUIColor(hex: "#A8A8DF").withAlphaComponent(0.7)
            
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timerrrs in
                timerrrs.invalidate()
                
                let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
                vc.hidesBottomBarWhenPushed = true
                self.homeVM.currentFilterType = .none
                self.homeVM.currentAudioType = .normal
                self.homeVM.currentSubCategory = self.homeVM.currentCategory?.subCategory?[indexPath.row]
                vc.homeVM = self.homeVM
                self.navigationController?.pushViewController(vc, animated: true)
                
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timerrrs in
                    timerrrs.invalidate()
                    collectionView.reloadData()
                }
            }
        }
        
    }
}
