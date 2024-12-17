//
//  CustomAudioRequestVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 19/10/23.
//

import UIKit
import BetterSegmentedControl

class CustomAudioRequestVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var segmentType: BetterSegmentedControl!
    
    // MARK: - VARIABLES
    
    var customVM = CreateCustomAudioViewModel()
    var isFromSuccess = false
    
    static var newInstance: CustomAudioRequestVC {
        let storyboard = UIStoryboard(name: "CreateMusic", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "CustomAudioRequestVC"
        ) as! CustomAudioRequestVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.setSegment()
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: NewMusicListTVC.self)
        self.tblMain.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        self.tblMain.restore()
        self.customVM.arrOfCustomRequests.removeAll()
        self.tblMain.reloadData()
        
        self.customVM.type = "open"
        self.getListing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getListing()
    }
    
    func getListing() {
        if let topVc = UIApplication.topViewController2(), topVc is CustomAudioRequestVC {
            self.customVM.getCustomAudioRequests { _ in
                DispatchQueue.main.async {
                    self.tblMain.restore()
                    self.tblMain.reloadData()
                    if self.customVM.arrOfCustomRequests.count == 0 {
                        self.tblMain.setEmptyMessage("No Custom Audio Requests Found")
                    }
                }
            } failure: { errorResponse in
                
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnInfoTapped(_ sender: UIButton) {
        let vc: CreateSectionVC = CreateSectionVC.instantiate(appStoryboard: .CreateMusic)
        vc.isFromInfo = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if self.isFromSuccess {
            appDelegate.setTabbarRoot()
        } else {
            self.goBack(isGoingTab: true)
        }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        let vc: CreateStep1VC = CreateStep1VC.instantiate(appStoryboard: .CreateMusic)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Tableview Methods

extension CustomAudioRequestVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customVM.arrOfCustomRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "NewMusicListTVC") as? NewMusicListTVC else { return UITableViewCell() }
        
        let current = self.customVM.arrOfCustomRequests[indexPath.row]
        
        cell.isForCustom = true
        cell.btnmore.setBackgroundImage(UIImage(named: "ic_right3"), for: .normal)
        cell.lblTitle.text = current.meditationName ?? ""
        cell.lblSub.text = current.format ?? ""
        cell.lblSub.font = Font(.installed(.Regular), size: .standard(.S14)).instance
        cell.lblSub.textColor = hexStringToUIColor(hex: "#D2CDF3")
        cell.img.image = UIImage(named: "ic_pref_temp")
        
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.segmentType.index == 2 {
            return
        }
        let current = self.customVM.arrOfCustomRequests[indexPath.row]
        let vc: ChatMessageVC = ChatMessageVC.instantiate(appStoryboard: .CreateMusic)
        self.customVM.currentCustomID = "\(current.internalIdentifier ?? 0)"
        self.customVM.currenRequest = current
        vc.chatVM = self.customVM
        vc.isForCompleted = self.segmentType.index == 1
        vc.isPaymentDone = (current.requestStatus ?? "") == "Completed"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

//MARK: - Segment Set

extension CustomAudioRequestVC {
    
    func setSegment() {
        
        let fontSelected = Font(.installed(.Regular), size: .custom(16.0)).instance
        let fontUnSelected = Font(.installed(.Regular), size: .custom(16.0)).instance
        
        let normalBGClr : UIColor = hexStringToUIColor(hex: "#212159")
        let selectedBGClr : UIColor = hexStringToUIColor(hex: "#363C8A")
        
        let normalFontClr : UIColor = hexStringToUIColor(hex: "#E4E1F8")
        let selectedFontClr : UIColor = hexStringToUIColor(hex: "#E4E1F8")
        
        self.segmentType.segments = LabelSegment.segments(withTitles: ["Open", "Completed", "Cancelled"], numberOfLines: 1, normalBackgroundColor: normalBGClr, normalFont: fontUnSelected, normalTextColor: normalFontClr, selectedBackgroundColor: selectedBGClr, selectedFont: fontSelected, selectedTextColor: selectedFontClr)
        
        self.segmentType.tintColor = .clear
        self.segmentType.borderColor = .clear
        self.segmentType.addTarget(self, action: #selector(segmentedTapped(_:)), for: .valueChanged)
    }
    
    @objc func segmentedTapped(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.customVM.type = "open"
        } else if sender.index == 1 {
            self.customVM.type = "completed"
        } else {
            self.customVM.type = "cancel"
        }
        self.customVM.arrOfCustomRequests.removeAll()
        self.tblMain.reloadData()
        self.getListing()
    }
}
