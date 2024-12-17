//
//  MyReminderVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 16/05/23.
//

import UIKit
import SwiftDate
import FSCalendar

struct DaysList {
    var title = ""
    var isSelected = false
    var value: Int?
}

class MyReminderVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consCalendarHeight: NSLayoutConstraint!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var viewCalendar: FSCalendar!
    
    // MARK: - VARIABLES
    
    var profileVM = ProfileViewModel()
    var newAdded: voidCloser?
    var isForEdit = false
    var isFromPush = false
    
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblMonth.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.changeStyle()
        self.setupCalendar()
    }
    
    func setupCalendar() {
        self.viewCalendar.delegate = self
        self.viewCalendar.dataSource = self
        self.viewCalendar.today = nil
        self.viewCalendar.scope = .week
        self.viewCalendar.headerHeight = 0
        self.viewCalendar.rowHeight = 40
        self.viewCalendar.weekdayHeight = 20
        self.viewCalendar.setScope(.week, animated: false)
        let now = Date().convertTo(region: .local).date
        self.viewCalendar.setCurrentPage(now, animated: false)
        self.viewCalendar.firstWeekday = 2
        self.viewCalendar.allowsMultipleSelection = false
        self.viewCalendar.backgroundColor = .clear
        self.viewCalendar.scrollEnabled = false
        self.viewCalendar.appearance.weekdayTextColor = hexStringToUIColor(hex: "#FAFAFA")
        self.viewCalendar.appearance.titleFont = Font(.installed(.SemiBold), size: .standard(.S18)).instance
        self.viewCalendar.appearance.weekdayFont = Font(.installed(.Regular), size: .standard(.S14)).instance
        self.viewCalendar.select(now)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewCalendar.setCurrentPage(Date(), animated: true)
            self.viewCalendar.today = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            let nameOfMonth = dateFormatter.string(from: now)
            self.lblMonth.text = nameOfMonth
        }
        
        self.viewCalendar.reloadData()
        
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: ReminderListTVC.self)
        self.tblMain.registerCell(type: LoadingTVC.self)
        self.tblMain.reloadData()
        
        self.dataBind()
    }
    
    func dataBind() {
        let currentDate = self.viewCalendar.selectedDate?.convertTo(region: .local).date.toFormat("yyyy-MM-dd", locale: Locale(identifier: "en_US_POSIX"))
        self.profileVM.getReminderList(date: currentDate ?? "") { _ in
            
            self.tblMain.restore()
            self.tblMain.reloadData()
            if self.profileVM.arrOfReminderList.count == 0 {
                self.tblMain.setEmptyMessage("No Reminder Found")
            }
            
        } failure: { error in
            
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if self.isFromPush {
            appDelegate.setTabbarRoot()
        } else {
            self.goBack(isGoingTab: true)
        }
    }
    
    @IBAction func btnMonthTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        DPPickerManager.shared.showPicker(title: "Reminder Date", picker: { (picker) in
            picker.datePickerMode = .date
        }) { (date, cancel) in
            if !cancel && date != nil {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.viewCalendar.setCurrentPage(date!, animated: true)
                    self.viewCalendar.today = date!
                    self.currentDate = date!
                    self.viewCalendar.select(date!)
                    
                    if let now = date?.convertTo(region: .local).date {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM yyyy"
                        let nameOfMonth = dateFormatter.string(from: now)
                        self.lblMonth.text = nameOfMonth
                    }
                    
                    self.viewCalendar.reloadData()
                    
                    self.profileVM.resetPagination()
                    self.dataBind()
                }
            }
        }
    }
    
    @IBAction func btnPlusTapped(_ sender: UIButton) {
        let vc: SetReminderVC = SetReminderVC.instantiate(appStoryboard: .Profile)
        vc.reloadData = {
            self.profileVM.resetPagination()
            self.dataBind()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - FSCalendarDelegate && FSCalendarDataSource

extension MyReminderVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
   
    func isThisDateBetweenThis(dateUserTapped: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return self.isThisDateBetweenThis(dateUserTapped: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.currentDate = date
        let now = self.viewCalendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let nameOfMonth = dateFormatter.string(from: now)
        self.lblMonth.text = nameOfMonth
        
        self.profileVM.resetPagination()
        self.dataBind()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date == self.currentDate {
            return hexStringToUIColor(hex: "#FAFAFA")
        } else {
            return hexStringToUIColor(hex: "#BBB5ED")
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return hexStringToUIColor(hex: "#363C8A")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date == self.currentDate {
            return hexStringToUIColor(hex: "#363C8A")
        } else {
            return .clear
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.consCalendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}

// MARK: - Tableview Methods

extension MyReminderVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.profileVM.arrOfReminderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LoadingTVC") as? LoadingTVC else { return UITableViewCell() }
            
            cell.loader.stopAnimating()
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "ReminderListTVC") as? ReminderListTVC else { return UITableViewCell() }
            
            let current = self.profileVM.arrOfReminderList[indexPath.row]
            
            let str_Title = current.title ?? ""
            cell.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: str_Title.capitalized)
            
            let dateee = getStrDateFromStrDate(date: current.time ?? "", fromFormate: "HH:mm:ss", toFormDate: "hh:mm a")
            cell.lblTime.configureLable(textColor: hexStringToUIColor(hex: "#BBB5ED"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 10, text: dateee)
            
            cell.editTapped = {
                let vc: SetReminderVC = SetReminderVC.instantiate(appStoryboard: .Profile)
                vc.isForEdit = true
                self.profileVM.current = current
                vc.profileVM = self.profileVM
                vc.reloadData = {
                    self.profileVM.resetPagination()
                    self.dataBind()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.deleteTapped = {
                showAlertWithTitleFromVC(vc: self, title: "Dear Friends", andMessage: "Are you sure you want to delete this reminder '\(current.title ?? "")' ?", buttons: ["NO", "YES"]) { index in
                    if index == 1 {
                        self.profileVM.deleteReminder(id: "\(current.internalIdentifier ?? 0)") { _ in
                            self.profileVM.resetPagination()
                            self.dataBind()
                        } failure: { errorResponse in
                        }
                    }
                }
            }
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let gradientColor = CAGradientLayer.init(frame: cell.vwMain.frame, colors: GradientBGColors, direction: GradientDirection.Bottom).creatGradientImage() {
                    cell.vwMain.backgroundColor = UIColor.init(patternImage: gradientColor)
                    cell.vwMain.layoutIfNeeded()
                }
            }
            
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
