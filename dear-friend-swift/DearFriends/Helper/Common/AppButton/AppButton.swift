//
//  AppButton.swift
//  PickleBall
//
//  Created by M1 Mac Mini 2 on 24/04/23.
//

import Foundation
import UIKit

enum buttonTypeMain : Int {
    case normal = 0
    case Submit = 1
    case save = 2
    case cancel = 3
}

@IBDesignable
class AppButton: UIButton {
    
    @IBInspectable var type : Int {
        get {
            return btnType.rawValue
        }
        set {
            btnType = buttonTypeMain(rawValue: newValue) ?? .normal
        }
    }
    
    var btnType : buttonTypeMain = .normal{
        didSet {
            commonInit()
        }
    }
    
    //INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func commonInit() {
        self.backgroundColor = hexStringToUIColor(hex: "#776ADA")
        self.titleLabel?.font = Font(.installed(.SemiBold), size: .custom(18.0)).instance
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .selected)
    }
    
    func addButtonBottomShadow() {
        
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = UIColor(named: "#FFE1AC")!.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 15
        layer.masksToBounds = false
        self.clipsToBounds = false
        
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 20, y: self.frame.height - 15, width: self.frame.size.width - 40, height: 10)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIButton {
    
    func addBgImage(image : UIImage? = UIImage(named: "ic_btn_bg"), cornerRadius: CGFloat = 16.0) {
        
        let imageVw = UIImageView(image: image)
        imageVw.bounds = self.frame
        imageVw.contentMode = .scaleToFill
        imageVw.clipsToBounds = true
        imageVw.layer.cornerRadius = cornerRadius
        
        imageVw.frame = self.bounds
        imageVw.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        imageVw.translatesAutoresizingMaskIntoConstraints = true
        
        self.layer.insertSublayer(imageVw.layer, at: 0)
    }
}
