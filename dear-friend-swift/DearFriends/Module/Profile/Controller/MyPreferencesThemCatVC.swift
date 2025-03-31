//
//  MyPreferencesThemCatVC.swift
//  DearFriends
//
//  Created by DEEPAK JAIN on 31/03/25.
//

import UIKit
import SkeletonView
import SwiftyJSON

class MyPreferencesThemCatVC: BaseVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btn_Save: AppButton!
    
    @IBOutlet weak var tblMain: UITableView!
        
    // MARK: - VARIABLES
    var current_index: Int = 0
    var profileVM = ProfileViewModel()
    var reload: voidCloser?
    var indexRow = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: self.profileVM.arrOfCategory[self.current_index].title ?? "")
        
        self.btn_Save.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Update")
        self.btn_Save.backgroundColor = .buttonBGColor
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: MyPreferencesTVC.self)
        self.tblMain.registerCell(type: LoadingTVC.self)
        let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#212159"))
        self.tblMain.isSkeletonable = true
        self.tblMain.showAnimatedGradientSkeleton(usingGradient: gradient)
        self.tblMain.reloadData()
        self.getHomeData()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        self.profileVM.updatePreferences { _ in
            appDelegate.setTabbarRoot()
            CurrentUser.shared.getUserProfile { _ in
            } failure: { _ in
            }
            
        } failure: { errorResponse in
            
        }
    }
    
    func getHomeData() {
        
        self.profileVM.arrOfCategory[self.current_index].themeCategory?.forEach { subcates in
            subcates.subCategory?.forEach({ category in
                if CurrentUser.shared.user?.preferences?.contains("\(category.internalIdentifier ?? 0)") ?? false {
                    category.isSelect = true
                } else {
                    category.isSelect = false
                }
            })
        }

        self.tblMain.hideSkeleton()
        self.tblMain.reloadData()
        self.tblMain.restore()
    }
}

// MARK: - Tableview Methods

extension MyPreferencesThemCatVC: SkeletonTableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.profileVM.arrOfCategory[self.current_index].themeCategory?.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 0
        }
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if indexPath.section == 1 {
            return "LoadingTVC"
        }
        return "MyPreferencesTVC"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        if indexPath.section == 1 {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LoadingTVC") as? LoadingTVC else { return UITableViewCell() }
            
            cell.loader.stopAnimating()
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "MyPreferencesTVC") as? MyPreferencesTVC else { return UITableViewCell() }
            
            let gradient = SkeletonGradient(baseColor: hexStringToUIColor(hex: "#212159"))
            cell.vwMain.isSkeletonable = true
            cell.vwMain.showAnimatedGradientSkeleton(usingGradient: gradient)
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LoadingTVC") as? LoadingTVC else { return UITableViewCell() }
            
            cell.loader.stopAnimating()
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "MyPreferencesTVC") as? MyPreferencesTVC else { return UITableViewCell() }
            
            var dic_current = self.profileVM.arrOfCategory[self.current_index].themeCategory?[indexPath.row]
            
            let str_currentTile = dic_current?.title ?? ""
            cell.lblTitle.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: str_currentTile)
            
            GeneralUtility().setImage(imgView: cell.img, placeHolderImage: placeholderImage, imgPath: dic_current?.icon ?? "")
            
            let count = "\(dic_current?.subCategory?.filter({$0.isSelect}).count ?? 0)"
            cell.lblSelected.configureLable(textColor: .text_color_light, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "(\(count) selected)")
                        
            GeneralUtility().changeTextColor(substring: count, string: "(\(count) selected)", foregroundColor: hexStringToUIColor(hex: "#7884E0"), label: cell.lblSelected)
            
            if self.indexRow.contains(indexPath.row) {
                cell.isSelectedRow = true
                cell.lblLine.isHidden = false
                cell.colleView.isHidden = false
                cell.vwBlank.isHidden = false
                cell.imDown.image = UIImage(named: "ic_down_pref2")
            } else {
                cell.isSelectedRow = false
                cell.lblLine.isHidden = true
                cell.colleView.isHidden = true
                cell.vwBlank.isHidden = true
                cell.imDown.image = UIImage(named: "ic_down_pref")
            }
            
            cell.reloadSub = { newArray in
                self.profileVM.arrOfCategory[self.current_index].themeCategory?[indexPath.row].subCategory = newArray
                dic_current = self.profileVM.arrOfCategory[self.current_index].themeCategory?[indexPath.row]
                let count = "\(dic_current?.subCategory?.filter({$0.isSelect}).count ?? 0)"
                cell.lblSelected.text = "(\(count) selected)"
                
                GeneralUtility().changeTextColor(substring: count, string: "(\(count) selected)", foregroundColor: hexStringToUIColor(hex: "#7884E0"), label: cell.lblSelected)
            }
            
            cell.colleView.restore()
            cell.arrOfSubCategory = dic_current?.subCategory ?? []
            cell.colleView.reloadData()
            
            DispatchQueue.main.async {
                cell.colleView.reloadData()
            }
            
            if (dic_current?.subCategory?.count ?? 0) == 0 {
                cell.colleView.setEmptyMessage("No Subcategories Found")
            }
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let gradientColor = CAGradientLayer.init(frame: cell.vwMain.frame, colors: GradientBGColors, direction: GradientDirection.Bottom).creatGradientImage() {
                    cell.vwMain.backgroundColor = UIColor.init(patternImage: gradientColor)
                    cell.vwMain.layoutIfNeeded()
                }
            }
            
            
            
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.indexRow.contains(indexPath.row) {
            self.indexRow.removeAll(where: {$0 == indexPath.row})
        } else {
            self.indexRow.append(indexPath.row)
        }

        self.tblMain.beginUpdates()
        self.tblMain.reloadRows(at: [indexPath], with: .fade)
        self.tblMain.endUpdates()
        
        
    }
}
