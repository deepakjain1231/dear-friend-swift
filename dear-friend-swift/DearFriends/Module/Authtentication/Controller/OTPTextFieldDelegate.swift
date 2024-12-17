//
//  OTPTextFieldDelegate.swift
//  Wanna
//
//  Created by Apple on 15/02/21.
//  Copyright © 2021 CoreDronSolutions. All rights reserved.
//

import Foundation
import UIKit

protocol OTPTextFieldDelegate {
    
    func codeTextFieldDidDeleteBackward(_ textField: OTPTextField)
}

class OTPTextField: UITextField {
    var codeDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        codeDelegate?.codeTextFieldDidDeleteBackward(self)
    }
}
