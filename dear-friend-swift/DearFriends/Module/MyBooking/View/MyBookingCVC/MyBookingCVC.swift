//
//  MyBookingCVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 08/09/23.
//

import UIKit

class MyBookingCVC: UICollectionViewCell {

    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var vwTop: UIView!
    
    var detailsTapped: voidCloser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vwTop.clipsToBounds = true
        self.vwTop.layer.cornerRadius = 8
        self.vwTop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func btnDetailsTapped(_ sender: UIButton) {
        self.detailsTapped?()
    }
}
