//
//  MusicCategoryCVC.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 22/12/24.
//

import UIKit
import CollectionViewPagingLayout

class MusicCategoryCVC: UICollectionViewCell {
    
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var consWidth: NSLayoutConstraint!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var imgMain: UIImageView!
    
//    var scaleOptions: ScaleTransformViewOptions = .layout(.linear)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.addBorder()
    }
    
//    func transform(progress: CGFloat) {
//        applyScaleTransform(progress: progress)
//    }
//
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
