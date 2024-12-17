//
//  CreateStep4VC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 19/10/23.
//

import UIKit
import AVFoundation

enum Gender {
    case none
    case male
    case female
}

class CreateStep4VC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnSubmit: AppButton!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var stackFemale: UIStackView!
    @IBOutlet weak var stackMale: UIStackView!
    @IBOutlet weak var imgPlayFemale: UIImageView!
    @IBOutlet weak var imgPlayMale: UIImageView!
    @IBOutlet weak var txtMeditation: AppCommonTextField!
    @IBOutlet weak var vwFemaleVoice: UIView!
    @IBOutlet weak var vwMaleVoice: UIView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    
    // MARK: - VARIABLES
    
    var customVM = CreateCustomAudioViewModel()
    var audioPlayer: AVPlayer?
    var genderTapped: Gender = .none
    var genderTappedForPlay: Gender = .none
    var maleVoice: SampleAudioList?
    var femaleVoice: SampleAudioList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.vwScroll.isHidden = true
        
        self.vw1.backgroundColor = hexStringToUIColor(hex: "#363C8A")
        self.vw2.backgroundColor = hexStringToUIColor(hex: "#212159")
        
        self.txtMeditation.delegate = self
        self.genderTapped = .male
        
        self.customVM.getSampleAudioList { _ in
            if let male = self.customVM.arrOfSampleAudioList.first(where: {$0.gender == "male"}) {
                self.stackMale.isHidden = false
                self.vwMaleVoice.isHidden = false
                self.maleVoice = male
                self.customVM.voiceID = "\(male.internalIdentifier ?? 0)"
                self.vw1.borderWidth = 1
                self.vw2.borderWidth = 0
            } else {
                self.stackMale.isHidden = true
                self.vwMaleVoice.isHidden = true
            }
            
            if let female = self.customVM.arrOfSampleAudioList.first(where: {$0.gender == "female"}) {
                self.stackFemale.isHidden = false
                self.vwFemaleVoice.isHidden = false
                self.femaleVoice = female
                self.customVM.voiceID = "\(female.internalIdentifier ?? 0)"
                self.vw1.borderWidth = 0
                self.vw2.borderWidth = 1
            } else {
                self.stackFemale.isHidden = true
                self.vwFemaleVoice.isHidden = true
            }
            
            self.vw1.layoutIfNeeded()
            self.vw2.layoutIfNeeded()
            self.btnSubmit.isHidden = false
            self.vwScroll.isHidden = false
            
        } failure: { errorResponse in
            
        }
    }
    
    func managePlayerBeforePlay(destinationUrl: URL) {
        let playerItem2 = AVPlayerItem(url: destinationUrl)
        self.audioPlayer = AVPlayer(playerItem: playerItem2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.play()
        }
    }
    
    func play() {
        self.audioPlayer?.play()
        if self.genderTappedForPlay == .male {
            if (self.audioPlayer?.isPlaying ?? false) {
                self.imgPlayMale.image = UIImage(named: "ic_pause2")
            } else {
                self.imgPlayMale.image = UIImage(named: "ic_play2")
            }
        } else {
            if (self.audioPlayer?.isPlaying ?? false) {
                self.imgPlayFemale.image = UIImage(named: "ic_pause2")
            } else {
                self.imgPlayFemale.image = UIImage(named: "ic_play2")
            }
        }
    }
    
    func pause() {
        self.audioPlayer?.pause()
        if self.genderTappedForPlay == .male {
            if (self.audioPlayer?.isPlaying ?? false) {
                self.imgPlayMale.image = UIImage(named: "ic_pause2")
            } else {
                self.imgPlayMale.image = UIImage(named: "ic_play2")
            }
        } else {
            if (self.audioPlayer?.isPlaying ?? false) {
                self.imgPlayFemale.image = UIImage(named: "ic_pause2")
            } else {
                self.imgPlayFemale.image = UIImage(named: "ic_play2")
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if (self.txtMeditation.text ?? "") == "" {
            GeneralUtility().showErrorMessage(message: "Please enter meditation name")
            return
        }
        
        self.customVM.meditation_name = self.txtMeditation.text ?? ""
        
        if self.genderTapped == .male {
            if let male = self.customVM.arrOfSampleAudioList.first(where: {$0.gender == "male"}) {
                self.customVM.voiceID = "\(male.internalIdentifier ?? 0)"
            }
            
        } else if self.genderTapped == .female {
            if let female = self.customVM.arrOfSampleAudioList.first(where: {$0.gender == "female"}) {
                self.customVM.voiceID = "\(female.internalIdentifier ?? 0)"
            }
        }
        
        if self.customVM.script_file == "yes" {
            
            let vc: YogaPaymentPageVC = YogaPaymentPageVC.instantiate(appStoryboard: .Yoga)
            vc.isForCustomAudio = true
            vc.isForMyOwn = true
            vc.customVM = self.customVM
            vc.myTitle = self.txtMeditation.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.createCustomRequest()
        }
    }
    
    func createCustomRequest() {
        self.customVM.createCustomRequest { _ in
            let vc: RequestSubmittedVC = RequestSubmittedVC.instantiate(appStoryboard: .CreateMusic)
            vc.customVM = self.customVM
            self.navigationController?.pushViewController(vc, animated: true)
        } failure: { error in
            
        }
    }
    
    @IBAction func btnGenderTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            self.vw1.borderWidth = 1
            self.vw2.borderWidth = 0
            self.vw1.backgroundColor = hexStringToUIColor(hex: "#363C8A")
            self.vw2.backgroundColor = hexStringToUIColor(hex: "#212159")
            self.genderTapped = .male
            
        } else {
            self.vw2.borderWidth = 1
            self.vw1.borderWidth = 0
            self.vw2.backgroundColor = hexStringToUIColor(hex: "#363C8A")
            self.vw1.backgroundColor = hexStringToUIColor(hex: "#212159")
            self.genderTapped = .female
        }
    }
    
    @IBAction func btnPlayTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            if let current = self.maleVoice {
                if let urlSt = current.file, let url = URL(string: urlSt) {
                    if (self.audioPlayer?.isPlaying ?? false) && self.genderTappedForPlay == .male {
                        self.pause()
                    } else {
                        self.genderTappedForPlay = .male
                        self.imgPlayFemale.image = UIImage(named: "ic_play2")
                        self.audioPlayer?.pause()
                        self.managePlayerBeforePlay(destinationUrl: url)
                    }
                }
            }
        } else {
            if let current = self.femaleVoice {
                if let urlSt = current.file, let url = URL(string: urlSt)  {
                    if (self.audioPlayer?.isPlaying ?? false) && self.genderTappedForPlay == .female {
                        self.pause()
                    } else {
                        self.genderTappedForPlay = .female
                        self.imgPlayMale.image = UIImage(named: "ic_play2")
                        self.audioPlayer?.pause()
                        self.managePlayerBeforePlay(destinationUrl: url)
                    }
                }
            }
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

extension CreateStep4VC: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
