//
//  AppTextView.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 15/10/24.
//

import Foundation
import UIKit

class AppCommonTextView: UITextView, UITextViewDelegate {


    // Padding for the text inside the text view
    @IBInspectable var textPadding: CGFloat = 10.0 {
        didSet {
            textContainerInset = UIEdgeInsets(top: textPadding, left: textPadding, bottom: textPadding, right: textPadding)
        }
    }

    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

    // Right-side button setup (like password visibility toggle)
    var rightButton: UIButton?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextView()
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }

    private func setupTextView() {
        // Setup placeholder label
        placeholderLabel.font = self.font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.text = placeholder
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)

        // Set placeholder position and appearance
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 7)
        placeholderLabel.isHidden = !text.isEmpty

        // Set delegate for managing placeholder visibility
        delegate = self
    }

    // Method to hide placeholder when typing begins
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    // Method to add a right-side button inside the text view
    func addButtonRightSide(imageName: String, completionHandler: @escaping (UIButton) -> Void) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: frame.width - 35, y: 0, width: 30, height: 30)
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        addSubview(button)

        rightButton = button
        completionHandler(button)
    }

    // Override layoutSubviews to adjust placeholder position dynamically
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = frame.width - textContainer.lineFragmentPadding * 2
        placeholderLabel.frame.size.width = width
        placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
    }
}
