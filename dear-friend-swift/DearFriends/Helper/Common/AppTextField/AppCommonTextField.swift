//
//  AppCommonTextField.swift
//  Youunite
//
//  Created by Zestbrains on 15/04/21.
//

import UIKit

class AppCommonTextField: UITextField {
    
    var button = UIButton(type: .custom)

    @IBInspectable var LeftPadding: CGFloat = 0.0 {
        didSet {
            
            if let lImg = leftImage {
                leftImage = lImg
            }else {
                let leftview = UIView(frame: CGRect(x: 0, y: 0, width: LeftPadding, height: frame.size.height))
                leftView = leftview
                leftViewMode = .always
            }
        }
    }
    @IBInspectable var RightPadding: CGFloat = 0.0 {
        didSet {
            let rightview = UIView(frame: CGRect(x: 0, y: 0, width: RightPadding, height: frame.size.height))
            rightView = rightview
            rightViewMode = .always
        }
    }

    @IBInspectable var leftImage: UIImage? = nil {
        didSet {

            let imageWidth : CGFloat = 55
            
            let vw = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: frame.size.height))
            
            let leftImageView = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: frame.size.height))
            leftImageView.contentMode = .scaleAspectFit
            leftImageView.image = leftImage
            leftImageView.clipsToBounds = true
            self.leftImageView = leftImageView
            var isSelectedField : Bool {
                return self.isSelectedTextField
            }
            self.isSelectedTextField = isSelectedField
            vw.addSubview(self.leftImageView)
            vw.backgroundColor = .clear
            
            vw.frame.size.width = imageWidth + self.LeftPadding + 30
            
            let lineVw = UIView(frame: CGRect(x: (vw.frame.size.width - 20), y: 10, width: 1, height: (frame.size.height - 20)))
            lineVw.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
            
            if addLeftLine {
                vw.frame.size.width = imageWidth + self.LeftPadding + 30
                vw.addSubview(lineVw)
            }else {
                vw.frame.size.width = imageWidth + self.LeftPadding
            }
            
            leftView = vw
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightImage: UIImage? = nil {
        didSet {
            let vw = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: frame.size.height))
            
            var isSelectedField : Bool {
                return self.isSelectedTextField
            }
            
            let rightImageView = UIImageView(frame: CGRect(x: 10, y: (frame.size.height / 2), width: 26, height: 26))
            button = UIButton(frame: CGRect(x: 10, y: (frame.size.height / 2), width: 26, height: 26))
            rightImageView.contentMode = .scaleAspectFit
            rightImageView.image = rightImage
            rightImageView.clipsToBounds = true
            self.rightImageView = rightImageView
            rightImageView.center = vw.center
            button.frame = vw.bounds
            self.isSelectedTextField = isSelectedField

            vw.addSubview(self.rightImageView)
            vw.backgroundColor = .clear

            if self.addPasswordEye {
                vw.addSubview(button)
                button.isSelected = false
                
                button.addAction(for: .touchUpInside) {
                    self.button.isSelected = !self.button.isSelected
                    if self.rightImage != UIImage(named: "ic_eye_show") {
                        self.rightImage = UIImage(named: "ic_eye_show")
                        self.rightImageView.image = self.rightImage
                    } else {
                        self.rightImage = UIImage(named: "ic_eye_hidden")
                        self.rightImageView.image = self.rightImage
                    }
                    self.isSecureTextEntry = !self.isSecureTextEntry
                    
                    self.isSelectedTextField = isSelectedField
                }
            }

            rightView = vw
            rightViewMode = .always
        }
    }
    
    var leftImageView = UIImageView()
    var rightImageView = UIImageView()

    var isSelectedTextField : Bool = false {
        didSet {
            if isSelectedTextField {
                leftImageView.image = leftImage
                rightImageView.image = rightImage

            } else {
                leftImageView.image = leftImage
                rightImageView.image = rightImage
            }
        }
    }

    @IBInspectable var addPasswordEye : Bool = false {
        didSet {
            if let ri = self.rightImage {
                self.rightImage = ri
            }
        }
    }

    @IBInspectable var addLeftLine : Bool = true {
        didSet {
            if let lImg = self.leftImage {
                self.leftImage = lImg
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if leftImage == nil && LeftPadding <= 0{
            self.LeftPadding = 20
        }
        if self.rightImage == nil {
            self.RightPadding = 20
        }
        self.setupTextField()
    }
    
    func setupTextField() {
        
        self.font = Font(.installed(.Medium), size: .custom(14.0)).instance
        
        self.textColor = .white
        self.placeHolderColor = hexStringToUIColor(hex: "#E4E1F8")
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.backgroundColor = hexStringToUIColor(hex: "#212159")
        self.addTarget(self, action: #selector(self.returnPressed(_:)), for: .editingDidEndOnExit)
        self.addTarget(self, action: #selector(self.editingBegin(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.editingEnd(_:)), for: .editingDidEnd)
        self.cornerRadius = 8
        self.borderColor = UIColor.clear
        self.borderWidth = 0
    }
 
    @objc private func returnPressed(_ textField: UITextField) {
        self.resignFirstResponder()
    }

    @objc private func editingBegin(_ textField: UITextField) {
        self.isSelectedTextField = true
    }

    @objc private func editingEnd(_ textField: UITextField) {
        self.isSelectedTextField = false
    }
    
    func addButtonRightSide(imageName: String, selectedImage : String = "", completionHandler: (UIButton) -> Void) {
        let button = UIButton(type: .custom)
        button.isSelected = false
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: selectedImage.isEmpty ? imageName : selectedImage), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        button.frame = CGRect(x: 0, y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        self.rightView = button
        self.rightViewMode = .always
        
        completionHandler(button)
    }
}

class AppCommonPickerTextField: AppCommonTextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addButtonRightSide(imageName: String, completionHandler: (UIButton) -> Void) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: "ic_password"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        button.frame = CGRect(x: 0, y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        self.rightView = button
        self.rightViewMode = .always
        
        completionHandler(button)
    }
    
    func addImageRightSide(imageName: String) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: 0, y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        self.rightView = button
        self.rightViewMode = .always
    }
}

extension AppCommonTextField: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}

extension UITextView {

    class PlaceholderLabel: UILabel { }

    var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholderColor: UIColor {
        get {
            return placeholderLabel.textColor
        }
        set{
            self.placeholderLabel.textColor = newValue
        }
    }
    
    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            placeholderLabel.textColor = self.placeholderColor
            placeholderLabel.alpha = 1
            let width = frame.width - textContainer.lineFragmentPadding * 2
           // let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.sizeToFit()
            //placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.autoresizesSubviews = true
            placeholderLabel.autoresizingMask = [.flexibleWidth]
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            //for hide/unhide textview when user
            textStorage.delegate = self
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}
