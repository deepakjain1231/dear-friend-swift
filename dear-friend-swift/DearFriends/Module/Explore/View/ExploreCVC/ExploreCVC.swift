//
//  ExploreCVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 11/05/23.
//

import UIKit

class ExploreCVC: UICollectionViewCell {
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var con_img: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.con_img.constant = manageWidth(size: 110)
//        self.addBorder()
    }

//    func addBorder() {
//                
//        self.vwMain.layer.cornerRadius = 25
//        self.vwMain.clipsToBounds = true
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
//        self.vwMain.layer.addSublayer(gradient)
//    }
}
