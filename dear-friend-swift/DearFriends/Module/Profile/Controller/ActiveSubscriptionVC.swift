//
//  ActiveSubscriptionVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/09/23.
//

import UIKit
import SwiftDate
import Mixpanel

class ActiveSubscriptionVC: UIViewController {
    
    // MARK: - OUTLETS
//    @IBOutlet weak var con_logo: NSLayoutConstraint!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var lblExpiryTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNamesubTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblIncludeTitle: UILabel!
    
    @IBOutlet weak var lbl_plan1_title: UILabel!
    @IBOutlet weak var lbl_plan2_title: UILabel!
    @IBOutlet weak var lbl_plan3_title: UILabel!
    @IBOutlet weak var lbl_plan4_title: UILabel!
    @IBOutlet weak var lbl_plan5_title: UILabel!
    @IBOutlet weak var lbl_plan6_title: UILabel!
    @IBOutlet weak var lbl_plan7_title: UILabel!

    @IBOutlet weak var lbl_plan1_subtitle: UILabel!
    @IBOutlet weak var lbl_plan2_subtitle: UILabel!
    @IBOutlet weak var lbl_plan3_subtitle: UILabel!
    @IBOutlet weak var lbl_plan4_subtitle: UILabel!
    @IBOutlet weak var lbl_plan5_subtitle: UILabel!
    @IBOutlet weak var lbl_plan6_subtitle: UILabel!
    @IBOutlet weak var lbl_plan7_subtitle: UILabel!

    @IBOutlet weak var btnChangePlan: UIButton!
    @IBOutlet weak var lbl_disclaimer: UILabel!

    @IBOutlet weak var viewAnimtion: UIView!
    var imageview : UIImageView!

    
    // MARK: - VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.setupUI()
        self.setLogoAnimation()
        
    }
    
    
    func setLogoAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            do {
                let gif = try UIImage(gifName: "DearFriend_logo")
                self.imageview = UIImageView(gifImage: gif, loopCount: 1) // Will loop 3 times
                self.imageview.backgroundColor = .clear
                self.imageview.frame = CGRect(x: 0, y: 0, width: self.viewAnimtion.frame.size.width, height: self.viewAnimtion.frame.size.height)
                self.imageview.backgroundColor = .clear
                self.imageview.tag = 100
                self.viewAnimtion.addSubview(self.imageview)
           
            } catch {
//                self.acti.isHidden = false
            }
        })
    }

    //SET THE VIEW
    func setTheView() {
//        self.con_logo.constant = manageWidth(size: 220)

        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "My Subscription")
        
        self.lblName.configureLable(textColor: hexStringToUIColor(hex: "#E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 16, text: "")
        self.lblNamesubTitle.configureLable(textColor: hexStringToUIColor(hex: "#E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "You are now a Member")
        
        self.lblPrice.configureLable(textColor: hexStringToUIColor(hex: "#E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Bold, fontSize: 18, text: "")
        self.lblDuration.configureLable(textColor: hexStringToUIColor(hex: "#E0E0E3"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "")
        
        self.lblStatusTitle.configureLable(textColor: hexStringToUIColor(hex: "#B2B1B9"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "Status")
        self.lblStatus.configureLable(textColor: hexStringToUIColor(hex: "#E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_SemiBold, fontSize: 14, text: "")
        
        self.lblExpiryTitle.configureLable(textColor: hexStringToUIColor(hex: "#B2B1B9"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "Valid Till")
        self.lblExpiry.configureLable(textColor: hexStringToUIColor(hex: "#B2B1B9"), fontName: GlobalConstants.OUTFIT_FONT_SemiBold, fontSize: 14, text: "")
                
        self.lblIncludeTitle.configureLable(textAlignment: .center, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20, text: "Includes:")

        self.lbl_plan1_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Ad-Free Experience")
        self.lbl_plan2_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Offline Accessibility")
        self.lbl_plan3_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Extensive Meditation Library")
        self.lbl_plan4_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Comprehensive Music Selection")
        self.lbl_plan5_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Nature Sounds Collection")
        self.lbl_plan6_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Background Audio Options")
        self.lbl_plan7_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Content Progress Bar")

        //SubTitles
        self.lbl_plan1_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Enjoy uninterrupted access to your favorite meditations, music, and nature sounds and sleep tools.")
        self.lbl_plan2_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Download and enjoy your favorite meditations and tracks anytime, anywhere.")
        self.lbl_plan3_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Explore the full  collection of over 250+ guided meditations across 30+ unique categories. (This figure includes all the content in “Sleep”)")
        self.lbl_plan4_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Get full access to over 250 musical tracks, thoughtfully organized by instrument and style.")
        self.lbl_plan5_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Unlock a library of over 300  high-quality nature recordings from around the world.")
        self.lbl_plan6_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Enhance your experience with a full suite of background audio options designed to support relaxation and focus.")
        self.lbl_plan7_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "See your progress at a glance with the Content Progress Bar. A purple line shows how far you’ve listened, while a white check mark and subtle gray line appear when the content is complete. This gentle guide helps you easily continue where you left off, and also encourages you to revisit your favorites anytime you want.")

        self.btnChangePlan.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 18.0, text: "Change Plan")
        
        self.lbl_disclaimer.configureLable(textAlignment: .center, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "Disclaimer:\nThe numbers provided on this page (e.g., over 250 musical tracks, over 300 nature sounds, and over 250 meditations) are estimates and subject to change. We are constantly improving and updating our content library, which may involve adding new content, removing older content, or replacing existing material. As a result, the exact number of available tracks, sounds, and meditations may fluctuate over time. We strive to maintain a high-quality experience for our users, and these changes are part of our ongoing commitment to improvement. Thank you for your understanding.")
    }
    
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblName.text = CurrentUser.shared.user?.name ?? ""
        if appDelegate.isPlanPurchased {
            self.lblStatus.text = "Active"
        } else {
            self.lblStatus.text = "Expired"
        }
        
        if CurrentUser.shared.user?.planType == "" && appDelegate.isPlanPurchased {
            let expDate = CurrentUser.shared.user?.expiryDate?.toDate()?.convertTo(region: .local).toFormat("dd MMM, yyyy")
            self.lblPrice.isHidden = true
            self.lblExpiry.text = expDate
            self.lblDuration.text = "Free Trial"
            
        } else {
            self.lblExpiry.text = CurrentUser.shared.user?.expiryDate?.toDate()?.convertTo(region: .local).toFormat("dd MMM, yyyy")
            self.lblPrice.isHidden = false
            if (CurrentUser.shared.user?.planType ?? "") == "yearly" {
                self.lblPrice.text = "$49.99"
                self.lblDuration.text = "Year"
            } else if (CurrentUser.shared.user?.planType ?? "") == "monthly" {
                self.lblPrice.text = "$6.99"
                self.lblDuration.text = "Month"
            } else {
                self.lblPrice.text = "-"
                self.lblDuration.text = "-"
                self.lblExpiry.text = "-"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
        
    @IBAction func btnChangeTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: Mixpanel_Event.CancelPremium.rawValue, properties: nil)

        
        let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
