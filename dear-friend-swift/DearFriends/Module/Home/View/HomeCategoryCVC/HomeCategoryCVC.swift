//
//  HomeCategoryCVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 03/05/23.
//

import UIKit
import CollectionViewPagingLayout

class HomeCategoryCVC: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var viewImgBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.addBorder()
        
        self.lblTitle.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 18, text: "")
    }

//    func addBorder(radius: CGFloat = 25) {
//                
//        self.imgMain.layer.cornerRadius = radius
//        self.imgMain.clipsToBounds = true
//
//        let gradient = CAGradientLayer()
//        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.imgMain.frame.size)
//        gradient.colors =  [hexStringToUIColor(hex: "#B05148").cgColor,
//                            hexStringToUIColor(hex: "#F29A56").cgColor,
//                            hexStringToUIColor(hex: "#FFE1AC").cgColor,
//                            hexStringToUIColor(hex: "#8D3B33").cgColor]
//
//        let shape = CAShapeLayer()
//        shape.lineWidth = 4
//
//        shape.path = UIBezierPath(roundedRect: self.imgMain.bounds, cornerRadius: self.imgMain.layer.cornerRadius).cgPath
//
//        shape.strokeColor = UIColor.black.cgColor
//        shape.fillColor = UIColor.clear.cgColor
//        gradient.mask = shape
//        
//        gradient.cornerRadius = 25
//        gradient.shadowColor = UIColor.white.cgColor
//        gradient.shadowOffset = CGSize(width: 0, height: 0)
//        gradient.shadowOpacity = 0.4
//        gradient.shadowRadius = 6
//        gradient.accessibilityLabel = "gradient"
//        
//        self.imgMain.layer.addSublayer(gradient)
//    }
}
