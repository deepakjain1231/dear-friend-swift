//
//  AppDelegate.swift
//  TheOry
//
//  Created by Himanshu Visroliya on 17/12/22.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import SwiftyJSON
import SwiftyStoreKit
import CoreData
import SwiftDate
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import AVFoundation
import MediaPlayer
import Stripe
//import FacebookCore
import GoogleSignIn
import AVKit
import Alamofire
import Mixpanel
import FirebaseMessaging
import AppsFlyerLib

enum InAppPlanID: String, CaseIterable {
    case monthly = "com.dearfriends.monthly"
    case yearly = "com.dearfriends.yearly"
}

//NOTIFICATIN DIC
var dicNotificationData : NSDictionary = [:]
var isHomeScreen : Bool = false


@main
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerLibDelegate {
  
    
    
    var window: UIWindow?
    var deviceToken = ""
    var isNetRootSet = false
    var sharedSecret = "f465a4f433df464f975174e09dda29d7"
    var planIDs = InAppPlanID.allCases.compactMap({$0.rawValue})
    var isPlanPurchased = false
    var isFromPush = false
    var deviceOrientation = UIInterfaceOrientationMask.portrait
    var unread_count = 0
    var contact_us_email = ""
    var titleText = ""
    var descText = ""
    var isOpenedFromNoti = false
    var finalAmountMain = ""
    var isInitialAppLoad = true
    var authVM = AuthViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //SET FIREBASE AND NOTIFICATION
        self.setFireBase_Notificaiton(application: application)

        SettingsBundleHelper.checkAndExecuteSettings()
        SettingsBundleHelper.setVersionAndBuildNumber()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch let error {
            print("error:  ", error.localizedDescription)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        STPAPIClient.shared.publishableKey = stripePublishKey
        
//sleep(1)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIView.self)
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UITextField.self)
        
        setupKeyboard(true)
        UITextField.appearance().keyboardAppearance = .dark
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        authVM.getAuthContent()
        CurrentUser.shared.versionCheckAPI()
        self.setOnboardingRoot()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.completeIAPTransactions()
        }
        
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 2
        gregorian.locale = Locale(identifier: "en_US_POSIX")
        let rome = Region(calendar: gregorian, zone: Zones.current, locale: Locale(identifier: "en_US_POSIX"))
        SwiftDate.defaultRegion = rome
        
        self.requestIDFA()
        
        if let lastProgress = UserDefaults.standard.string(forKey: lastProgressKey),
           let lastAudioId = UserDefaults.standard.string(forKey: lastAudioIdKey) {
            // Both lastPlay and lastAudioId have values
            print("Last play time: \(lastProgress)")
            print("Last audio ID: \(lastAudioId)")
            let audioVM = AudioViewModel()
            audioVM.playMusic(audio_id: lastAudioId, audioProgress: lastProgress) { _ in
                UserDefaults.standard.removeObject(forKey: lastProgressKey)
                UserDefaults.standard.removeObject(forKey: lastAudioIdKey)
            } failure: { error in
                
            }
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "f1ef24afc9e90cc069b8b165f1bd90d7" ]
        
        
        //APPS FLUER
        AppsFlyerLib.shared().appsFlyerDevKey = GlobalConstants.appsFlyerKey
        AppsFlyerLib.shared().appleAppID = GlobalConstants.appStoreId

        
        // MIXPANEL INITIALIZE
        Mixpanel.initialize(token: MIXPANEL_TOKEN, trackAutomaticEvents: false)
        
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        Mixpanel.mainInstance().track(event: Mixpanel_Event.AppOpen.rawValue, properties: nil)
        
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start(completionHandler: { (dictionary, error) in
            if (error != nil){
                print(error ?? "")
                return
            } else {
                print(dictionary ?? "")
                return
            }
        })
    }
    
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                // Business logic for Non-organic install scenario is invoked
                if let sourceID = installData["media_source"] as? String, let campaign = installData["campaign"] as? String, let adSet = installData["af_adset"] as? String, let ad = installData["af_ad"] as? String {
                    print("This is a Non-organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                    
                    

                    let params: [String: String] = [
                        "af_media_source": sourceID,
                        "af_campaign no": campaign,
                        "af_adset no": adSet,
                        "af_ad no": ad
                    ]
                    
                    Mixpanel.mainInstance().track(event: Mixpanel_Event.appInstal.rawValue, properties: params)
                    Mixpanel.mainInstance().flush()

                    
                }
            }
            else {
                // Business logic for organic install scenario is invoked
            }
        }
    }
    
    func onConversionDataFail(_ error: any Error) {
        print(error)

    }

    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if let topVC = UIApplication.topViewController2(), topVC is LandscapeAVPlayerController {
            return .all
        } else {
            return .portrait
        }
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return false
        //for facebook
//        return ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Mixpanel.mainInstance().track(event: Mixpanel_Event.SessionStart.rawValue, properties: nil)
        CurrentUser.shared.versionCheckAPI()
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let status = userInfo["Status"] as? String {
                print("CURRENT NETWORK :-- ", status)
                if status == "Offline" {
                    
                    if let topvc = UIApplication.topViewController2(), topvc is NoInternetVC || topvc is MyHistoryVC {
                        print("Already Opned \(topvc.description)")
                    } else {
                        let vc: NoInternetVC = NoInternetVC.instantiate(appStoryboard: .main)
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .overFullScreen
                        nav.modalTransitionStyle = .coverVertical
                        nav.isNavigationBarHidden = true
                        self.window?.rootViewController?.present(nav, animated: true, completion: nil)
                    }
                    
                } else {
                    self.manageNoNet()
                }
            }
        }
    }
    
    func manageNoNet() {
        if let topvc = UIApplication.topViewController2(), topvc is NoInternetVC {
            if self.isNetRootSet {
                self.setTabbarRoot()
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    NotificationCenter.default.post(name: Notification.Name("BottomView"), object: nil, userInfo: ["hide": "0"])
                }
                topvc.dismiss(animated: true)
            }
        }
    }
    
    //MARK: - CORE DATA
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        
        // SEE BELOW LINE OF CODE WHERE THE 'name' IS SET AS THE FILE NAME (SampleData) FOR THE CONTAINER
        
        let container = NSPersistentContainer(name: "DownloadCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    
    func setDefualtNavigationForapp() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("Not first launch.")
            
            if (CurrentUser.shared.user?.internalIdentifier) == nil || (CurrentUser.shared.user?.internalIdentifier) == 0 {
                
                self.setLoginRoot()
                
            } else {
                if Reach().connectionStatus().description == ReachabilityStatus.offline.description {
                    self.setNonetRoot()
                } else {
                    self.setTabbarRoot()
                }
            }
            
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.setOnboardingRoot()
        }
    }
    
    func setNonetRoot() {
        
        let vc: NoInternetVC = NoInternetVC.instantiate(appStoryboard: .main)
        let win = self.window ?? UIApplication.shared.keyWindow
        
        if(win != nil){
            UIView.transition(with: win!, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                let nav:UINavigationController = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                win!.rootViewController = nav
                win!.makeKeyAndVisible()
                self.isNetRootSet = true
                
            }, completion: { completed in
                
            })
        } else {
            
        }
    }
    
    func setOnboardingRoot() {
        
        let vc: CustomLaunchVC = CustomLaunchVC.instantiate(appStoryboard: .main)
        let win = self.window ?? UIApplication.shared.keyWindow
        
        if(win != nil){
            let nav:UINavigationController = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            win!.rootViewController = nav
            win!.makeKeyAndVisible()
        } else {
            
        }
    }
    
    func setMessageRoot(customID: String) {
        
        let vc: ChatMessageVC = ChatMessageVC.instantiate(appStoryboard: .CreateMusic)
        vc.isFromPush = true
        vc.isFromNoti = false
        vc.customID = customID
        let win = self.window ?? UIApplication.shared.keyWindow
        
        self.isFromPush = true
        
        if(win != nil){
            let nav:UINavigationController = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            win!.rootViewController = nav
            win!.makeKeyAndVisible()
        } else {
            
        }
    }
    
    func setNotiRoot(customID: String) {
        
        let vc: NotificationsVC = NotificationsVC.instantiate(appStoryboard: .Home)
        vc.isFromPush = true
        vc.isNavigateDone = true
        vc.customID = customID
        let win = self.window ?? UIApplication.shared.keyWindow
        
        self.isFromPush = true
        
        if(win != nil){
            let nav:UINavigationController = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            win!.rootViewController = nav
            win!.makeKeyAndVisible()
        } else {
            
        }
    }
    
    func setBookingRoot(id: String) {
        
        let vc: BookingDetailsVC = BookingDetailsVC.instantiate(appStoryboard: .MyBookings)
        vc.isFromPush = true
        vc.id = id
        let win = self.window ?? UIApplication.shared.keyWindow
        self.isFromPush = true
        
        if(win != nil){
            let nav:UINavigationController = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            win!.rootViewController = nav
            win!.makeKeyAndVisible()
        } else {
            
        }
    }
    
    func setReminderRoot() {
        
        let vc: MyReminderVC = MyReminderVC.instantiate(appStoryboard: .Profile)
        vc.isFromPush = true
        let win = self.window ?? UIApplication.shared.keyWindow
        self.isFromPush = true
        
        if(win != nil){
            let nav:UINavigationController = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            win!.rootViewController = nav
            win!.makeKeyAndVisible()
        } else {
            
        }
    }
    
    func setLoginRoot(isSignupScreen : Bool = false) {
        UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
        UserDefaults.standard.synchronize()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let vc: LoginVC = LoginVC.instantiate(appStoryboard: .main)
        vc.isSignupView = isSignupScreen
        let win = self.window ?? UIApplication.shared.keyWindow
        
        if(win != nil){
            UIView.transition(with: win!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let nav:UINavigationController = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                win!.rootViewController = nav
                win!.makeKeyAndVisible()
                
            }, completion: { completed in
                
            })
        } else {
            
        }
    }
    
//    func setRigisterRoot() {
//        UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
//        UserDefaults.standard.synchronize()
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        
//        let vc: RegisterVC = RegisterVC.instantiate(appStoryboard: .main)
//        vc.isRootView = true
//        let win = self.window ?? UIApplication.shared.keyWindow
//        
//        if(win != nil){
//            UIView.transition(with: win!, duration: 0.3, options: .transitionCrossDissolve, animations: {
//                let nav:UINavigationController = UINavigationController(rootViewController: vc)
//                nav.isNavigationBarHidden = true
//                win!.rootViewController = nav
//                win!.makeKeyAndVisible()
//                
//            }, completion: { completed in
//                
//            })
//        } else {
//            
//        }
//    }
    
    func setTabbarRoot() {
        
        let vc: RootStackTabViewController = RootStackTabViewController.instantiate(appStoryboard: .Tabbar)
        let win = self.window ?? UIApplication.shared.keyWindow
        
        if(win != nil){
            UIView.transition(with: win!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let nav:UINavigationController = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                win!.rootViewController = nav
                win!.makeKeyAndVisible()
                self.isNetRootSet = false
                
            }, completion: { completed in
                
            })
        } else {
            
        }
        
    }
    
    func setTabbarRootInitialTime(is_initialTime: Bool = false) {
        if self.isInitialAppLoad == false {
            return
        }
        
        self.isInitialAppLoad = is_initialTime
        
        if self.isInitialAppLoad {
            self.isInitialAppLoad = false
            
            debugPrint("setTabbarRoot")
            let vc: RootStackTabViewController = RootStackTabViewController.instantiate(appStoryboard: .Tabbar)
            let win = self.window ?? UIApplication.shared.keyWindow
            
            if(win != nil){
                UIView.transition(with: win!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let nav:UINavigationController = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                win!.rootViewController = nav
                win!.makeKeyAndVisible()
                self.isNetRootSet = false
                
                }, completion: { completed in
                
                })
            } else {
                
            }
        }
    }
}


//MARK: - IN App Purchase
extension AppDelegate {
    
    func completeIAPTransactions() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
    }
    
    func verifyPlanReciptMain() {
        if let loadedString = UserDefaults.standard.string(forKey: lastPlanPurchsed) {
            print(loadedString)
            self.verifyPlanRecipt(productId: loadedString, isFromSplash: true) { success in
                
            }
        }
    }
    
    func verifyPlanRecipt(productId: String,
                          transactionId: String = "",
                          isFromSplash: Bool = false,
                          isForRestore: Bool = false,
                          isShowLoader: Bool = false,
                          Success: @escaping (Bool) -> Void) {
        if isShowLoader {
            SHOW_CUSTOM_LOADER()
        }
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: appDelegate.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true) { result in
            HIDE_CUSTOM_LOADER()
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    self.isPlanPurchased = true
                    if items.count > 0 {
                        var params = [String: Any]()
                        if isShowLoader {
                            SHOW_CUSTOM_LOADER()
                        }
                        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
                            HIDE_CUSTOM_LOADER()
                            switch result {
                            case .success(let receiptData):
                                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                                
                                if productId == InAppPlanID.monthly.rawValue {
                                    params["total_price"] = "6.99"
                                    params["type"] = "monthly"
                                    params["title"] = "Monthly plan"
                                    params["details"] = "Monthly plan"
                                    
                                } else {
                                    params["total_price"] = "49.99"
                                    params["type"] = "yearly"
                                    params["title"] = "Yearly plan"
                                    params["details"] = "Yearly plan"
                                }
                                params["device_type"] = "ios"
                                params["currency_symbol"] = "$"
                                params["currency"] = "usd"
                                params["transaction_id"] = items.first?.originalTransactionId
                                params["package_name"] = productId
                                params["plan_id"] = productId
                                params["start_date"] = items.first?.originalPurchaseDate.in(region: .local).date.toFormat("yyyy-MM-dd")
                                params["end_date"] = items.first?.subscriptionExpirationDate?.in(region: .local).date.toFormat("yyyy-MM-dd")
                                params["purchase_token"] = encryptedReceipt
                                
                                UserDefaults.standard.set(productId, forKey: lastPlanPurchsed)
                                UserDefaults.standard.synchronize()
                                
                                if isForRestore {
                                    self.planRestore(param: ["transaction_id": items.first?.originalTransactionId ?? ""])
                                } else {
                                    self.planPurchase(param: params, isFromSplash: isFromSplash) { success2 in
                                        Success(success2)
                                    }
                                }
                                
                            case .error(let error):
                                print("Fetch receipt failed: \(error)")
                                self.isPlanPurchased = false
                                HIDE_CUSTOM_LOADER()
                                if isFromSplash {
                                    UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
                                    UserDefaults.standard.synchronize()
                                    appDelegate.setTabbarRoot()
                                }
                            }
                        }
                    }
                    
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    self.isPlanPurchased = false
                    HIDE_CUSTOM_LOADER()
                    if isFromSplash {
                        UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
                        UserDefaults.standard.synchronize()
                        appDelegate.setTabbarRoot()
                    }
                    
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    self.isPlanPurchased = false
                    HIDE_CUSTOM_LOADER()
                    if isFromSplash {
                        UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
                        UserDefaults.standard.synchronize()
                        appDelegate.setTabbarRoot()
                    }
                }
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
                self.isPlanPurchased = false
                HIDE_CUSTOM_LOADER()
                if isFromSplash {
                    UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
                    UserDefaults.standard.synchronize()
                    appDelegate.setTabbarRoot()
                }
            }
        }
    }
    
    func planRestore(param: [String: Any]) {
        ServiceManager.shared.postRequest(ApiURL: .restoreplan, parameters: param, isShowLoader: true) { response, isSuccess, error, statusCode in
            print("Success Response:", response)
            if isSuccess == true {
                CurrentUser.shared.GetUserProfile(isShowLoader: true) { _ in
                    appDelegate.isPlanPurchased = true
                    UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
                    UserDefaults.standard.synchronize()
                    appDelegate.setTabbarRoot()
                } failure: { _ in
                    
                }
            } else {
                
            }
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
        }
    }
    
    func planPurchase(param: [String: Any], isFromSplash: Bool, Success: @escaping (Bool) -> Void) {
        ServiceManager.shared.postRequest(ApiURL: .purchasePlan, parameters: param, isShowLoader: !isFromSplash) { response, isSuccess, error, statusCode in
            print("Success Response:", response)
            if isSuccess == true {
                CurrentUser.shared.GetUserProfile(isShowLoader: true) { _ in
                    self.isPlanPurchased = true
                    UserDefaults.standard.removeObject(forKey: lastPlanPurchsed)
                    UserDefaults.standard.synchronize()
                    if isFromSplash {
                        appDelegate.setTabbarRoot()
                    } else {
                        Success(true)
                        if let topVC = UIApplication.topViewController2() {
                            UIApplication.topViewController2()?.navigationController?.popViewController(animated: true)
                        }
                    }
                } failure: { _ in
                    
                }
            } else {
                
            }
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
        }
    }
}


//MARK: - VIMEO EXTRACTOR
extension AppDelegate {

    func callAPIforVimeoExtracter(vimeo_id: String, current_view: UIViewController, completion: @escaping (Bool, String)->Void ) {
        //API Call
        if ServiceManager.checkInterNet() {
            SHOW_CUSTOM_LOADER()
            let urlString = BaseURL_Vimeo + vimeo_id
            
            AF.request(urlString, method: .get, parameters: nil, encoding:URLEncoding.default, headers: ["Authorization": Kvimeo_access_Token]).validate().responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments)  { response in
                switch response.result {
                case .success(let value):
                    print("API URL: - \(urlString)\n\n\nResponse: - \(response)")
                    guard let dicResponse = (value as? [String: Any]) else {
                        completion(false, "")
                        return
                    }

                    var str_video_url = ""
                    
                    if let player_url = dicResponse["player_embed_url"] as? String {
                        str_video_url = player_url
                    }
                    
                    if str_video_url != "" {
                        completion(true, str_video_url)
                    }
                    else {
                        completion(false, "")
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(false, "")
                }
            }
        }
        else {
            completion(false, "")
        }
    }
}

//
//func callAPIforVimeoExtracter(vimeo_url: String, current_view: UIViewController, completion: @escaping (Bool, String)->Void ) {
//    //API Call
//    if Utils.isConnectedToNetwork() {
//      Utils.startActivityIndicatorInView(current_view.view, userInteraction: false)
//      let arr_url = vimeo_url.components(separatedBy: "/")
//      let urlString = BaseURL_Vimeo + (arr_url.last ?? "")
//      AF.request(urlString, method: .get, parameters: nil, encoding:URLEncoding.default, headers: ["Authorization": Kvimeo_access_Token]).validate().responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments) { response in
//        switch response.result {
//        case .success(let value):
//          print("API URL: - \(urlString)\n\n\nResponse: - \(response)")
//          guard let dicResponse = (value as? [String: Any]) else {
//            completion(false, "")
//            return
//          }
//          guard let arr_video_file = dicResponse["files"] as? [[String: Any]] else {
//            completion(false, "")
//            return
//          }
//          if arr_video_file.count != 0 {
//            var str_video_url = ""
//            let arr_filter_video_file = arr_video_file.filter({ dic_vimeo in
//              return (dic_vimeo["rendition"] as? String ?? "") == "540p"
//            })
//            if arr_filter_video_file.count != 0 {
//              str_video_url = arr_filter_video_file.first?["link"] as? String ?? ""
//            }
//            else {
//              str_video_url = arr_video_file.first?["link"] as? String ?? ""
//            }
//            completion(true, str_video_url)
//          }
//          else {
//            completion(false, "")
//            Utils.showAlertWithTitleInController(APP_NAME, message: "Something went wrong, please try again later", controller: current_view)
//          }
//        case .failure(let error):
//          print(error)
//          completion(false, "")
//          Utils.showAlertWithTitleInController(APP_NAME, message: error.localizedDescription, controller: current_view)
//        }
//        DispatchQueue.main.async(execute: {
//          Utils.stopActivityIndicatorinView(current_view.view)
//        })
//      }
//    }
//    else {
//      completion(false, "")
//      Utils.showAlertWithTitleInController(APP_NAME, message: NO_NETWORK, controller: current_view)
//    }
//  }
//
//
//
//
//
