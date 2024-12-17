//
//  CreateStep1VC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 19/10/23.
//

import UIKit

class CreateStep1VC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var tblMain: UITableView!
    
    // MARK: - VARIABLES
    
    var index = -1
    var arrOfFormat = ["Breath Focus", "Visualization", "Series of Affirmations", "Combination"]
    var arrOfFormat2 = ["breath_focus", "visualization", "series_of_affirmations", "combination"]
    var customVM = CreateCustomAudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: FormatSelectionTVC.self)
        self.tblMain.reloadData()
        self.tableHeightManage()
    }
    
    func tableHeightManage() {
        self.tblMain.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblMain.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblMain {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.consHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if self.index == -1 {
            GeneralUtility().showErrorMessage(message: "Please select your format")
            return
        }
        self.customVM.format = self.arrOfFormat2[self.index]
        let vc: CreateStep2VC = CreateStep2VC.instantiate(appStoryboard: .CreateMusic)
        vc.customVM = self.customVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Tableview Methods

extension CreateStep1VC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfFormat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "FormatSelectionTVC") as? FormatSelectionTVC else { return UITableViewCell() }       
        
        if self.index == indexPath.row {
            cell.vwMain.borderWidth = 1
            cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#363C8A")
            cell.img.image = UIImage(named: "ic_radio_sel")
        } else {
            cell.vwMain.borderWidth = 0
            cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#212159")
            cell.img.image = UIImage(named: "ic_radio_unsel")
        }
        
        cell.lblTitle.text = self.arrOfFormat[indexPath.row]
        
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.tblMain.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
