//
//  RescheduleVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 14/09/23.
//

import UIKit

class RescheduleVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblDec: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    // MARK: - VARIABLES
    
    var bookingVM = BookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.btnCheck.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        self.btnCheck.setImage(UIImage(named: "ic_checked"), for: .selected)
        
        self.lblDec.text = "You are about to reschedule your existing 1-1 booking.\n\nPlease note the following terms and conditions: \n - Users are allowed to reschedule appointments once only, provided they do so at least 24 hours prior to the scheduled time.\n - Upon confirmation of your re-scheduled appointment,  your instructor will update your existing booking with a new zoom link for your review.\n - You will receive a notification when the new zoom link is provided.\n\nThank you."
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
        vc.currentType = .user_agreement_booking
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        if !self.btnCheck.isSelected {
            GeneralUtility().showErrorMessage(message: "Please accept terms and conditions before continue")
            return
        }
        let vc: RescheduleCalendarVC = RescheduleCalendarVC.instantiate(appStoryboard: .MyBookings)
        let vm = VideoViewModel()
        vm.instructor_id = "\(self.bookingVM.currentBooking?.instructor?.internalIdentifier ?? 0)"
        vm.bookingID = "\(self.bookingVM.currentBooking?.internalIdentifier ?? 0)"
        vm.currentBooking = self.bookingVM.currentBooking
        vc.yogaVM = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
