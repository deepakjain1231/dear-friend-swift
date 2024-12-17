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
        
        self.btnSkip.configureLable(bgColour: .clear, textColor: .secondary_dark, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "Skip")

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
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

