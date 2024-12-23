//
//  FeedbackVC.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 15/10/24.
//

import UIKit
import SwiftyJSON

class FeedbackVC: UIViewController {

    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Title2: UILabel!
    @IBOutlet weak var lbl_Title3: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var txtEmail: AppCommonTextField!
    @IBOutlet weak var btnSubmit: AppButton!
    @IBOutlet weak var txtAboutExp: AppCommonTextView!
    @IBOutlet weak var btnBack: UIButton!
    
    var selectedRate = -1
    var audioVM = AudioViewModel()
    var catId : Int?
    var subCatId : Int?
    var meditationId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.txtEmail.text = CurrentUser.shared.user?.email ?? ""
        self.txtEmail.isUserInteractionEnabled = false
        self.txtEmail.textColor = .TitleButtonColor
        self.setBgColors(views: [view1,view2,view3,view4,view5])
        self.setStar(imageViews: [star1,star2,star3,star4,star5])
        // Do any additional setup after loading the view.
    }
    

    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lbl_Title.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20, text: "Feedback")
        self.lbl_Title2.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "How would you rate this meditation?")
        self.lbl_Title3.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Please tell us about your experience.")
        
        self.txtEmail.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "", placeholder: "Type your experience...")
        self.btnSubmit.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Submit")
        self.btnSubmit.backgroundColor = .buttonBGColor
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.goBack(isGoingTab: false)
    }
    
    @IBAction func btnStarTapped(_ sender: UIButton) {
        self.setBgColors(views: [view1,view2,view3,view4,view5])
        self.setStar(imageViews: [star1,star2,star3,star4,star5])
        if sender.tag == 0{
            self.star1.image = UIImage(named: "ic_star_white")
            self.view1.backgroundColor = hexStringToUIColor(hex: "#7884E0")
        }else if sender.tag == 1{
            self.star2.image = UIImage(named: "ic_star_white")
            self.view2.backgroundColor = hexStringToUIColor(hex: "#7884E0")
        }else if sender.tag == 2{
            self.star3.image = UIImage(named: "ic_star_white")
            self.view3.backgroundColor = hexStringToUIColor(hex: "#7884E0")
        }else if sender.tag == 3{
            self.star4.image = UIImage(named: "ic_star_white")
            self.view4.backgroundColor = hexStringToUIColor(hex: "#7884E0")
        }else if sender.tag == 4{
            self.star5.image = UIImage(named: "ic_star_white")
            self.view5.backgroundColor = hexStringToUIColor(hex: "#7884E0")
        }
        selectedRate = sender.tag + 1
    }
    
    func setBgColors(views: [UIView]) {
        for view in views {
            view.backgroundColor = hexStringToUIColor(hex: "#212159")
        }
    }
    
    func setStar(imageViews: [UIImageView]) {
        for imageView in imageViews {
            imageView.image = UIImage(named: "ic_star")
        }
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        if selectedRate != -1, let strExp = txtAboutExp.text, !strExp.isEmpty {
            self.audioVM.shareFeedback(id: meditationId, categoryId: catId, subCateId: subCatId, rate: Double(selectedRate), description: strExp) { response in
                GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                self.goBack(isGoingTab: false)
            } failure: { errorResponse in
                GeneralUtility().showSuccessMessage(message: errorResponse["message"].stringValue)
            }
            
        } else {
            GeneralUtility().showSuccessMessage(message: "Please add feedback")
        }
    }

}
