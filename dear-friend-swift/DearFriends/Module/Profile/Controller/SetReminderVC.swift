//
//  SetReminderVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 23/10/23.
//

import UIKit
import FSCalendar
import SwiftDate

class SetReminderVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var txtTime: AppCommonTextField!
    @IBOutlet weak var txtTitle: AppCommonTextField!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewCalendar: FSCalendar!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var lblTimeTitle: UILabel!
    @IBOutlet weak var viewCalenderBG: UIView!
    @IBOutlet weak var btn_Submit: AppButton!
    
    // MARK: - VARIABLES
    
    var minimumDate = Date()
    var maximumDate = Date()
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var profileVM = ProfileViewModel()
    var isForEdit = false
    var selectedTime = Date()
    var reloadData: voidCloser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Set Reminder")
        
        self.lblTaskTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Task Title")
        self.lblTimeTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Meditation Time")
        
        self.lblMonth.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_SemiBold, fontSize: 16, text: "")
        
        self.txtTitle.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "", placeholder: "Enter task title")
        
        self.txtTime.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 16, text: "", placeholder: "Select Time")
        
        self.txtTitle.viewCorneRadius(radius: 8)
        self.txtTitle.backgroundColor = .primary
        self.txtTitle.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewCalenderBG.viewCorneRadius(radius: 12)
        self.viewCalenderBG.backgroundColor = .primary
        self.viewCalenderBG.viewBorderCorneRadius(borderColour: .secondary)
        
        
        self.txtTime.viewCorneRadius(radius: 8)
        self.txtTime.backgroundColor = .primary
        self.txtTime.viewBorderCorneRadius(borderColour: .secondary)
        
        self.btn_Submit.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Apply")
        self.btn_Submit.backgroundColor = UIColor.init(named: "Button_BG_Color")
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.viewCalendar.delegate = self
        self.viewCalendar.dataSource = self
        self.viewCalendar.today = Date()
        self.viewCalendar.scope = .month
        self.viewCalendar.setCurrentPage(Date(), animated: false)
        self.viewCalendar.firstWeekday = 2
        self.viewCalendar.scrollEnabled = false
        self.viewCalendar.allowsMultipleSelection = false
        self.viewCalendar.backgroundColor = .clear
        self.viewCalendar.appearance.weekdayTextColor = hexStringToUIColor(hex: "#D2CDF3")
        self.viewCalendar.appearance.titleFont = Font(.installed(.Regular), size: .standard(.S14)).instance
        self.viewCalendar.appearance.weekdayFont = Font(.installed(.Regular), size: .standard(.S16)).instance
        
        var selectedDate = Date()
        
        if self.isForEdit {
            selectedDate = self.profileVM.current?.date?.toDate("yyyy-MM-dd", region: .local)?.date ?? Date()
            self.txtTitle.text = self.profileVM.current?.title ?? ""
            
            let finalDate = getStrDateFromStrDate(date: self.profileVM.current?.time ?? "", fromFormate: "HH:mm:ss", toFormDate: "hh:mm a")
            self.txtTime.text = finalDate
            self.selectedTime = finalDate.toDate("hh:mm a", region: .local)?.date ?? Date()
            self.profileVM.reminderTime = self.profileVM.current?.time ?? ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.viewCalendar.setCurrentPage(selectedDate, animated: true)
            self.viewCalendar.today = selectedDate
            self.viewCalendar.select(selectedDate)
            
            let now = self.viewCalendar.currentPage
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            let nameOfMonth = dateFormatter.string(from: now)
            self.lblMonth.text = nameOfMonth
        }
        
        if Calendar.current.component(.month, from: self.viewCalendar.currentPage) == Calendar.current.component(.month, from: Date()) {
            self.btnPrevious.alpha = 0.5
            self.btnPrevious.isUserInteractionEnabled = false
            
        } else {
            self.btnPrevious.alpha = 1
            self.btnPrevious.isUserInteractionEnabled = true
        }
        
        self.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())?.date ?? Date()
        
        self.viewCalendar.reloadData()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnSubmiTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.profileVM.reminderTitle = self.txtTitle.text ?? ""
        self.profileVM.reminderDate = self.viewCalendar.selectedDate?.toFormat("yyyy-MM-dd") ?? ""
        
        if self.profileVM.reminderTitle == "" {
            GeneralUtility().showErrorMessage(message: "Please enter title")
            return
        }
        if self.viewCalendar.selectedDate == nil {
            GeneralUtility().showErrorMessage(message: "Please select date")
            return
        }
        if self.profileVM.reminderTime == "" {
            GeneralUtility().showErrorMessage(message: "Please select time")
            return
        }
        
        if self.isForEdit {
            self.profileVM.updateReminder { _ in
                self.reloadData?()
                self.navigationController?.popViewController(animated: true)
            } failure: { errorResponse in
                
            }
        } else {
            self.profileVM.addReminder { _ in
                self.reloadData?()
                self.navigationController?.popViewController(animated: true)
            } failure: { errorResponse in
                
            }
        }
    }
    
    @IBAction func btnSelectTime(_ sender: UIButton) {
        self.view.endEditing(true)
        DPPickerManager.shared.showPicker(title: "Meditation Time", picker: { (picker) in
            picker.datePickerMode = .time
            picker.date = self.selectedTime
        }) { (date, cancel) in
            if !cancel && date != nil {
                self.txtTime.text = date?.convertTo(region: .local).date.toFormat("hh:mm a", locale: Locale(identifier: "en_US_POSIX"))
                self.selectedTime = date!
                self.profileVM.reminderTime = GeneralUtility().convertToDateFromString(olddate: date!, format: "HH:mm:ss", withUTC: true)
            }
        }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        let previousDate = self.gregorian.date(byAdding: .month, value: 1, to: self.viewCalendar.currentPage)!
        self.viewCalendar.setCurrentPage(previousDate, animated: true)
        let now = self.viewCalendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
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
    }
    
    @IBAction func btnPreviousTapped(_ sender: UIButton) {
        let previousDate = self.gregorian.date(byAdding: .month, value: -1, to: self.viewCalendar.currentPage)!
        self.viewCalendar.setCurrentPage(previousDate, animated: true)
        let now = self.viewCalendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
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
    }
}

//MARK: - FSCalendarDelegate && FSCalendarDataSource

extension SetReminderVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return maximumDate
    }
    
    func isThisDateBetweenThis(dateUserTapped: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return self.isThisDateBetweenThis(dateUserTapped: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
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
}
