//
//  RescheduleCalendarVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 14/09/23.
//

import UIKit
import FSCalendar
import SwiftDate

class RescheduleCalendarVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var stackTime: UIStackView!
    @IBOutlet weak var btnContinue: AppButton!
    @IBOutlet weak var consColleHeight: NSLayoutConstraint!
    @IBOutlet weak var consCalendarHeight: NSLayoutConstraint!
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewCalendar: FSCalendar!
    
    // MARK: - VARIABLES
    
    var minimumDate = Date()
    var maximumDate = Date()
    var yogaVM = VideoViewModel()
    var isFromYoga = false
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var indexSel = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        if self.isFromYoga {
            self.lblTitle.text = "Schedule"
        }
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.setupCalendar()
    }
    
    func setupCalendar() {
        self.vwScroll.isUserInteractionEnabled = false
        self.vwScroll.alpha = 0
        self.btnContinue.isUserInteractionEnabled = false
        self.btnContinue.alpha = 0
        
        self.viewCalendar.delegate = self
        self.viewCalendar.dataSource = self
        self.viewCalendar.today = nil
        self.viewCalendar.scrollEnabled = false
        self.viewCalendar.scope = .month
        self.viewCalendar.setCurrentPage(Date(), animated: false)
        self.viewCalendar.firstWeekday = 2
        self.viewCalendar.allowsMultipleSelection = false
        self.viewCalendar.backgroundColor = .clear
        self.viewCalendar.appearance.weekdayTextColor = hexStringToUIColor(hex: "#D2CDF3")
        self.viewCalendar.appearance.titleFont = Font(.installed(.Regular), size: .standard(.S14)).instance
        self.viewCalendar.appearance.weekdayFont = Font(.installed(.Regular), size: .standard(.S16)).instance
        
        let now = self.viewCalendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let nameOfMonth = dateFormatter.string(from: now)
        self.lblMonth.text = nameOfMonth
        
        if Calendar.current.component(.month, from: self.viewCalendar.currentPage) == Calendar.current.component(.month, from: Date()) {
            self.btnPrevious.alpha = 0.5
            self.btnPrevious.isUserInteractionEnabled = false
            
        } else {
            self.btnPrevious.alpha = 1
            self.btnPrevious.isUserInteractionEnabled = true
        }
        
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: ScheduleTimeCVC.self)
        self.colleView.reloadData()
        self.colleView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colleView.reloadData()
        
        if self.isFromYoga {
            self.yogaVM.booking_time = ""
            self.yogaVM.selDates = ""
            self.btnContinue.setTitle("Schedule Session", for: .normal)
        }
        
        self.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())?.date ?? Date()
        self.getCalendarDates()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UICollectionView {
            if obj == self.colleView {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    if self.yogaVM.arrOfTimes.count == 0 {
                        self.consColleHeight.constant = 100
                    } else {
                        self.consColleHeight.constant = newSize.height + 20
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func getCalendarDates() {
        
        self.yogaVM.start_date = self.viewCalendar.currentPage.dateAtStartOf(.month).date.convertTo(region: .local).toFormat("yyyy-MM-dd", locale: Locale(identifier: "en_US_POSIX"))
        self.yogaVM.end_date = self.viewCalendar.currentPage.dateAtEndOf(.month).date.convertTo(region: .local).toFormat("yyyy-MM-dd", locale: Locale(identifier: "en_US_POSIX"))
        
        self.yogaVM.getAvailbleDats { _ in
            self.vwScroll.alpha = 1
            self.vwScroll.isUserInteractionEnabled = true
            self.btnContinue.alpha = 1
            self.btnContinue.isUserInteractionEnabled = true
            self.viewCalendar.reloadData()
            
            self.yogaVM.arrOfTimes.removeAll()
            self.colleView.reloadData()
            self.colleView.setEmptyMessage("Please Select Date!")
            
        } failure: { error in
            
        }
    }
    
    func getTimeSlots(date: Date) {
        
        self.yogaVM.selDates = date.convertTo(region: .local).toFormat("yyyy-MM-dd")
        self.yogaVM.booking_time = ""
        
        self.yogaVM.getAvailbleTimeSlot { _ in
            self.colleView.restore()
            self.colleView.reloadData()
            if self.yogaVM.arrOfTimes.count == 0 {
                self.colleView.setEmptyMessage("Time slots not available")
            }
            
        } failure: { error in
            
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        
        if self.yogaVM.selDates == "" {
            GeneralUtility().showErrorMessage(message: "Please select date")
            return
        }
        if self.yogaVM.booking_time == "" {
            GeneralUtility().showErrorMessage(message: "Please select time")
            return
        }
        
        if self.isFromYoga {
            let vc: YogaPaymentPageVC = YogaPaymentPageVC.instantiate(appStoryboard: .Yoga)
            vc.yogaVM = self.yogaVM
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.yogaVM.bookVideo(isShowLoader: true) { _ in
                let vc: SuccessfullBookingVC = SuccessfullBookingVC.instantiate(appStoryboard: .MyBookings)
                vc.isReschdule = true
                vc.yogaVM = self.yogaVM
                self.navigationController?.pushViewController(vc, animated: true)
            } failure: { errorResponse in
                
            }
        }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        self.viewCalendar.select(nil)
        let previousDate = self.gregorian.date(byAdding: .month, value: 1, to: self.viewCalendar.currentPage)!
        self.viewCalendar.setCurrentPage(previousDate, animated: true)
        let now = self.viewCalendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let nameOfMonth = dateFormatter.string(from: now)
        self.lblMonth.text = nameOfMonth
        
        if Calendar.current.component(.month, from: self.viewCalendar.currentPage) == Calendar.current.component(.month, from: Date()) {
            self.btnPrevious.alpha = 0.5
            self.btnPrevious.isUserInteractionEnabled = false
            
        } else {
            self.btnPrevious.alpha = 1
            self.btnPrevious.isUserInteractionEnabled = true
        }
        
        let addOneMonth = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        if Calendar.current.component(.month, from: self.viewCalendar.currentPage) == Calendar.current.component(.month, from: addOneMonth!) {
            self.btnNext.alpha = 0.5
            self.btnNext.isUserInteractionEnabled = false
            
        } else {
            self.btnNext.alpha = 1
            self.btnNext.isUserInteractionEnabled = true
        }
        
        self.getCalendarDates()
    }
    
    @IBAction func btnPreviousTapped(_ sender: UIButton) {
        self.viewCalendar.select(nil)
        let previousDate = self.gregorian.date(byAdding: .month, value: -1, to: self.viewCalendar.currentPage)!
        self.viewCalendar.setCurrentPage(previousDate, animated: true)
        let now = self.viewCalendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let nameOfMonth = dateFormatter.string(from: now)
        self.lblMonth.text = nameOfMonth
        
        if Calendar.current.component(.month, from: self.viewCalendar.currentPage) == Calendar.current.component(.month, from: Date()) {
            self.btnPrevious.alpha = 0.5
            self.btnPrevious.isUserInteractionEnabled = false
            
        } else {
            self.btnPrevious.alpha = 1
            self.btnPrevious.isUserInteractionEnabled = true
        }
        
        self.btnNext.alpha = 1
        self.btnNext.isUserInteractionEnabled = true
        
        self.getCalendarDates()
    }
}

//MARK: - FSCalendarDelegate && FSCalendarDataSource

extension RescheduleCalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return minimumDate
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return maximumDate
    }
    
    func isThisDateBetweenThis(dateUserTapped: Date) -> Bool {
        let currentDate = dateUserTapped.convertTo(region: .local).toFormat("yyyy-MM-dd")
        if let current = self.yogaVM.arrOfDates.filter({$0.date == currentDate}).first {
            if (current.isOpen ?? 0) == 0 {
                return false
            }
        }
        
        let result = compareDatesByMonth(date1: dateUserTapped.convertTo(region: .local).date, date2: self.viewCalendar.currentPage.convertTo(region: .local).date)
        
        if result == .orderedAscending || result == .orderedDescending {
            return false
        } else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("didSelect", date.convertTo(region: .local))
        self.getTimeSlots(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return self.isThisDateBetweenThis(dateUserTapped: date)
    }
    
    func compareDatesByMonth(date1: Date, date2: Date) -> ComparisonResult {
        let calendar = Calendar.current

        // Extract components
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)

        // Create new dates using only year and month components
        guard let newDate1 = calendar.date(from: components1),
              let newDate2 = calendar.date(from: components2) else {
            fatalError("Error creating new dates.")
        }

        // Compare the new dates
        return newDate1.compare(newDate2)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let currentDate = date.convertTo(region: .local).toFormat("yyyy-MM-dd")
        if let current = self.yogaVM.arrOfDates.filter({$0.date == currentDate}).first {
            if (current.isOpen ?? 0) == 0 {
                return hexStringToUIColor(hex: "#656372")
            }
        }
        
        let result = compareDatesByMonth(date1: date.convertTo(region: .local).date, date2: self.viewCalendar.currentPage.convertTo(region: .local).date)
        
        switch result {
        case .orderedAscending:
            return hexStringToUIColor(hex: "#656372")
        case .orderedSame:
            break
        case .orderedDescending:
            return hexStringToUIColor(hex: "#656372")
        }
 
        let currentDateM = GeneralUtility().convertToDateFromString(olddate: date)
        if currentDateM == GeneralUtility().convertToDateFromString(olddate: minimumDate) || currentDateM == GeneralUtility().convertToDateFromString(olddate: maximumDate) {
            return hexStringToUIColor(hex: "#E4E1F8")
            
        } else if date.compare(minimumDate) == .orderedDescending && date.compare(maximumDate) == .orderedAscending {
            return hexStringToUIColor(hex: "#E4E1F8")
            
        } else {
            return hexStringToUIColor(hex: "#656372")
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return hexStringToUIColor(hex: "#776ADA")
    }
   
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return hexStringToUIColor(hex: "#D2CDF3")
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.consCalendarHeight.constant = bounds.height + 20
        self.view.layoutIfNeeded()
    }
}

// MARK: - Collection Methods

extension RescheduleCalendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.yogaVM.arrOfTimes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleTimeCVC", for: indexPath) as? ScheduleTimeCVC else { return UICollectionViewCell() }
        
        let current = self.yogaVM.arrOfTimes[indexPath.row]
        let datee = (current.startTime ?? "").toDate(region: .UTC)?.convertTo(region: .local)
        cell.lblTitle.text = datee?.toFormat("hh:mm a", locale: Locale(identifier: "en_US_POSIX"))
        
        if self.indexSel == indexPath.row {
            cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#776ADA")
            cell.vwMain.borderWidth = 0
            cell.lblTitle.textColor = hexStringToUIColor(hex: "#E4E1F8")
            
        } else if (current.isAvailable ?? 0) == 0 {
            cell.vwMain.backgroundColor = .clear
            cell.vwMain.borderWidth = 1
            cell.vwMain.borderColor = hexStringToUIColor(hex: "#656372")
            cell.lblTitle.textColor = hexStringToUIColor(hex: "#656372")
            
        } else {
            cell.vwMain.backgroundColor = .clear
            cell.vwMain.borderWidth = 1
            cell.vwMain.borderColor = hexStringToUIColor(hex: "#363C8A")
            cell.lblTitle.textColor = hexStringToUIColor(hex: "#BBB5ED")
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.colleView.frame.size.width / 3, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = self.yogaVM.arrOfTimes[indexPath.row]
        if (current.isAvailable ?? 0) != 0 {
            self.indexSel = indexPath.row
        }
        self.yogaVM.booking_time = self.yogaVM.arrOfTimes[indexPath.row].startTime ?? ""
        self.colleView.reloadData()
    }
}
