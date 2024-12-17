//
//  TabItemCollectionViewCell.swift
//  MYTabBarDemo
//
//  Created by Abhishek Thapliyal on 25/05/20.
//  Copyright © 2020 Abhishek Thapliyal. All rights reserved.
//

import UIKit
import FLUtilities

protocol StackItemViewDelegate: AnyObject {
    func handleTap(_ view: StackItemView)
}

class StackItemView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    
    private let higlightBGColor = hexStringToUIColor(hex: "#D2CDF3")
    private let txtBGColor = hexStringToUIColor(hex: "#FAFAFA")

    static var newInstance: StackItemView {
        return Bundle.main.loadNibNamed(
            StackItemView.className(),
            owner: nil,
            options: nil
        )?.first as! StackItemView
    }
    
    weak var delegate: StackItemViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture()
    }
    
    var isSelected: Bool = false {
        willSet {
            self.updateUI(isSelected: newValue)
        }
    }
    
    var item: Any? {
        didSet {
            self.configure(self.item)
        }
    }
    
    private func configure(_ item: Any?) {
        guard let model = item as? BottomStackItem else { return }
        self.titleLabel.configureLable(textColor: txtBGColor, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "")
        self.titleLabel.text = model.title
        
        if !model.isSelected {
            self.imgView.image = UIImage(named: model.image)
        } else {
            self.imgView.image = UIImage(named: model.selectedImage)
        }
        self.isSelected = model.isSelected
    }
    
    private func updateUI(isSelected: Bool) {
        guard let model = item as? BottomStackItem else { return }
        model.isSelected = isSelected
        let options: UIView.AnimationOptions = isSelected ? [.curveEaseIn] : [.curveEaseOut]
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.5,
                       options: options,
                       animations: {
            self.titleLabel.text = /*isSelected ?*/ model.title /*: ""*/
            self.titleLabel.configureLable(textColor: isSelected ? UIColor.background : self.txtBGColor, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: model.title)

            let color = isSelected ? UIColor.primary : .clear
            self.highlightView.viewCorneRadius(radius: 0)
            self.highlightView.backgroundColor = color
            self.highlightView.viewBorderCorneRadius(borderColour: isSelected ? UIColor.background : .clear)
            self.highlightView.layoutIfNeeded()
            self.highlightView.layoutSubviews()
            
            if !model.isSelected {
                self.imgView.image = UIImage(named: model.image)
            } else {
                self.imgView.image = UIImage(named: model.selectedImage)
            }
            imgColor(imgColor: self.imgView, colorHex: isSelected ? UIColor.background : self.txtBGColor)
            
            (self.superview as? UIStackView)?.layoutIfNeeded()
        }, completion: nil)
    }
    
}

extension StackItemView {
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.handleTap(self)
    }
}
