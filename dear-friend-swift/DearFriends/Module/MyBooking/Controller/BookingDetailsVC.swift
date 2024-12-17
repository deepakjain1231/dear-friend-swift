//
//  BookingDetailsVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 14/09/23.
//

import UIKit
import ExpandableLabel
import SwiftDate

class BookingDetailsVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var imgLine2: UIImageView!
    @IBOutlet weak var stackLinkForRes: UIStackView!
    @IBOutlet weak var lblLinkForRes: UILabel!
    @IBOutlet weak var lblPriceForRes: UILabel!
    @IBOutlet weak var lblTimeForRes: UILabel!
    @IBOutlet weak var lblDateForRes: UILabel!
    @IBOutlet weak var stackForReshedule: UIStackView!
    @IBOutlet weak var stackForOriginal: UIStackView!
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var imgLine: UIImageView!
    @IBOutlet weak var stackLink: UIStackView!
    @IBOutlet weak var btnResh: AppButton!
    @IBOutlet weak var lblDesc: AppExpandableLabel!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblURL: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    // MARK: - VARIABLES
    
    var bookingVM = BookingViewModel()
    var isExpanded = false
    var id = ""
    var isFromPush = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.getDetails()
    }
    
    func dataBind() {
        if let current = self.bookingVM.currentBooking {
            self.stackMain.isHidden = false
            self.lblName.text = current.instructor?.name ?? ""
            self.lblSub.text = current.instructor?.title ?? ""
            GeneralUtility().setImage(imgView: self.imgUser, imgPath: current.instructor?.profileImage ?? "")
            self.lblDesc.setupLabel()
            self.view.layoutIfNeeded()
            self.lblDesc.collapsed = !self.isExpanded
            self.lblDesc.text = current.instructor?.aboutInstructor ?? ""
            self.lblDesc.delegate = self
            self.view.layoutIfNeeded()
            self.vwBottom.isHidden = ((current.status ?? "") == "completed")
            
            if let bookingHistory = current.bookingHistory {
                self.stackForOriginal.isHidden = false
                self.displayOriginalbooking(bookingDate: bookingHistory.bookingDate ?? "", bookingTime: bookingHistory.bookingTime ?? "", payAmount: bookingHistory.payAmount ?? 0, createdAt: bookingHistory.createdAt ?? "", reschedule_counter: 1, meeting_link: bookingHistory.meetingLink ?? "")
                self.displayBookingForReschedule(current: current)
                
            } else {
                self.displayOriginalbooking(bookingDate: current.bookingDate ?? "", bookingTime: current.bookingTime ?? "", payAmount: current.payAmount ?? 0, createdAt: current.createdAt ?? "", reschedule_counter: current.reschedule_counter, meeting_link: current.meeting_link)
                self.stackForReshedule.isHidden = true
                self.stackForOriginal.isHidden = false
            }
        }
    }
    
    func displayBookingForReschedule(current: MyBookingListModel) {
        self.lblDateForRes.text = current.bookingDate?.toDate("yyyy-MM-dd", region: .UTC)?.convertTo(region: .local).toFormat("dd MMM, yyyy", locale: Locale(identifier: "en_US_POSIX"))
        let dateTime = "\(current.bookingDate ?? "") \(current.bookingTime ?? "")"
        let myBookDateTime = dateTime.toDate("yyyy-MM-dd HH:mm:ss", region: .UTC)?.convertTo(region: .local)
        self.lblTimeForRes.text = myBookDateTime?.toFormat("hh.mm a", locale: Locale(identifier: "en_US_POSIX"))
        self.lblPriceForRes.text = "\(smallAppCurrency)\(String(format: "%.2f", current.payAmount ?? 0))"
        self.lblLinkForRes.text = current.meeting_link
        
        if current.meeting_link == "" {
            self.stackLinkForRes.isHidden = true
            self.imgLine2.isHidden = true
        } else {
            self.stackLinkForRes.isHidden = false
            self.imgLine2.isHidden = false
        }
        
        self.stackForReshedule.isHidden = false
    }
    
    func displayOriginalbooking(bookingDate: String, bookingTime: String, payAmount: Double, createdAt: String, reschedule_counter: Int, meeting_link: String) {
        
        self.lblDate.text = bookingDate.toDate("yyyy-MM-dd", region: .UTC)?.convertTo(region: .local).toFormat("dd MMM, yyyy", locale: Locale(identifier: "en_US_POSIX"))
        let dateTime = "\(bookingDate) \(bookingTime)"
        let myBookDateTime = dateTime.toDate("yyyy-MM-dd HH:mm:ss", region: .UTC)?.convertTo(region: .local)
        self.lblTime.text = myBookDateTime?.toFormat("hh.mm a", locale: Locale(identifier: "en_US_POSIX"))
        self.lblPrice.text = "\(smallAppCurrency)\(String(format: "%.2f", payAmount))"
        self.lblURL.text = meeting_link
        
        if meeting_link == "" {
            self.stackLink.isHidden = true
            self.imgLine.isHidden = true
        } else {
            self.stackLink.isHidden = false
            self.imgLine.isHidden = false
        }
        
        let createDateTime = createdAt.toDate(region: .UTC)?.convertTo(region: .local)
        let now = Date().convertTo(region: .local).date
        if let bookDate = createDateTime?.date {
            let minute = hoursBetweenDates(startDate: bookDate, endDate: now) ?? 0
            print("minute between dates: \(minute)")
            if minute > 1440 && reschedule_counter == 0 {
                self.vwBottom.isHidden = false
            } else {
                self.vwBottom.isHidden = true
            }
        }
    }
    
    func getDetails() {
        self.bookingVM.getBookingDetails(id: self.id) { _ in
            self.dataBind()
        } failure: { errorResponse in
            
        }
    }
    
    func hoursBetweenDates(startDate: Date, endDate: Date) -> Int? {
        let calendar = Calendar.current
        
        // Get the components from the start and end dates
        let components = calendar.dateComponents([.minute], from: startDate, to: endDate)
        
        // Extract the hour difference
        if let hours = components.minute {
            return hours
        }
        
        return nil
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if self.isFromPush {
            appDelegate.setTabbarRoot()
            
        } else {
            self.goBack(isGoingTab: true)
        }
    }
    
    @IBAction func btnURLTapped(_ sender: UIButton) {
        guard let url = URL(string: self.bookingVM.currentBooking?.meeting_link ?? "") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func btnRescheduleTapped(_ sender: UIButton) {
        let vc: RescheduleVC = RescheduleVC.instantiate(appStoryboard: .MyBookings)
        vc.bookingVM = self.bookingVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

extension BookingDetailsVC: ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        self.view.layoutIfNeeded()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        self.isExpanded = true
        self.lblDesc.collapsed = !self.isExpanded
        self.view.layoutIfNeeded()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.view.layoutIfNeeded()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        self.isExpanded = false
        self.lblDesc.collapsed = !self.isExpanded
        self.view.layoutIfNeeded()
    }
}
