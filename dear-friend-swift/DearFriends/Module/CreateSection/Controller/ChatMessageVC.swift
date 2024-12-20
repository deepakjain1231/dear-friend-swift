//
//  ChatMessageVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 23/10/23.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftDate
import QuickLookThumbnailing

class ChatMessageVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var consBottom: NSLayoutConstraint!
    
    // MARK: - VARIABLES
    
    var chatVM = CreateCustomAudioViewModel()
    var isForCompleted = false
    var isPaymentDone = false
    var isFromPush = false
    var customID = ""
    var isFromNoti = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblTitle.text = self.chatVM.currenRequest?.meditationName ?? ""
        self.txtMsg.inputAccessoryView = UIView()
        self.txtMsg.autocapitalizationType = .sentences
        self.txtMsg.autocorrectionType = .no
        self.txtMsg.spellCheckingType = .no
        self.txtMsg.delegate = self
        
        self.tblMain.setDefaultProperties(vc: self)
        self.tblMain.registerCell(type: RightSideMsgTVC.self)
        self.tblMain.registerCell(type: LeftSideMsgTVC.self)
        self.tblMain.registerCell(type: RightSideScriptTVC.self)
        self.tblMain.registerCell(type: LeftSideScriptTVC.self)
        self.tblMain.registerCell(type: TimeHeaderTVC.self)
        self.tblMain.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.tblMain.rowHeight = UITableView.automaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if self.isForCompleted || ((self.chatVM.currenRequest?.is_chat_open ?? 0) == 0) {
            self.vwBottom.isHidden = true
        }
        
        if self.isFromPush {
            self.chatVM.currentCustomID = self.customID
            self.chatVM.type = "open"
            self.chatVM.getCustomAudioRequests { _ in
                self.chatVM.currenRequest = self.chatVM.arrOfCustomRequests.first(where: {$0.internalIdentifier == Int(self.customID)})
                self.lblTitle.text = self.chatVM.currenRequest?.meditationName ?? ""
                
                self.getChatHistory()
                
            } failure: { errorResponse in
                
            }
        } else {
            self.getChatHistory()
        }
    }
    
    func getChatHistory(isShowloader: Bool = true) {
        self.chatVM.getChatHistory(isShowLoader: isShowloader) { response in
            appDelegate.finalAmountMain = response["custom_audio_request_price"].stringValue
            self.tblMain.reloadData()
            
            if self.isForCompleted || ((self.chatVM.currenRequest?.is_chat_open ?? 0) == 0) {
                self.vwBottom.isHidden = true
            }
            
        } failure: { errorResponse in
            
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if self.isFromPush && !self.isFromNoti {
            appDelegate.setTabbarRoot()
            
        } else {
            self.goBack(isGoingTab: true)
        }
    }
    
    @IBAction func btnInfoTapped(_ sender: UIButton) {
        let vc: RequestDetailsVC = RequestDetailsVC.instantiate(appStoryboard: .CreateMusic)
        vc.hidesBottomBarWhenPushed = true
        vc.chatVM = self.chatVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSendChatTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let newMsg = ChatMessageListingModel.init(json: "")
        newMsg.type = "message"
        newMsg.message = self.txtMsg.text ?? ""
        newMsg.isSending = true
        newMsg.senderId = CurrentUser.shared.user?.internalIdentifier ?? 0
        
        let messageDate = Date().convertTo(region: .local).toFormat("yyyy-MM-dd", locale: Locale(identifier: "en_US_POSIX"))
        
        if let index = self.chatVM.arrOfMessages.firstIndex(where: {$0.currentDate == messageDate}) {
            self.chatVM.arrOfMessages[index].arrOfMessages.insert(newMsg, at: 0)
        } else {
            let temp = CustomMessageListing(currentDate: messageDate, arrOfMessages: [newMsg])
            self.chatVM.arrOfMessages.insert(temp, at: 0)
        }
        
        self.txtMsg.text = ""
        self.tblMain.reloadData()
        
        self.chatVM.sendChat(value: newMsg.message ?? "") { response in
            let newMsg = ChatMessageListingModel(json: response["data"])
            
            if let index = self.chatVM.arrOfMessages.firstIndex(where: {$0.currentDate == messageDate}) {
                self.chatVM.arrOfMessages[index].arrOfMessages[0].createdAt = DateInRegion(Date(), region: .UTC).toFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", locale: Locale(identifier: "en_US_POSIX"))
                self.chatVM.arrOfMessages[index].arrOfMessages[0].isSending = false
                
            } else {
                
            }
            self.tblMain.reloadData()
            
        } failure: { errorResponse in
            
        }
    }
    
    @IBAction func btnAttachmentTapped(_ sender: UIButton) {
        self.openDocumentPicker()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.consBottom.constant = keyboardSize.height + 12
                self.view.layoutIfNeeded()
            }
            
            if self.tblMain.numberOfSections > 0 && self.tblMain.numberOfRows(inSection: self.tblMain.numberOfSections - 1) > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tblMain.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardDidChangeFrame(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.consBottom.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.consBottom.constant = 12
                self.view.layoutIfNeeded()
            }
        }
    }
}

//MARK: UITextViewDelegate

extension ChatMessageVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.txtMsg.frame.size.height >= 150 {
                self.txtMsg.isScrollEnabled = true
            } else {
                self.txtMsg.isScrollEnabled = false
            }
            
            self.view.layoutIfNeeded()
            
            if textView.text == "" {
                self.btnSend.alpha = 0.5
                self.btnSend.isUserInteractionEnabled = false
            } else {
                self.btnSend.alpha = 1
                self.btnSend.isUserInteractionEnabled = true
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}

// MARK: - Tableview delegate & datasource method

extension ChatMessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.chatVM.arrOfMessages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatVM.arrOfMessages[section].arrOfMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let current = self.chatVM.arrOfMessages[indexPath.section].arrOfMessages[indexPath.row]
        
        if (current.senderId ?? 0) != (CurrentUser.shared.user?.internalIdentifier ?? 0) {
            
            if current.type == "message" {
                guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "RightSideMsgTVC") as? RightSideMsgTVC else { return UITableViewCell() }
                
                cell.lblMsg.text = current.message ?? ""
                cell.lblTime.text = current.createdAt?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", region: .UTC)?.convertTo(region: .local).toFormat("hh:mm a", locale: Locale(identifier: "en_US_POSIX"))
                
                cell.selectionStyle = .none
                cell.layoutIfNeeded()
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
                
            } else {
                guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "RightSideScriptTVC") as? RightSideScriptTVC else { return UITableViewCell() }
                
                cell.lblTime.text = current.createdAt?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", region: .UTC)?.convertTo(region: .local).toFormat("hh:mm a", locale: Locale(identifier: "en_US_POSIX"))
                cell.lblTitle.text = current.message ?? ""
                
                if let url = URL(string: current.file ?? "") {
                    if url.pathExtension == "mp3" || url.pathExtension == "wav" {
                        cell.btnScrtip.setTitle("Play My Custom Meditation", for: .normal)
                        cell.btnScrtip.setImage(UIImage(named: "ic_play7"), for: .normal)
                        
                    } else {
                        cell.btnScrtip.setTitle("Go to Script", for: .normal)
                        cell.btnScrtip.setImage(UIImage(named: "ic_backscrip"), for: .normal)
                    }
                }
                
                cell.selectionStyle = .none
                cell.layoutIfNeeded()
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
            }
            
        } else {
            if current.type == "message" {
                guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LeftSideMsgTVC") as? LeftSideMsgTVC else { return UITableViewCell() }
                
                cell.lblMsg.text = current.message ?? ""
                GeneralUtility().setImage(imgView: cell.imgUser, imgPath: CurrentUser.shared.user?.profileImage ?? "")
                
                if current.isSending {
                    cell.lblTime.isHidden = true
                    cell.acti.startAnimating()
                } else {
                    cell.acti.stopAnimating()
                    cell.lblTime.isHidden = false
                    cell.lblTime.text = current.createdAt?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", region: .UTC)?.convertTo(region: .local).toFormat("hh:mm a", locale: Locale(identifier: "en_US_POSIX"))
                }
                
                cell.selectionStyle = .none
                cell.layoutIfNeeded()
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
                
            } else {
                guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "LeftSideScriptTVC") as? LeftSideScriptTVC else { return UITableViewCell() }
                
                GeneralUtility().setImage(imgView: cell.imgUser, imgPath: CurrentUser.shared.user?.profileImage ?? "")
                cell.lblTime.text = current.createdAt?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", region: .UTC)?.convertTo(region: .local).toFormat("hh:mm a", locale: Locale(identifier: "en_US_POSIX"))
                cell.lblTitle.text = current.message ?? ""
                
                if let url = URL(string: current.file ?? "") {
                    if url.pathExtension == "mp3" || url.pathExtension == "wav" {
                        cell.btnScrtip.setTitle("Play My Custom Meditation", for: .normal)
                        cell.btnScrtip.setImage(UIImage(named: "ic_play7"), for: .normal)
                        
                    } else {
                        cell.btnScrtip.setTitle("Go to Script", for: .normal)
                        cell.btnScrtip.setImage(UIImage(named: "ic_backscrip"), for: .normal)
                    }
                }
                
                cell.selectionStyle = .none
                cell.layoutIfNeeded()
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = self.tblMain.dequeueReusableCell(withIdentifier: "TimeHeaderTVC") as? TimeHeaderTVC else { return UITableViewCell() }
        
        let current = self.chatVM.arrOfMessages[section]
        if let finalDate = current.currentDate.toDate("yyyy-MM-dd", region: .local)?.date {
            let myDate = finalDate.toFormat("MMM dd, yyyy", locale: Locale(identifier: "en_US_POSIX"))
            if finalDate.isToday {
                cell.lblTitle.text = "Today"
                
            } else if finalDate.isYesterday {
                cell.lblTitle.text = "Yesterday"
                
            } else {
                cell.lblTitle.text = "\(myDate)"
            }
        }
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = self.chatVM.arrOfMessages[indexPath.section].arrOfMessages[indexPath.row]
        
        if (current.type ?? "") == "file" {
            if let url = URL(string: current.file ?? "") {
                if (url.pathExtension == "mp3" || url.pathExtension == "wav") {
                    if (current.audio_duration ?? "") != "" {
                        let vc: NewMusicVC = NewMusicVC.instantiate(appStoryboard: .Explore)
                        let audioVM = AudioViewModel()
                        
                        let newcurrent = CommonAudioList.init(json: "")
                        newcurrent.file = current.file ?? ""
                        newcurrent.narratedBy = "Dear Friends"
                        newcurrent.title = self.chatVM.currenRequest?.meditationName ?? ""
                        newcurrent.internalIdentifier = self.chatVM.currenRequest?.internalIdentifier ?? 0
                        newcurrent.musicURL = URL(string: current.file ?? "")
                        newcurrent.audioDuration = self.chatVM.currenRequest?.audio_duration
                        
                        let category = Category.init(json: "")
                        category.title = self.chatVM.currenRequest?.format ?? ""
                        newcurrent.category = category
                        
                        vc.currentSong = newcurrent
                        audioVM.arrOfAudioList = [newcurrent]
                        
                        vc.audioVM = audioVM
                        vc.isFromCustom = true
                        vc.currentSongIndex = 0
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        GeneralUtility().showErrorMessage(message: "Something wrong with audio. Unable to play!")
                    }
                    
                } else {
                    let vc: ScriptViewVC = ScriptViewVC.instantiate(appStoryboard: .CreateMusic)
                    self.chatVM.currentMessage = current
                    vc.chatVM = self.chatVM
                    vc.isFromMine = (current.senderId ?? 0) == (CurrentUser.shared.user?.internalIdentifier ?? 0)
                    vc.isForCompleted = self.isForCompleted
                    vc.isPaymentDone = self.isPaymentDone
                    vc.editCountUpdate = { newCount in
                        self.chatVM.currenRequest?.edit_custom_audio_request_count = newCount
                        self.getChatHistory()
                    }
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
    }
}

//MARK: - Document Picker

extension ChatMessageVC: UIDocumentPickerDelegate {
    
    private func openDocumentPicker() {
        let documentStyles = ["com.adobe.pdf"]
        var documentPicker = UIDocumentPickerViewController(documentTypes: documentStyles, in: .import)
        
        if #available(iOS 14.0, *) {
            let supportedTypes = [UTType.pdf]
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        }
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    //MARK: -
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Picked document URLS : \(urls)")
        
        if let url = urls.first {
            if let data = try? Data(contentsOf: url) {
                let fileName = url.getDocumentName()
                self.chatVM.selectedDoc = ServiceManager.MultiPartDataType(mimetype: "application/pdf", fileName: fileName, fileData: data, keyName: "file")
                self.chatVM.sendAttachment(value: "") { _ in
                    self.getChatHistory()
                } failure: { errorResponse in
                    
                }
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
