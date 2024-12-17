//
//  SuccessfullBookingVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 15/09/23.
//

import UIKit
import Lottie

class SuccessfullBookingVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btn: AppButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDecr: UILabel!
    @IBOutlet weak var vwSuccess: UIView!
    
    // MARK: - VARIABLES
    
    var yogaVM = VideoViewModel()
    var isFromYoga = false
    var isReschdule = false
    var isForCustomChat = false
    var myTitle = ""
    
    var isForMyOwn = false
    var customVM = CreateCustomAudioViewModel()
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        animationView = .init(name: "BookingSuccess")
        animationView!.frame = self.vwSuccess.bounds
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        vwSuccess.addSubview(animationView!)
        animationView!.play()
       
        if self.isForCustomChat {
            self.btn.setTitle("Go to Custom Audios", for: .normal)
            self.lblTitle.text = "Payment Successful!"
            self.lblDecr.text = "Thank you for your payment, we are excited to help you create a \(self.myTitle) that makes a meaningful impact in your life.  We'll send you a notification when your custom audio file become available on the app"
            
        } else if !self.isReschdule {
            self.lblTitle.text = "Your session has been successfully scheduled"
            self.lblDecr.text = "Your 1-1 session with \(self.yogaVM.currentInstructorDetails?.name ?? "") is now confirmed, a zoom meeting link will be provided in the booking details, you will receive a notification when it becomes available."
            
        } else {
            self.lblTitle.text = "Your session has been successfully rescheduled"
            self.lblDecr.text = "Your 1-1 session with \(self.yogaVM.currentInstructorDetails?.name ?? "") has been rescheduled, an updated zoom meeting link will be provided in the booking details, you will receive a notification when it becomes available."
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnGotoBookings(_ sender: UIButton) {
        if self.isForCustomChat {
            if let vc = self.navigationController?.viewControllers.last(where: { $0.isKind(of: CustomAudioRequestVC.self) }) {
                self.navigationController?.popToViewController(vc, animated: true)
            } else {
                let vc: CustomAudioRequestVC = CustomAudioRequestVC.instantiate(appStoryboard: .CreateMusic)
                vc.hidesBottomBarWhenPushed = true
                vc.isFromSuccess = true
                UIApplication.topViewController2()?.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else if self.isFromYoga {
            let vc: MyBookingVC = MyBookingVC.instantiate(appStoryboard: .MyBookings)
            vc.hidesBottomBarWhenPushed = true
            vc.isForSuccess = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            NotificationCenter.default.post(name: Notification.Name("ReloadBooking"), object: nil)
            self.navigationController?.popToViewController(ofClass: MyBookingVC.self)
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
