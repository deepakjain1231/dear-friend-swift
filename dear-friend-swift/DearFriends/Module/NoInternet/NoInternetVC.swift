//
//  NoInternetVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 06/06/23.
//

import UIKit

class NoInternetVC: BaseVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var viewTryAgin: UIView!
    @IBOutlet weak var lblTryAgin: UILabel!
    @IBOutlet weak var btnDownload: UIButton!

    // MARK: - VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setTheView()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        
    }
    
    
    
    //SET THE VIEW
    func setTheView() {
    
        //SET FONT
        self.lblTitle.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Ooops!")
        self.lblDescription.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "No internet connection,\ncheck your internet settings")
        
    
        self.btnDownload.configureLable(bgColour: .secondary, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 18.0, text: "Go to My Downloads")
        self.lblTryAgin.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 18.0, text: "Try Again")

        //SET VIEW
        self.viewTryAgin.viewCorneRadius(radius: 0)
        self.viewTryAgin.backgroundColor = .primary?.withAlphaComponent(0.7)
        self.viewTryAgin.viewBorderCorneRadius(borderColour: .secondary)

    }
    
    // MARK: - Button Actions
    
    @IBAction func btnTryAgainTapped(_ sender: UIButton) {
        if Reach().connectionStatus().description != ReachabilityStatus.offline.description {
            appDelegate.manageNoNet()
        } else {
            GeneralUtility().showErrorMessage(message: "No Internet Connection!!")
        }
    }
    
    @IBAction func btnDownloadsTapped(_ sender: UIButton) {
        let vc: MyHistoryVC = MyHistoryVC.instantiate(appStoryboard: .Profile)
        vc.currentScreen = .download
        vc.hidesBottomBarWhenPushed = true
        vc.isFromNoNet = true
        
        if let nav = self.navigationController {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let nav: UINavigationController = UINavigationController(rootViewController: self)
            nav.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
