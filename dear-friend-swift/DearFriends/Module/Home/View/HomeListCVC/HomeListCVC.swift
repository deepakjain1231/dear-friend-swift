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
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.isSkeletonable = true
        self.subviews.forEach { viw in
            viw.isSkeletonable = true
        }
    }
}
