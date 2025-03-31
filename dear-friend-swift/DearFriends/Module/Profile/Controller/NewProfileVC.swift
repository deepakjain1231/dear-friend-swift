//
//  NewProfileVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 08/09/23.
//

import UIKit
import MessageUI
import SwiftyJSON
import AVFoundation

class NewProfileVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnDownloads: UIButton!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var lblFavorite: UILabel!
    @IBOutlet weak var lblHistory: UILabel!
    @IBOutlet weak var lblDownload: UILabel!
    @IBOutlet weak var lblGeneralTitle: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnLinkAccount: UIButton!
    @IBOutlet weak var btnMyBooking: UIButton!
    @IBOutlet weak var btnPreference: UIButton!
    @IBOutlet weak var btnReminder: UIButton!
    @IBOutlet weak var btnMySubscription: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var btnCreator: UIButton!
    @IBOutlet weak var lblCreator: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var lblNavTitle: UILabel!
    
    @IBOutlet weak var viewFavorite: UIView!
    @IBOutlet weak var viewHistory: UIView!
    @IBOutlet weak var viewDownload: UIView!
    
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var viewLinkAccount: UIView!
    @IBOutlet weak var viewMyBooking: UIView!
    @IBOutlet weak var viewPreference: UIView!
    @IBOutlet weak var viewReminder: UIView!
    @IBOutlet weak var viewMySubscription: UIView!
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var viewContactUs: UIView!
    @IBOutlet weak var viewCreator: UIView!
    @IBOutlet weak var viewLogout: UIView!
    
    @IBOutlet weak var imgEditProfile_arrow: UIImageView!
    @IBOutlet weak var imgLinkAccount_arrow: UIImageView!
    @IBOutlet weak var imgMyBooking_arrow: UIImageView!
    @IBOutlet weak var imgPreference_arrow: UIImageView!
    @IBOutlet weak var imgReminder_arrow: UIImageView!
    @IBOutlet weak var imgMySubscription_arrow: UIImageView!
    @IBOutlet weak var imgSetting_arrow: UIImageView!
    @IBOutlet weak var imgContactUs_arrow: UIImageView!
    @IBOutlet weak var imgCreator_arrow: UIImageView!
    @IBOutlet weak var imgLogout_arrow: UIImageView!
    
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var imgHistory: UIImageView!
    @IBOutlet weak var imgDownload: UIImageView!
    @IBOutlet weak var imgContactUs: UIImageView!
    @IBOutlet weak var imgCreator: UIImageView!
    @IBOutlet weak var imgLogout: UIImageView!
    
    
    
    // MARK: - VARIABLES
    
    static var newInstance: NewProfileVC {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "NewProfileVC"
        ) as! NewProfileVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTheView()
        self.setupImage()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            NotificationCenter.default.post(name: Notification.Name("BottomView"), object: nil, userInfo: ["hide": "0"])
        }
        
        self.getAboutCreatot()
    }
    
    func getAboutCreatot(){
        self.get_AboutCreator_Onboarding { _ in
            
        } failure: { errorResponse in
            
        }
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
        self.lblName.text = CurrentUser.shared.user?.name ?? ""
        self.lblEmail.text = CurrentUser.shared.user?.email ?? ""
        GeneralUtility().setImage(imgView: self.imgUser, imgPath: CurrentUser.shared.user?.profileImage ?? "")
        self.btnFavorites.alignVerticalCenter()
        self.btnHistory.alignVerticalCenter()
        self.btnDownloads.alignVerticalCenter()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Profile")
        self.lblName.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 18, text: CurrentUser.shared.user?.name ?? "")
        self.lblEmail.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: CurrentUser.shared.user?.email ?? "")
        
        
        self.lblFavorite.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 15, text: "Favorites")
        self.lblHistory.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 15, text: "My History")
        self.lblDownload.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 15, text: "Downloads")
        
        self.lblGeneralTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 18, text: "General")
        
        self.btnEditProfile.configureLable(bgColour: .clear, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Edit Profile")
        self.btnLinkAccount.configureLable(bgColour: .clear, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Link/Unlink Account")
        self.btnMyBooking.configureLable(bgColour: .clear, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "My Bookings")
        self.btnPreference.configureLable(bgColour: .clear, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Preferences")
        self.btnReminder.configureLable(bgColour: .clear, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Reminders")
        self.btnMySubscription.configureLable(bgColour: .clear, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "My Subscription")
        self.btnSetting.configureLable(bgColour: .clear, textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Settings")
        self.lblContactUs.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Contact Us")
        self.lblCreator.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "About the Creator")
        self.lblLogout.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Logout")
        
        //SET VIEW
        self.viewFavorite.viewCorneRadius(radius: 10)
        self.viewFavorite.backgroundColor = .primary
        self.viewFavorite.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewHistory.viewCorneRadius(radius: 10)
        self.viewHistory.backgroundColor = .primary
        self.viewHistory.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewDownload.viewCorneRadius(radius: 10)
        self.viewDownload.backgroundColor = .primary
        self.viewDownload.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewEditProfile.viewCorneRadius(radius: 15)
        self.viewEditProfile.backgroundColor = .primary
        self.viewEditProfile.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewLinkAccount.viewCorneRadius(radius: 15)
        self.viewLinkAccount.backgroundColor = .primary
        self.viewLinkAccount.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewMyBooking.viewCorneRadius(radius: 15)
        self.viewMyBooking.backgroundColor = .primary
        self.viewMyBooking.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewPreference.viewCorneRadius(radius: 15)
        self.viewPreference.backgroundColor = .primary
        self.viewPreference.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewReminder.viewCorneRadius(radius: 15)
        self.viewReminder.backgroundColor = .primary
        self.viewReminder.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewMySubscription.viewCorneRadius(radius: 15)
        self.viewMySubscription.backgroundColor = .primary
        self.viewMySubscription.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewSetting.viewCorneRadius(radius: 15)
        self.viewSetting.backgroundColor = .primary
        self.viewSetting.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewContactUs.viewCorneRadius(radius: 15)
        self.viewContactUs.backgroundColor = .primary
        self.viewContactUs.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewCreator.viewCorneRadius(radius: 15)
        self.viewCreator.backgroundColor = .primary
        self.viewCreator.viewBorderCorneRadius(borderColour: .secondary)

        
        self.viewLogout.viewCorneRadius(radius: 15)
        self.viewLogout.backgroundColor = .primary
        self.viewLogout.viewBorderCorneRadius(borderColour: .secondary)
        
        self.imgEditProfile_arrow.viewCorneRadius(radius: 9)
        self.imgLinkAccount_arrow.viewCorneRadius(radius: 9)
        self.imgMyBooking_arrow.viewCorneRadius(radius: 9)
        self.imgPreference_arrow.viewCorneRadius(radius: 9)
        self.imgReminder_arrow.viewCorneRadius(radius: 9)
        self.imgMySubscription_arrow.viewCorneRadius(radius: 9)
        self.imgSetting_arrow.viewCorneRadius(radius: 9)
        self.imgContactUs_arrow.viewCorneRadius(radius: 9)
        self.imgCreator_arrow.viewCorneRadius(radius: 9)
        self.imgLogout_arrow.viewCorneRadius(radius: 9)
    }
    
    func setupImage() {
        self.btnEditProfile.setImage(UIImage.init(named: "ic_edit_profile")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.btnEditProfile.tintColor = .secondary
        
        self.btnLinkAccount.setImage(UIImage.init(named: "icon_linkAccount")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.btnLinkAccount.tintColor = .secondary
        
        self.btnMyBooking.setImage(UIImage.init(named: "ic_my_booking")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.btnMyBooking.tintColor = .secondary
        
        self.btnPreference.setImage(UIImage.init(named: "ic_preferences")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.btnPreference.tintColor = .secondary
        
        self.btnReminder.setImage(UIImage.init(named: "ic_reminder")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.btnReminder.tintColor = .secondary
        
        self.btnMySubscription.setImage(UIImage.init(named: "ic_subs")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.btnMySubscription.tintColor = .secondary
        
        self.btnSetting.setImage(UIImage.init(named: "ic_settings")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.btnSetting.tintColor = .secondary
        
        self.imgContactUs.image = UIImage.init(named: "ic_contact_us")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.imgContactUs.tintColor = .secondary
        
        self.imgCreator.image = UIImage.init(named: "ic_info")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.imgCreator.tintColor = .secondary

        self.imgLogout.image = UIImage.init(named: "ic_logout")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.imgLogout.tintColor = .secondary
        
        var temp_Image = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
        self.imgFavorite.image = temp_Image
        self.imgFavorite.tintColor = .secondary
        
        temp_Image = UIImage(named: "ic_history")?.withRenderingMode(.alwaysTemplate)
        self.imgHistory.image = temp_Image
        self.imgHistory.tintColor = .secondary
        
        temp_Image = UIImage(named: "ic_download")?.withRenderingMode(.alwaysTemplate)
        self.imgDownload.image = temp_Image
        self.imgDownload.tintColor = .secondary
        
        temp_Image = UIImage(named: "ic_contact_us")?.withRenderingMode(.alwaysTemplate)
        self.imgContactUs.image = temp_Image
        self.imgContactUs.tintColor = .secondary
        
        temp_Image = UIImage(named: "ic_info")?.withRenderingMode(.alwaysTemplate)
        self.imgCreator.image = temp_Image
        self.imgCreator.tintColor = .secondary

        
        temp_Image = UIImage(named: "ic_logout")?.withRenderingMode(.alwaysTemplate)
        self.imgLogout.image = temp_Image
        self.imgLogout.tintColor = .secondary
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnMenuTaped(_ sender: UIButton) {
        if sender.tag == 1 {
            let vc: MyHistoryVC = MyHistoryVC.instantiate(appStoryboard: .Profile)
            vc.currentScreen = .customAudio
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 2 {
            let vc: MyHistoryVC = MyHistoryVC.instantiate(appStoryboard: .Profile)
            vc.currentScreen = .favourites
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnFavorites, view_bg: self.viewFavorite, img_arrow: nil, current_vc: vc)
            
        } else if sender.tag == 3 {
            let vc: MyHistoryVC = MyHistoryVC.instantiate(appStoryboard: .Profile)
            vc.currentScreen = .history
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnHistory, view_bg: self.viewHistory, img_arrow: nil, current_vc: vc)
            
        } else if sender.tag == 4 {
            let vc: MyHistoryVC = MyHistoryVC.instantiate(appStoryboard: .Profile)
            vc.currentScreen = .download
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnDownloads, view_bg: self.viewDownload, img_arrow: nil, current_vc: vc)
            
        } else if sender.tag == 5 {
            let vc: EditProfileVC = EditProfileVC.instantiate(appStoryboard: .Profile)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 6 {
            let vc: MyBookingVC = MyBookingVC.instantiate(appStoryboard: .MyBookings)
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnMyBooking, view_bg: self.viewMyBooking, img_arrow: self.imgMyBooking_arrow, current_vc: vc)
            
        } else if sender.tag == 7 {
            let vc: MyPreferencesVC = MyPreferencesVC.instantiate(appStoryboard: .Profile)
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnPreference, view_bg: self.viewPreference, img_arrow: self.imgPreference_arrow, current_vc: vc)
            
        } else if sender.tag == 8 {
            let vc: MyReminderVC = MyReminderVC.instantiate(appStoryboard: .Profile)
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnReminder, view_bg: self.viewReminder, img_arrow: self.imgReminder_arrow, current_vc: vc)
            
        } else if sender.tag == 9 {
            if appDelegate.isPlanPurchased {
                let vc: ActiveSubscriptionVC = ActiveSubscriptionVC.instantiate(appStoryboard: .Profile)
                self.push_screen(indx_tag: sender.tag, btn_click: self.btnMySubscription, view_bg: self.viewMySubscription, img_arrow: self.imgMySubscription_arrow, current_vc: vc)

            } else {
                let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
                self.push_screen(indx_tag: sender.tag, btn_click: self.btnMySubscription, view_bg: self.viewMySubscription, img_arrow: self.imgMySubscription_arrow, current_vc: vc)
            }
            
        } else if sender.tag == 10 {
            let vc: SettingsVC = SettingsVC.instantiate(appStoryboard: .Profile)
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnSetting, view_bg: self.viewSetting, img_arrow: self.imgSetting_arrow, current_vc: vc)
            
        } else if sender.tag == 11 {
            let vc: ContactSupportVC = ContactSupportVC.instantiate(appStoryboard: .Profile)
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnContactUs, view_bg: self.viewContactUs, img_arrow: self.imgContactUs_arrow, current_vc: vc)
            
        } else if sender.tag == 12 {
            let vc: CommonBottomPopupVC = CommonBottomPopupVC.instantiate(appStoryboard: .Profile)
            vc.height = 250
            vc.presentDuration = 0.3
            vc.dismissDuration = 0.3
            vc.titleStr = "Are you sure you want to logout from this account?"
            vc.yesTapped = {
                CurrentUser.shared.logoutUser()
            }
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnLogout, view_bg: self.viewLogout, img_arrow: self.imgLogout_arrow, current_vc: vc)

        }
        else if sender.tag == 13 {
            let vc: LinkUnlinkVC = LinkUnlinkVC.instantiate(appStoryboard: .Profile)
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnLinkAccount, view_bg: self.viewLinkAccount, img_arrow: self.imgLinkAccount_arrow, current_vc: vc)
        }
        else if sender.tag == 14 {
            let vc: AboutCreatorVC = AboutCreatorVC.instantiate(appStoryboard: .main)
            vc.isSetting = true
            self.push_screen(indx_tag: sender.tag, btn_click: self.btnCreator, view_bg: self.viewCreator, img_arrow: self.imgCreator_arrow, current_vc: vc)
            
        }
    }
    
    func push_screen(indx_tag: Int, btn_click: UIButton, view_bg: UIView, img_arrow: UIImageView?, current_vc: UIViewController) {

        UIView.animate(withDuration: 0.2) {
            
            if indx_tag == 2 {
                self.imgFavorite.tintColor = .primary
            }
            else if indx_tag == 3 {
                self.imgHistory.tintColor = .primary
            }
            else if indx_tag == 4 {
                self.imgDownload.tintColor = .primary
            }
            else if indx_tag == 11 {
                self.imgContactUs.tintColor = .primary
            }
            else if indx_tag == 12 {
                self.imgLogout.tintColor = .primary
            }
            
            
            btn_click.tintColor = .primary
            view_bg.backgroundColor = .secondary
            view_bg.viewBorderCorneRadius(borderColour: .primary)
            
            if img_arrow != nil {
                img_arrow?.viewBorderCorneRadius(borderColour: .primary)
            }

        } completion: { completed in
            
            if indx_tag == 12 {
                DispatchQueue.main.async {
                    self.present(current_vc, animated: true, completion: nil)
                }
            }
            else {
                current_vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(current_vc, animated: true)
            }
            
            self.screen_back_refresh()
        }
    }
    
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.viewEditProfile.backgroundColor = .secondary
            self.viewEditProfile.viewBorderCorneRadius(borderColour: .primary)
            self.imgEditProfile_arrow.viewBorderCorneRadius(borderColour: .primary)
            
            self.btnEditProfile.setImage(UIImage.init(named: "ic_edit_profile")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            self.btnEditProfile.tintColor = .primary
        } completion: { completed in
            let vc: EditProfileVC = EditProfileVC.instantiate(appStoryboard: .Profile)
            vc.hidesBottomBarWhenPushed = true
            vc.edited = {
                self.setupUI()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            self.screen_back_refresh()
        }
    }
    
    func screen_back_refresh() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timerrr in
            timerrr.invalidate()
            self.setTheView()
            self.setupImage()
        }
    }
    
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

extension NewProfileVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}



extension NewProfileVC{
    func get_AboutCreator_Onboarding(success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
            
        ServiceManager.shared.getRequest(ApiURL: .onboarding_about_creator, parameters: [:], isShowLoader: false) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                dic_aboutCreator = OnboardingAboutCreatorModel(json: response["data"])

                if let url = URL(string: dic_aboutCreator.file ?? "") {
                    
                    self.getSongDuration(from: url) { duration in
                        if let duration = duration {
                            dic_aboutCreator.audio_duration = Int(duration)
                        }
                    }
                }
                                
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func getSongDuration(from url: URL, completion: @escaping (Double?) -> Void) {
        let audioPlayer = AVPlayer()
        let playerItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: playerItem)
        
        // Wait for the duration to load
        playerItem.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            DispatchQueue.main.async {
                if playerItem.asset.statusOfValue(forKey: "duration", error: nil) == .loaded {
                    let duration = CMTimeGetSeconds(playerItem.asset.duration)
                    completion(duration.isFinite ? duration : nil)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
