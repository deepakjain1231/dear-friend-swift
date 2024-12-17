//
//  MyBookingVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 08/09/23.
//

import UIKit
import BetterSegmentedControl
import SwiftDate

class MyBookingVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var segmentType: BetterSegmentedControl!
    @IBOutlet weak var colleView: UICollectionView!
    
    // MARK: - VARIABLES
    
    var bookingVM = BookingViewModel()
    var isForSuccess = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.setSegment()
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: MyBookingCVC.self)
        self.colleView.reloadData()
        self.colleView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 80, right: 10)
        
        self.bookingVM.status = "pending"
        self.getMyBooking()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.relosdMYDetailPage(_:)), name: Notification.Name("ReloadBooking"), object: nil)
    }
    
    @objc func relosdMYDetailPage(_ notification: NSNotification) {
        self.bookingVM.status = "pending"
        self.segmentType.setIndex(0)
        self.getMyBooking()
    }
    
    func getMyBooking() {
        self.bookingVM.getBookingList { _ in
            
            self.colleView.restore()
            self.colleView.reloadData()
            
            if self.segmentType.index == 0 && self.bookingVM.arrOfUpcomingBooking.count == 0 {
                self.colleView.setEmptyMessage("No booking found.")
                
            } else if self.segmentType.index == 1 && self.bookingVM.arrOfCompletedBooking.count == 0 {
                self.colleView.setEmptyMessage("No booking found.")
            }
            
        } failure: { errorResponse in
            
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if self.isForSuccess {
            appDelegate.setTabbarRoot()
        } else {
            self.goBack(isGoingTab: true)
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

//MARK: - Segment Set

extension MyBookingVC {
    
    func setSegment() {
        
        let fontSelected = Font(.installed(.Regular), size: .custom(16.0)).instance
        let fontUnSelected = Font(.installed(.Regular), size: .custom(16.0)).instance
        
        let normalBGClr : UIColor = hexStringToUIColor(hex: "#212159")
        let selectedBGClr : UIColor = hexStringToUIColor(hex: "#363C8A")
        
        let normalFontClr : UIColor = hexStringToUIColor(hex: "#E4E1F8")
        let selectedFontClr : UIColor = hexStringToUIColor(hex: "#E4E1F8")
        
        self.segmentType.segments = LabelSegment.segments(withTitles: ["Upcoming", "Completed"], numberOfLines: 1, normalBackgroundColor: normalBGClr, normalFont: fontUnSelected, normalTextColor: normalFontClr, selectedBackgroundColor: selectedBGClr, selectedFont: fontSelected, selectedTextColor: selectedFontClr)
        
        self.segmentType.tintColor = .clear
        self.segmentType.borderColor = .clear
        self.segmentType.addTarget(self, action: #selector(segmentedTapped(_:)), for: .valueChanged)
    }
    
    @objc func segmentedTapped(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.bookingVM.status = "pending"
        } else {
            self.bookingVM.status = "completed"
        }
        self.getMyBooking()
    }
}

// MARK: - Collection Methods

extension MyBookingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.segmentType.index == 0 {
            return self.bookingVM.arrOfUpcomingBooking.count
        } else {
            return self.bookingVM.arrOfCompletedBooking.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyBookingCVC", for: indexPath) as? MyBookingCVC else { return UICollectionViewCell() }
        
        var currentBooking: MyBookingListModel?
        
        if self.segmentType.index == 0 {
            currentBooking = self.bookingVM.arrOfUpcomingBooking[indexPath.row]
            cell.btnDetails.setTitle("View Details", for: .normal)
        } else {
            currentBooking = self.bookingVM.arrOfCompletedBooking[indexPath.row]
            cell.btnDetails.setTitle("Download Receipt", for: .normal)
        }
        
        if let current = currentBooking {
            cell.lblName.text = current.instructor?.name ?? ""
            cell.lblSub.text = current.instructor?.title ?? ""
            GeneralUtility().setImage(imgView: cell.imgUser, imgPath: current.instructor?.profileImage ?? "")
            cell.lblDate.text = current.bookingDate?.toDate("yyyy-MM-dd", region: .UTC)?.convertTo(region: .local).toFormat("dd MMM, yyyy", locale: Locale(identifier: "en_US_POSIX"))
   
            let dateTime = "\(current.bookingDate ?? "") \(current.bookingTime ?? "")"
            cell.lblTime.text = dateTime.toDate("yyyy-MM-dd HH:mm:ss", region: .UTC)?.convertTo(region: .local).toFormat("hh.mm a", locale: Locale(identifier: "en_US_POSIX"))
            cell.lblPrice.text = String(format: "%.2f", current.payAmount ?? 0)
        }
        
        cell.detailsTapped = {
            if self.segmentType.index == 0 {
                let vc: BookingDetailsVC = BookingDetailsVC.instantiate(appStoryboard: .MyBookings)
                self.bookingVM.currentBooking = currentBooking
                vc.id = "\(currentBooking?.internalIdentifier ?? 0)"
                vc.bookingVM = self.bookingVM
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                if let urlr = URL(string: currentBooking?.receiptLink ?? "") {
                    DispatchQueue.main.async {
                        self.SHOW_CUSTOM_LOADER()
                        DispatchQueue.global(qos: .background).async {
                            // do your job here
                            FileDownloader.loadFileAsync(url: urlr) { (path, error) in
                                print("PDF File downloaded to : \(path!)")
                                DispatchQueue.main.async {
                                    self.HIDE_CUSTOM_LOADER()
                                    showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "File downloaded successfully.", buttons: ["OKAY"]) { index in
                                        let path = self.getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                                        if let url = URL(string: path) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    GeneralUtility().showSuccessMessage(message: "URL not valid")
                }
            }
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func getDocumentsDirectory() -> URL { // returns your application folder
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width - 20) / 2, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var currentBooking: MyBookingListModel?
        if self.segmentType.index == 0 {
            currentBooking = self.bookingVM.arrOfUpcomingBooking[indexPath.row]
        } else {
            currentBooking = self.bookingVM.arrOfCompletedBooking[indexPath.row]
        }
        let vc: BookingDetailsVC = BookingDetailsVC.instantiate(appStoryboard: .MyBookings)
        self.bookingVM.currentBooking = currentBooking
        vc.id = "\(currentBooking?.internalIdentifier ?? 0)"
        vc.bookingVM = self.bookingVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.colleView.contentOffset.y >= ((self.colleView.contentSize.height - self.colleView.bounds.size.height) - 200) {
            if self.segmentType.index == 0 {
                if !self.bookingVM.isAPICallingForUpcoming {
                    self.bookingVM.isAPICallingForUpcoming = true
                    if self.bookingVM.hasMoreDataForUpcoming {
                        self.bookingVM.offsetForUpcoming += self.bookingVM.limitForUpcoming
                        self.getMyBooking()
                    }
                }
            } else {
                if !self.bookingVM.isAPICallingForBooking {
                    self.bookingVM.isAPICallingForBooking = true
                    if self.bookingVM.hasMoreDataForBooking {
                        self.bookingVM.offsetForBooking += self.bookingVM.limitForBooking
                        self.getMyBooking()
                    }
                }
            }
        }
    }
}
