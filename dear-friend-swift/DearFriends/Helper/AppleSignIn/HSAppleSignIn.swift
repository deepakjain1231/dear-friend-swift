//
//  HSAppleSignIn.swift
//  YesChef
//
//  Created by Hitesh Surani on 13/02/20.
//  Copyright © 2020 Hitesh Surani. All rights reserved.
//

import Foundation
import AuthenticationServices
import JWTDecode

typealias AppleSignInBlock = ((_ userInfo:AppleInfoModel?,_ errorMessge:String?)->())?


class HSAppleSignIn : NSObject {
    
//    static let shared = HSAppleSignIn()
    
    var appleSignInBlock:AppleSignInBlock!
    
    override init() {
        
    }
    
    
    @available(iOS 13.0, *)
    func loginWithApple(view:UIView? = nil,type:ASAuthorizationAppleIDButton.ButtonType? = .signIn,style:ASAuthorizationAppleIDButton.Style? = .black,completionBlock:AppleSignInBlock){
        
        let appleButton = ASAuthorizationAppleIDButton.init(type: type!, style:style!)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(self.didTapLoginWithApple), for: .touchUpInside)
        
        if let view = view{
            view.addSubview(appleButton)
            
            let topConstraint = NSLayoutConstraint(item: appleButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: appleButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            
            let trailingConstraint = NSLayoutConstraint(item: appleButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: appleButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            
            
            NSLayoutConstraint.activate([topConstraint, bottomConstraint, trailingConstraint, leadingConstraint])
        }
        appleSignInBlock = completionBlock
    }
    
    
    @available(iOS 13.0, *)
    func getAppleSignInButtonTo(type:ASAuthorizationAppleIDButton.ButtonType? = .signIn,style:ASAuthorizationAppleIDButton.Style? = .white,completionBlock:AppleSignInBlock) -> ASAuthorizationAppleIDButton{
        
        let appleButton = ASAuthorizationAppleIDButton.init(type: type!, style:style!)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(self.didTapLoginWithApple), for: .touchUpInside)
        appleSignInBlock = completionBlock
        return appleButton
    }
}

extension HSAppleSignIn:ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    @objc func didTapLoginWithApple()
    {
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.topViewController2()?.view.window ?? UIView().window!
    }
    
    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential
        {
        case let credential as ASAuthorizationAppleIDCredential:
            
            DispatchQueue.main.async {
                let userid = credential.user
                let firstName = credential.fullName?.givenName ?? Keychain.firstName ?? ""
                let lastName = credential.fullName?.familyName ?? Keychain.lastName ?? ""
                let fullName = firstName + " " + lastName
                var email = ""
                
                if let data = credential.identityToken {
                    if let token = String(data: data, encoding: .utf8) {
                        let dataOfApple = self.decode(jwtToken: token)
                        email = dataOfApple["email"] as? String ?? ""
                    }
                }
                                
                UserDefaults.standard.set(email, forKey: "AppleEmail")
                
                Keychain.userid = userid
                Keychain.firstName = firstName
                Keychain.lastName = lastName
                Keychain.email = email
                
                let userInfo = AppleInfoModel(userid: userid, email: email, firstName: firstName, lastName: lastName,fullName:fullName)
                self.appleSignInBlock?(userInfo,nil)
            }
            
            break
        default:
            break
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if (error as NSError).code != 1001{
            appleSignInBlock?(nil,error.localizedDescription)
        }
    }
}


