//
//  InfoPopupVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 24/10/23.
//

import UIKit
import BottomPopup

class InfoPopupVC: BottomPopupViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var stackGoal: UIStackView!
    @IBOutlet weak var stackFile: UIStackView!
    @IBOutlet weak var lblScripFile: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - VARIABLES
    
    var chatVM = CreateCustomAudioViewModel()
    
    var height: CGFloat = 0.0
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var shouldBeganDismiss: Bool?
    
    override var popupHeight: CGFloat { return height }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    override var popupShouldBeganDismiss: Bool { return shouldBeganDismiss ?? true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblTitle.text = self.chatVM.currenRequest?.goalsAndChallenges ?? ""
        self.btnDownload.roundCornersWithMask(corners: [.topRight, .bottomRight], radius: 8)
        
        if (self.chatVM.currenRequest?.script ?? "") != "" {
            self.stackFile.isHidden = false
            self.stackGoal.isHidden = true
            if let urlr = URL(string: self.chatVM.currenRequest?.script ?? "") {
                self.lblScripFile.text = urlr.lastPathComponent
            }
            
            self.view.layoutIfNeeded()
            self.updatePopupHeight(to: self.vwMain.frame.size.height)
            self.view.layoutIfNeeded()
            
        } else {
            self.stackGoal.isHidden = false
            self.stackFile.isHidden = true
            self.view.layoutIfNeeded()
            self.updatePopupHeight(to: self.vwMain.frame.size.height + 20)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnDownloadTapped(_ sender: UIButton) {
        if let urlr = URL(string: self.chatVM.currenRequest?.script ?? "") {
            DispatchQueue.main.async {
                self.SHOW_CUSTOM_LOADER()
                DispatchQueue.global(qos: .background).async {
                    // do your job here
                    FileDownloader.loadFileAsync(url: urlr) { (path, error) in
                        print("PDF File downloaded to : \(path!)")
                        DispatchQueue.main.async {
                            GeneralUtility().showSuccessMessage(message: "\(urlr.lastPathComponent) saved successfully")
                            self.HIDE_CUSTOM_LOADER()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
