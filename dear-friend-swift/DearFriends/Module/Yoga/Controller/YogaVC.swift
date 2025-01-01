//
//  YogaVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 18/09/23.
//

import UIKit

class YogaVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblMain: UITableView!
    
    // MARK: - VARIABLES
    
    var catID = ""
    var yogaVM = VideoViewModel()
    var titleStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblTitle.text = self.titleStr
        self.yogaVM.catID = self.catID
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: YogaListTVC.self)
        self.tblMain.registerCell(type: LoadingTVC.self)
        self.tblMain.reloadData()
        
        if self.yogaVM.arrOfVideosList.count == 0 {
            self.getVideoListing()
        }
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
    }
    
    func getVideoListing() {
        self.yogaVM.getVideoList { _ in
            self.tblMain.restore()
            self.tblMain.reloadData()
            
            if self.yogaVM.arrOfVideosList.count == 0 {
                self.tblMain.setEmptyMessage("No instructors found")
            }
            
        } failure: { errorResponse in
            
        }
    }
    
    // MARK: - Button Actions
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
}

// MARK: - Tableview Methods

extension YogaVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.yogaVM.arrOfVideosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LoadingTVC") as? LoadingTVC else { return UITableViewCell() }
            
            cell.loader.stopAnimating()
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "YogaListTVC") as? YogaListTVC else { return UITableViewCell() }
            
            cell.lblName.text = self.yogaVM.arrOfVideosList[indexPath.row].name ?? ""
            cell.lblType.text = self.yogaVM.arrOfVideosList[indexPath.row].title ?? ""
            GeneralUtility().setImage(imgView: cell.imgUser, imgPath: self.yogaVM.arrOfVideosList[indexPath.row].profileImage ?? "")
            cell.current = self.yogaVM.arrOfVideosList[indexPath.row]
            cell.colleView.reloadData()
           
            cell.yogaTapped = {
                let vc: YogaInstructorVC = YogaInstructorVC.instantiate(appStoryboard: .Yoga)
                vc.hidesBottomBarWhenPushed = true
                vc.titleStr = self.titleStr
                self.yogaVM.instructor_id = "\(self.yogaVM.arrOfVideosList[indexPath.row].internalIdentifier ?? 0)"
                vc.yogaVM = self.yogaVM
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tblMain.contentOffset.y >= (self.tblMain.contentSize.height - self.tblMain.bounds.size.height) {
            if (self.yogaVM.arrOfVideosList.count) >= 10 {
                if !(self.yogaVM.isAPICalling) {
                    self.yogaVM.isAPICalling = true
                    if self.yogaVM.hasMoreData {
                        self.yogaVM.offset += self.yogaVM.limit
                        self.getVideoListing()
                    }
                }
            }
        }
    }
}
