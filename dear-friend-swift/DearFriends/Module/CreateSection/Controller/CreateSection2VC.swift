//
//  CreateSection2VC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 19/10/23.
//

import UIKit

class CreateSection2VC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnSubmit: AppButton!
    @IBOutlet weak var vwTerms: UIView!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var btnCheck: UIButton!
    
    // MARK: - VARIABLES
    
    var isFromInfo = false
    
    var arrOfDecs = ["Answer a few questions and we'll start writing your custom meditation.",
                     "Review the initial draft. If needed, suggest edits and coordinate directly with your script writing assistant to further personalize your script.",
                     "Approve the final draft once you're completely satisfied with it.",
    "Submit your payment. As part of our special launch offer, you can create your personalized meditation at the exclusive price of just $49.99. (Standard pricing will increase to $59.99 after the 3 month promo) We've tailored our process so that payment is only required after you've approved the final draft of your script (in textual form).  Your package includes the following: - A dedicated scriptwriting assistant with extensive writing experience. - A personalized recording that you will own, edited and recorded by a pro.",
    "Access your custom audio file directly in-app or download for offline use on any device. Your personalized meditation journey begins now."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.btnCheck.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        self.btnCheck.setImage(UIImage(named: "ic_checked"), for: .selected)
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: TimelineTVC.self)
        self.tblMain.reloadData()
        self.tableHeightManage()
        
        if self.isFromInfo {
            self.vwTerms.isHidden = true
            self.btnSubmit.setTitle("Done", for: .normal)
        }
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
    
    @IBAction func btnCheckTapped(_ sender: UIButton) {
        self.btnCheck.isSelected = !self.btnCheck.isSelected
    }
    
    @IBAction func btnTermsTapped(_ sender: UIButton) {
        let vc: CommonWebViewVC = CommonWebViewVC.instantiate(appStoryboard: .Profile)
        vc.hidesBottomBarWhenPushed = true
        vc.currentType = .user_agreement_create_section
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if self.isFromInfo {
            self.navigationController?.popToViewController(ofClass: CustomAudioRequestVC.self, animated: true)
            
        } else {
            if !self.btnCheck.isSelected {
                GeneralUtility().showErrorMessage(message: "Please accept terms and conditions before continue")
                let bottomOffset = CGPoint(x: 0, y: self.vwScroll.contentSize.height - self.vwScroll.bounds.height + self.vwScroll.contentInset.bottom)
                self.vwScroll.setContentOffset(bottomOffset, animated: true)
                return
            }
            let vc: CreateStep1VC = CreateStep1VC.instantiate(appStoryboard: .CreateMusic)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Tableview Methods

extension CreateSection2VC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfDecs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "TimelineTVC") as? TimelineTVC else { return UITableViewCell() }
        
        cell.lblStep.text = "Step-\(indexPath.row + 1):"
        cell.lblDec.text = self.arrOfDecs[indexPath.row]
        
        if indexPath.row == self.arrOfDecs.count - 1 {
            cell.vwLine.isHidden = true
        } else {
            cell.vwLine.isHidden = false
        }
        
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

class VerticalDottedLineView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        DispatchQueue.main.async {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.size.width / 2, y: rect.origin.y))
            path.addLine(to: CGPoint(x: rect.size.width / 2, y: rect.size.height))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = hexStringToUIColor(hex: "#8E83E0").cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [4, 4]  // Adjust the values to change the length of dashes and gaps
            
            shapeLayer.path = path.cgPath
            self.layer.addSublayer(shapeLayer)
        }
    }
}
