//
//  CommonWebViewVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 15/05/23.
//

import UIKit
import WebKit

enum CurrentWeb: String {
    case privacyPolicy = "Privacy Policy"
    case termCondition = "Terms & Conditions"
    case user_agreement_create_section = "User Agreement"
    case user_agreement_booking = "User Booking Agreement"
}

class CommonWebViewVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var vwProgress: UIProgressView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwWeb: WKWebView!
    
    // MARK: - VARIABLES
    
    var currentType: CurrentWeb = .privacyPolicy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setTheView()
        
        self.vwWeb.isOpaque = false
        self.vwWeb.backgroundColor = .clear
        self.lblTitle.text = self.currentType.rawValue
        self.changeStyle()
        
        var strWebURL = ""
        if currentType == .privacyPolicy {
            strWebURL = ApiURL.privacy.strURL()
            self.imgTop.image = UIImage(named: "ic_privacy_top")
            
        } else if currentType == .termCondition {
            strWebURL = ApiURL.terms.strURL()
            self.imgTop.image = UIImage(named: "ic_terms_top")
            
        } else if self.currentType == .user_agreement_create_section {
            strWebURL = ApiURL.user_agreement_create_section.strURL()
            self.imgTop.image = UIImage(named: "ic_terms_top")
            
        } else if self.currentType == .user_agreement_booking {
            strWebURL = ApiURL.user_agreement_booking.strURL()
            self.imgTop.image = UIImage(named: "ic_terms_top")
        }
        
        print("strWebURL", strWebURL)
        
        self.SHOW_CUSTOM_LOADER()
        if let url = URL(string: strWebURL) {
            self.fetchHTML(from: url)
        }
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
    }
    
    func fetchHTML(from url: URL) {
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                self.HIDE_CUSTOM_LOADER()
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    if var htmlString = String(data: data, encoding: .utf8) {
                        // Do something with the HTML string
                        DispatchQueue.main.async {
                            self.vwWeb.uiDelegate = self
                            self.vwWeb.navigationDelegate = self
//                            htmlString = htmlString.replacingOccurrences(of: "color: #000000", with: "color: #FFFFFF")
                            
                            let headString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
//                            let finallll = String(format: myVariable + myVariable2, (headString + htmlString))
                            self.vwWeb.isHidden = true
//                            self.vwWeb.loadHTMLString(finallll, baseURL: nil)

                            let attributedString = NSMutableAttributedString(withLocalizedHTMLString: (headString + htmlString))
                            attributedString?.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString?.length ?? 0))
                            attributedString?.addAttribute(.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: attributedString?.length ?? 0))
                            self.txtView.backgroundColor = .clear
                            self.txtView.attributedText = attributedString
                            self.txtView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
                            
                            print(htmlString)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Other Functions
    
    override func viewWillAppear(_ animated: Bool) {
        self.vwProgress.isHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(self.vwWeb.estimatedProgress)
            self.vwProgress.setProgress(Float(self.vwWeb.estimatedProgress), animated: true)
            if self.vwWeb.estimatedProgress == 1.0 {
                self.vwProgress.isHidden = true
            } else {
                self.vwProgress.isHidden = false
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: false)
    }
}

// MARK: - Tableview Methods

extension CommonWebViewVC: WKNavigationDelegate, WKUIDelegate {

    // Function to change text color
    func changeTextColor(color: String) {
        let javascript = "document.body.style.color = 'white';"
        self.vwWeb.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading")
        self.HIDE_CUSTOM_LOADER()
        changeTextColor(color: "white")
    }
}
