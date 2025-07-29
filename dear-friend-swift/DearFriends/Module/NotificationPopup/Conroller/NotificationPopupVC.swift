//
//  NotificationPopupVC.swift
//  SuperdiaDriver
//
//  Created by Himanshu Visroliya on 09/03/24.
//

import UIKit

class NotificationPopupVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - VARIABLES
    
    var homeVM = HomeViewModel()
    var titleText = ""
    var descText = ""
    var customID = ""
    var reloadIndex: intCloser?
    var isFromPush = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        
//        self.con_img.constant = 0
//        self.img.isHidden = true
//        if self.file != ""{
//            self.img.isHidden = false
//            self.con_img.constant = manageWidth(size: 520)
//            GeneralUtility().setImage(imgView: self.img, imgPath: self.file)
//            
//            self.img.backgroundColor = .clear
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                self.img.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
//            })
//            
//        }
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblSub.text = self.descText
        self.lblTitle.text = self.titleText
        
        if self.isFromPush {
            self.homeVM.readNotifcation(id: "\(self.customID)", isShowLoader: false) { success in
             
                if let index = self.homeVM.arrOfNotifications.firstIndex(where: {$0.internalIdentifier == Int(self.customID)}) {
                    self.reloadIndex?(index)
                }
                
            } failure: { errorResponse in
                
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        appDelegate.isFromPush = false
        appDelegate.isOpenedFromNoti = false
        self.dismiss(animated: true)
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods

