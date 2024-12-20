//
//  MyPreferencesTVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 15/09/23.
//

import UIKit
import SkeletonView

class MyPreferencesTVC: UITableViewCell {

    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var imDown: UIImageView!
    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var consColleHeight: NSLayoutConstraint!
    @IBOutlet weak var vwBlank: UIView!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var isSelectedRow = false
    
    var arrOfSubCategory = [SubCategory]()
    var reloadSub: reloadMainCate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.viewImgBG.viewCorneRadius(radius: 10)
        
        self.colleView.delegate = self
        self.colleView.dataSource = self
        self.colleView.registerCell(type: MyPreferencesCVC.self)
        self.colleView.reloadData()
        self.colleView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colleView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UICollectionView {
            if obj == self.colleView {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if self.arrOfSubCategory.count == 0 {
                        self.consColleHeight.constant = 100
                    } else {
                        self.consColleHeight.constant = newSize.height
                    }
                    self.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: - Collection Methods

extension MyPreferencesTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfSubCategory.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPreferencesCVC", for: indexPath) as? MyPreferencesCVC else { return UICollectionViewCell() }
        
        let current = self.arrOfSubCategory[indexPath.row]
        
        let str_currentTile = current.title ?? ""
        cell.lblTitle.configureLable(textAlignment: .center, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 13, text: str_currentTile)
        
        GeneralUtility().setImage(imgView: cell.img, imgPath: current.icon ?? "")
        
        cell.vwMain.borderWidth = 1
        cell.vwMain.borderColor = UIColor.white.withAlphaComponent(0.12)
        cell.imgBG.isHidden = false
        cell.vwMain.backgroundColor = .clear
        
        if current.isSelect {
            cell.imgBG.isHidden = true
            cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#363C8A")
        }
//        else {
//            let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#212159"))
////            cell.vwMain.isSkeletonable = true
//            cell.vwMain.showAnimatedGradientSkeleton(usingGradient: gradient)
//
////            cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#212159")
//        }
//        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.colleView.frame.size.width - 24) / 3, height: 112)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.arrOfSubCategory[indexPath.row].isSelect = !self.arrOfSubCategory[indexPath.row].isSelect
        self.reloadSub?(self.arrOfSubCategory)
        self.colleView.reloadData()
    }
}
