//
//  ScriptHelpVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/10/23.
//

import UIKit
import NeatTipView

class ScriptHelpVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var txtGoal: AppCommonTextField!
    @IBOutlet weak var vwGoal: UIView!
    
    // MARK: - VARIABLES
    
    var customVM = CreateCustomAudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.txtGoal.delegate = self
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if (self.txtGoal.text ?? "") == "" {
            GeneralUtility().showErrorMessage(message: "Please enter your goal")
            return
        }
        self.customVM.goals_and_challenges = self.txtGoal.text ?? ""
        let vc: CreateStep3VC = CreateStep3VC.instantiate(appStoryboard: .CreateMusic)
        vc.customVM = self.customVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnInfoTapped(_ sender: UIButton) {
        if let frame22 = sender.superview?.convert(sender.center, to: nil) {
            var preferences = NeatViewPreferences()
            preferences.animationPreferences.appearanceAnimationType = .fadeIn
            preferences.animationPreferences.disappearanceAnimationType = .fadeOut
            preferences.bubbleStylePreferences.backgroundColor = hexStringToUIColor(hex: "#363C8A")
            preferences.bubbleStylePreferences.borderWidth = 0
            let tipView = NeatTipView(
                superview: self.view,
                centerPoint: frame22,
                attributedString: self.attributedString(),
                preferences: preferences,
                arrowPosition: .top)
            tipView.show()
        }
    }
    
    func attributedString() -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineHeightMultiple = 1.2
        let attributedString =
        NSMutableAttributedString(string: "Please tell us exactly what you're looking to accomplish. Whether it's stress relief, better sleep, emotional healing, past trauma,  personal growth, or something else, clear goals will allow us to create a focused and effective meditation for you.  What issues or challenges would you like this meditation to address? This could be work-related stress, health concerns, personal obstacles, or any other matter. The more we understand your struggles, the better we can tailor your meditation to provide comfort and support..", attributes: [.font: Font(.installed(.Regular), size: .standard(.S14)).instance, .foregroundColor: hexStringToUIColor(hex: "#E4E1F8"), .paragraphStyle: paragraph])
        return attributedString
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

extension ScriptHelpVC: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
