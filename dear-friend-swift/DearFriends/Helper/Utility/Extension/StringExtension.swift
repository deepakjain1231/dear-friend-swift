//
//  StringExtension.swift
//  MotoTP Customer
//
//  Created by Himanshu Visroliya on 15/11/21.
//


import UIKit

//MARK: - String Extension
extension String {
    //Get string length
    var length: Int { return self.count }
    
    //Remove white space in string
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    //Check string is number or not
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    //Check string is Float or not
    var isFloat : Bool {
        get{
     
            if Float(self) != nil {
                return true
            }else {
                return false
            }
        }
    }
    
    //Format Number If Needed
    func formatNumberIfNeeded() -> String {
        
        let charset = CharacterSet(charactersIn: "0123456789.,")
        if self.rangeOfCharacter(from: charset) != nil {
            
            let currentTextWithoutCommas:NSString = (self.replacingOccurrences(of: ",", with: "")) as NSString
            
            if currentTextWithoutCommas.length < 1 {
                return ""
            }
            let numberFormatter: NumberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            let numberFromString: NSNumber = numberFormatter.number(from: currentTextWithoutCommas as String)!
            let formattedNumberString: NSString = numberFormatter.string(from: numberFromString)! as NSString
            
            let convertedString:String = String(formattedNumberString)
            return convertedString
            
        } else {
            
            return self
        }
    }
    //MARK: - Check Contains Capital Letter
    func isContainsCapital() -> Bool {

        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = textTest.evaluate(with: self)
        return capitalResult
    }
    //MARK: - Check Contains Number Letter
    func isContainsNumber() -> Bool {
        
        let numberRegEx  = ".*[0-9]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = textTest.evaluate(with: self)
        return numberResult
    }
    //MARK: - Check Contains Special Character
    func isContainsSpecialCharacter() -> Bool {
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = textTest.evaluate(with: self)
        return specialResult
    }
    
    func isValidMobileNumber() -> Bool{
        
        if self.length < 10
        {
            return false
        }
        else if self.length > 10
        {
            return true
        }
        else
        {
            return true
        }
    }
    
    func isValidFaxNumber() -> Bool{
        
        if self.length < 12
        {
            return false
        }
        else if self.length > 12
        {
            return false
        }
        else
        {
            return true
        }
    }
    public func isHaveMinmumPassword() -> Bool {
        if self.length < 6
        {
            return false
        }
        else if self.length > 6
        {
            return true
        }
        else
        {
            return true
        }
    }

    public func isValidPassword() -> Bool {
       // let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
       // let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$"//mina
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
           return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    
    func isValidPostalCode() -> Bool {
        do {//  /[A-Z]{1,2}[0-9]{1,2}\s?[0-9]{1,2}[A-Z]{1,2}/i
            let regex = try NSRegularExpression(pattern: "[A-Z]{1,2}[0-9]{1,2}\\s[0-9]{1,2}[A-Z]{1,2}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }

    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
//    var length: Int {
//        return self.count
//    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    func isStringWithoutSpace() -> Bool{
        return !self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    var isAlphabate: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    var isAlphaNumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
    
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}
