//
//  NotificationsVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 06/09/23.
//

import UIKit
import SwiftDate

class NotificationsVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - VARIABLES
    
    var homeVM = HomeViewModel()
    var customID = ""
    var isFromPush = false
    var isNavigateDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20, text: "Notifications")
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        
        self.homeVM.offset = 0
        self.homeVM.limit = 10
        self.homeVM.haseMoreData = false
        self.homeVM.isAPICalling = false
        self.homeVM.arrOfNotifications.removeAll()
        
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: NotificationListTVC.self)
        self.tblMain.registerCell(type: LoadingTVC.self)
        self.tblMain.reloadData()
        self.getNotifications()
    }
    
    func getNotifications() {
        self.homeVM.getNotifications(isShowLoader: self.homeVM.arrOfNotifications.count == 0) { _ in
            self.tblMain.restore()
            self.tblMain.reloadData()
            
            if self.homeVM.arrOfNotifications.count == 0 {
                self.btnDelete.isHidden = true
                self.tblMain.setEmptyMessage("No Notifications found")
            } else {
                self.btnDelete.isHidden = false
            }
            
            if self.isNavigateDone {
                if let index = self.homeVM.arrOfNotifications.firstIndex(where: {$0.objectId == Int(self.customID)}) {
                    self.navigateTochat(current: self.homeVM.arrOfNotifications[index])
                }
            }
            
        } failure: { errorResponse in
            
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
    
    @IBAction func btnDeleteAllTapped(_ sender: UIButton) {
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "Are you sure want to clear all notifications?", buttons: ["NO", "YES"]) { index in
            if index == 1 {
                self.homeVM.deleteAllNotifcation { _ in
                    
                    self.homeVM.arrOfNotifications.removeAll()
                    self.tblMain.reloadData()
                    
                    if self.homeVM.arrOfNotifications.count == 0 {
                        self.btnDelete.isHidden = true
                        self.tblMain.setEmptyMessage("No Notifications found")
                    } else {
                        self.btnDelete.isHidden = false
                    }
                    
                } failure: { error in
                    
                }
            }
        }
    }
}

// MARK: - Tableview Methods

extension NotificationsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return self.homeVM.arrOfNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LoadingTVC") as? LoadingTVC else { return UITableViewCell() }
            
            if self.homeVM.haseMoreData {
                cell.loader.startAnimating()
                
            } else {
                cell.loader.stopAnimating()
            }
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
            
        } else {
            guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "NotificationListTVC") as? NotificationListTVC else { return UITableViewCell() }
            
            let current = self.homeVM.arrOfNotifications[indexPath.row]

            if (current.pushType ?? 0) == 6 {
                cell.lblMsg.numberOfLines = 3
            } else {
                cell.lblMsg.numberOfLines = 0
            }
            
            cell.lblTitle.text = current.pushTitle ?? ""
            cell.lblMsg.text = current.pushMessage ?? ""
            
            if let finalDate = current.createdAt?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z", region: .UTC)?.date {
                let finalStr = finalDate.toRelative(since: DateInRegion(Date(), region: .UTC), dateTimeStyle: .named, unitsStyle: .short)
                cell.lblTime.text = finalStr
            }
            
            if current.read == 0 {
                cell.vwMain.backgroundColor = .secondary
            } else {
                cell.vwMain.backgroundColor = .primary
            }
            
            
            //SET IMAGE
            cell.btnClicked.isHidden = true
            cell.con_img.constant = 30
            cell.imgView.image = UIImage(named: "icon_notification_white")
            if (current.file ?? "") != "" {
//                cell.btnClicked.isHidden = false
                cell.con_img.constant = 50
                
                GeneralUtility().setImage(imgView: cell.imgView, imgPath: current.file ?? "")
                
                // BUTTON ACTION
//                cell.btnClicked.tag = indexPath.row
//                cell.btnClicked.addTarget(self, action: #selector(self.btnImgClicked(_:)), for: .touchUpInside)

            }
            
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        }
    }
        
//    @objc func btnImgClicked(_ sender : UIButton) {
//        let notificationVC = NotificationPopupVC.instantiate(appStoryboard: .main)
//        let fullImageVC = FullImageVC.instantiate(appStoryboard: .main)
//        let current = self.homeVM.arrOfNotifications[sender.tag]
//
//        var vc: UIViewController = notificationVC
//
//        if (current.file ?? "") != "" {
//            vc = fullImageVC
//            
//            if let fullImageVC = vc as? FullImageVC {
//                fullImageVC.file = current.file ?? ""
//                fullImageVC.homeVM = self.homeVM
//                fullImageVC.isFromPush = self.isFromPush
//                fullImageVC.customID = "\(current.internalIdentifier ?? 0)"
//                
//                fullImageVC.reloadIndex = { index in
//                    self.isNavigateDone = false
//                    self.homeVM.arrOfNotifications[index].read = 1
//                    self.tblMain.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//                    
//                    if appDelegate.unread_count > 0 {
//                        appDelegate.unread_count -= 1
//                        UIApplication.shared.applicationIconBadgeNumber = appDelegate.unread_count
//                    }
//                }
//            }
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .overFullScreen
//
//            DispatchQueue.main.async {
//                self.present(vc, animated: true, completion: nil)
//            }
//
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let current = self.homeVM.arrOfNotifications[indexPath.row]
            
            if current.read == 0 {
             
                self.homeVM.readNotifcation(id: "\(current.internalIdentifier ?? 0)") { success in
                 
                    self.homeVM.arrOfNotifications[indexPath.row].read = 1
                    self.tblMain.reloadRows(at: [indexPath], with: .automatic)
                    
                    if appDelegate.unread_count > 0 {
                        appDelegate.unread_count -= 1
                        UIApplication.shared.applicationIconBadgeNumber = appDelegate.unread_count
                    }
                    self.navigateTochat(current: current)
                    
                } failure: { errorResponse in
                    
                }
                
            } else {
                self.navigateTochat(current: current)
            }
        }
    }
    
    func navigateTochat(current: NotificationListModel) {
        if (current.pushType ?? 0) == 1 {
            let vc: ChatMessageVC = ChatMessageVC.instantiate(appStoryboard: .CreateMusic)
            vc.customID = "\(current.objectId ?? 0)"
            vc.isFromNoti = true
            vc.isFromPush = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (current.pushType ?? 0) == 2 {
            let vc: MyReminderVC = MyReminderVC.instantiate(appStoryboard: .Profile)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (current.pushType ?? 0) == 5 {
            let vc: BookingDetailsVC = BookingDetailsVC.instantiate(appStoryboard: .MyBookings)
            vc.hidesBottomBarWhenPushed = true
            vc.id = "\(current.objectId ?? 0)"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (current.pushType ?? 0) == 6 {
            self.isNavigateDone = false

            let notificationVC = NotificationPopupVC.instantiate(appStoryboard: .main)
            let fullImageVC = FullImageVC.instantiate(appStoryboard: .main)

            var vc: UIViewController = notificationVC

            if (current.file ?? "") != "" {
                vc = fullImageVC
                
                if let fullImageVC = vc as? FullImageVC {
                    fullImageVC.file = current.file ?? ""
                    fullImageVC.homeVM = self.homeVM
                    fullImageVC.isFromPush = self.isFromPush
                    fullImageVC.customID = "\(current.internalIdentifier ?? 0)"
                    
                    fullImageVC.reloadIndex = { index in
                        self.isNavigateDone = false
                        self.homeVM.arrOfNotifications[index].read = 1
                        self.tblMain.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        
                        if appDelegate.unread_count > 0 {
                            appDelegate.unread_count -= 1
                            UIApplication.shared.applicationIconBadgeNumber = appDelegate.unread_count
                        }
                    }
                }
            }
            else {
                if let popupVC = vc as? NotificationPopupVC {
                    popupVC.titleText = current.pushTitle ?? ""
                    popupVC.descText = current.pushMessage ?? ""
//                    popupVC.file = current.file ?? ""
                    popupVC.homeVM = self.homeVM
                    popupVC.isFromPush = self.isFromPush
                    popupVC.customID = "\(current.internalIdentifier ?? 0)"
                    
                    popupVC.reloadIndex = { index in
                        self.isNavigateDone = false
                        self.homeVM.arrOfNotifications[index].read = 1
                        self.tblMain.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        
                        if appDelegate.unread_count > 0 {
                            appDelegate.unread_count -= 1
                            UIApplication.shared.applicationIconBadgeNumber = appDelegate.unread_count
                        }
                    }
                }
            }
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen

            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (editingStyle == .delete) {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
                    
            let current = self.homeVM.arrOfNotifications[indexPath.row]
            
            self.homeVM.deleteOneNotifcation(id: "\(current.internalIdentifier ?? 0)") { _ in
                self.isNavigateDone = false
                self.homeVM.arrOfNotifications.remove(at: indexPath.row)
                self.tblMain.reloadData()
                
                if self.homeVM.arrOfNotifications.count == 0 {
                    self.btnDelete.isHidden = true
                    self.tblMain.setEmptyMessage("No Notifications found")
                } else {
                    self.btnDelete.isHidden = false
                }
                
            } failure: { errorResponse in
                
            }
            completion(true)
        }
        deleteAction.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        deleteAction.image = UIImage(named: "ic_swipe_delete")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tblMain.contentOffset.y >= ((self.tblMain.contentSize.height - self.tblMain.bounds.size.height) - 200) {
            if !self.homeVM.isAPICalling {
                self.homeVM.isAPICalling = true
                if self.homeVM.haseMoreData {
                    self.homeVM.offset += self.homeVM.limit
                    self.getNotifications()
                }
            }
        }
    }
}
