//
//  RequestDetailsVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 24/10/23.
//

import UIKit

class RequestDetailsVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblReqTitle: UILabel!
    @IBOutlet weak var lblVoice: UILabel!
    @IBOutlet weak var lblPause: UILabel!
    @IBOutlet weak var lblScriptDetails: UILabel!
    @IBOutlet weak var lblFormat: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - VARIABLES
    
    var chatVM = CreateCustomAudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblTitle.text = self.chatVM.currenRequest?.meditationName ?? ""
        self.lblFormat.text = self.chatVM.currenRequest?.format ?? ""
        
        self.lblPause.text = self.chatVM.currenRequest?.pauseDuration ?? ""
        if (self.chatVM.currenRequest?.voiceId ?? 0) == 2 {
            self.lblVoice.text = "Female"
        } else {
            self.lblVoice.text = "Male"
        }
        
        if (self.chatVM.currenRequest?.script ?? "") != "" {
            self.lblScriptDetails.text = "I have my own script"
        } else {
            self.lblScriptDetails.text = self.chatVM.currenRequest?.goalsAndChallenges ?? ""
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnInfoTapped(_ sender: UIButton) {
        let popupVC: InfoPopupVC = InfoPopupVC.instantiate(appStoryboard: .CreateMusic)
        popupVC.height = 260
        popupVC.chatVM = self.chatVM
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.topCornerRadius = 16
        DispatchQueue.main.async {
            if let topVc = UIApplication.topViewController2() {
                topVc.present(popupVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
