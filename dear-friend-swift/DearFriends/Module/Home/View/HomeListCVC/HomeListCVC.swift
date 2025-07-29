//
//  HomeListCVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 04/05/23.
//

import UIKit
import SkeletonView

class HomeListCVC: UICollectionViewCell {

    @IBOutlet weak var vwPremium: UIView!
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderColor = .red
        
        self.vwPremium.backgroundColor = .black.withAlphaComponent(0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.vwPremium.viewCorneRadius(radius: 10)
            self.vwPremium.backgroundColor = .black.withAlphaComponent(0.6)
        })
        
        self.lblPremium.configureLable(textColor: .background?.withAlphaComponent(0.7), fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 16, text: "Unlock With Premium")
        self.isSkeletonable = true
        self.subviews.forEach { viw in
            viw.isSkeletonable = true
        }
    }
}
