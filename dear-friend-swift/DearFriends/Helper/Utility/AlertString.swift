//
//  AlertString.swift
//  Youunite
//
//  Created by Mac on 06/11/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import Foundation

struct AlertMessage {
    
        //login/register
//    static let  logoutMessage: String =  "Are you sure you want to logout?"
//    static let  delete: String =  "Are you sure you want to delete your account permanently? Your all the data will be deleted permanently."
    static let  logoutMessage: String  = "We hope to welcome you back soon"

    static let  termsMissing: String =  "Please accept the terms and conditions to proceed"
    static let  candaMissing: String =  "Please accept you are legally allowed to work in canada."
    static let  OTPInCorrect: String  = "Please enter correct OTP"
    static let  nameMissing: String =  "Please enter your first name"
    static let  lastnameMissing: String =  "Please enter your last name"
    static let  EmailNameMissing: String = "Please enter your email address"
    static let  ValidEmail: String = "Please enter valid email address"
    static let  PasswordNotMatch: String = "New Password and confirm password doesn't match!"
    static let  PasswordNotMatch2: String = "Password does not match"
    static let  PasswordMissing: String = "Please enter password"
    static let  oldPasswordMissing: String = "Please enter old password"
    static let  ConfirmPasswordMissing: String = "Please enter confirm password"
    static let  PasswordMinMissing: String = "Password requires a minimum of 6 characters"
    static let  MobileMissing: String  = "Please enter mobile number"
    static let  userNameTaken: String =  "This username is already taken"
    static let  emailTaken: String =  "This email is already taken"
    static let  mobileTaken: String =  "This mobile is already taken"
    static let  termsUnseleted :  String =  "Please select terms and conditions to continue"
    static let  NewpasswordMissing: String = "Please enter new password"
    static let  addressMissing: String =  "Please enter your address"
    static let  detailsMissing: String =  "Please enter details"
    static let  OTPMissing: String  = "Please enter OTP"
    static let  OTPInvalid: String  = "Please enter all digits of OTP"
    
    static let  EmailUpdated: String = "Your email updated successfully."
    static let  MobileUpdated: String = "Your phone updated successfully."
}

struct EmptyCartMessage {

}

struct AddNewAddressMessages {
    
    static let enterFullAddress = "Please enter your full address"
    static let eneterHouse = "Please enter your house / flat / block no."
    static let selectAddressType = "Please select address type"
    static let deleteAddress = "Are you sure want to delete this address?"
}
