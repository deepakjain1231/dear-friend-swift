//
//  PaymentSuccessVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 23/10/23.
//

import UIKit
import Lottie

class PaymentSuccessVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var vwSuccess: UIView!
    
    // MARK: - VARIABLES
    
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
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
