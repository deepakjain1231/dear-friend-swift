//
//  OnbordingVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 01/05/23.
//

import UIKit
import JXPageControl

class OnbordingVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consLeft: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var pageControl: JXPageControlScale!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var view_AboutBG: UIView!
    @IBOutlet weak var lbl_about_creator_title: UILabel!
    @IBOutlet weak var lbl_about_creator_subtitle: UILabel!
    @IBOutlet weak var img_about_arrow: UIImageView!

    @IBOutlet weak var btnSkip: UIButton!

    // MARK: - VARIABLES
    
    var currentIndex = 0
    var arrOfOnboarding = [OnboardingListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setTheView()
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        self.changeStyle()
        self.pageControl.numberOfPages = self.arrOfOnboarding.count
        self.pageControl.currentPage = self.currentIndex
        self.pageControl.hidesForSinglePage = true
        
        self.lblTitle.text = self.arrOfOnboarding[self.currentIndex].title ?? ""
        self.lblSubTitle.text = self.arrOfOnboarding[self.currentIndex].descriptionValue ?? ""
        GeneralUtility().setImage(imgView: self.imgMain, placeHolderImage: nil, imgPath: self.arrOfOnboarding[self.currentIndex].image ?? "")
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 24, text: "")
        self.lblSubTitle.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "")
        
        self.lbl_about_creator_title.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "About the Creator")
        self.lbl_about_creator_subtitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Meet Your Guide")
        
        self.btnSkip.configureLable(bgColour: .clear, textColor: .secondary_dark, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "Skip")

        self.img_about_arrow.viewCorneRadius(radius: 9)
        
        //SET VIEW
        self.view_AboutBG.viewCorneRadius(radius: 15)
        self.view_AboutBG.backgroundColor = .primary
        self.view_AboutBG.viewBorderCorneRadius(borderColour: .secondary)
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnSkipTapped(_ sender: UIButton) {
        appDelegate.setLoginRoot(isSignupScreen: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if self.currentIndex == self.arrOfOnboarding.count - 1 {
            appDelegate.setLoginRoot(isSignupScreen: true)
        } else {
            let vc: OnbordingVC = OnbordingVC.instantiate(appStoryboard: .main)
            vc.currentIndex = 1
            vc.arrOfOnboarding = self.arrOfOnboarding
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btn_aboutCreatorTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.view_AboutBG.backgroundColor = .secondary
            self.view_AboutBG.viewBorderCorneRadius(borderColour: .primary)
            self.img_about_arrow.viewBorderCorneRadius(borderColour: .primary)
        } completion: { completed in
            let vc: AboutCreatorVC = AboutCreatorVC.instantiate(appStoryboard: .main)
            self.navigationController?.pushViewController(vc, animated: false)
            self.screen_back_refresh()
        }
    }
    
    func screen_back_refresh() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timerrr in
            timerrr.invalidate()
            self.setTheView()
        }
    }
    
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

