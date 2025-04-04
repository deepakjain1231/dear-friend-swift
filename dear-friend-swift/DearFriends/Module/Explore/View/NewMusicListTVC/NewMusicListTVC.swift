//
//  NewMusicListTVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 18/10/23.
//

import UIKit
import PopMenu

class NewMusicListTVC: UITableViewCell {

    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var imgPlayed: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var vwPremius: UIView!
    @IBOutlet weak var btnPremium: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnmore: UIButton!
    @IBOutlet weak var view_BG: UIView!
    @IBOutlet weak var view_main_BG: UIView!
    @IBOutlet weak var view_animateBG: UIView!
    @IBOutlet weak var view_animateButtonBG: UIView!
    @IBOutlet weak var constraint_view_main_BG_top: NSLayoutConstraint!
    @IBOutlet weak var constraint_view_main_BG_leading: NSLayoutConstraint!
    @IBOutlet weak var constraint_view_main_BG_trelling: NSLayoutConstraint!
    
    
    var arrOFTitle = [PopMenuArray]()
    var isForCustom = false
    var indexTapped: intCloser?
    var isUnFav = false
    var isCount1 = false
    var isPined = false
    var isHomePage : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.view_BG.backgroundColor = .clear// .primary?.withAlphaComponent(0.7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        if !self.isForCustom {
            self.showOptionsOf(sender: sender)
        }
    }
    
    @IBAction func btnPremiumTapped(_ sender: UIButton) {
        
    }
    
    
    func startAnimations() {
        let options: UIView.KeyframeAnimationOptions = [.curveEaseInOut, .repeat]
      UIView.animateKeyframes(withDuration: 1, delay: 0, options: options, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
          self.view_animateBG.alpha = ANI_RIPPLE_ALPHA
          self.view_main_BG.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
          self.view_animateBG.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
          self.view_main_BG.transform = CGAffineTransform.identity
          self.view_animateBG.alpha = 0
          self.view_animateBG.transform = CGAffineTransform(scaleX: aniRippleScale, y: aniRippleScale)
        })
        
      }, completion: nil)
    }
    
    func startAnimations_forButton() {
        let options: UIView.KeyframeAnimationOptions = [.curveEaseInOut, .repeat]
      UIView.animateKeyframes(withDuration: 1, delay: 0, options: options, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
          self.view_animateButtonBG.alpha = ANI_RIPPLE_ALPHA
            self.btnmore.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
          self.view_animateButtonBG.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
          self.btnmore.transform = CGAffineTransform.identity
          self.view_animateButtonBG.alpha = 0
          self.view_animateButtonBG.transform = CGAffineTransform(scaleX: aniRippleScale, y: aniRippleScale)
        })
        
      }, completion: nil)
    }
}

// MARK: - PopMenuViewControllerDelegate

extension NewMusicListTVC: PopMenuViewControllerDelegate {
    
    func showOptionsOf(sender: UIView) {
        
        self.arrOFTitle.removeAll()
        self.arrOFTitle.append(PopMenuArray(title: "Download", image: "ic_download_white"))
        if self.isUnFav {
            self.arrOFTitle.append(PopMenuArray(title: "Remove From Favorite", image: "ic_fav_white"))
        } else {
            self.arrOFTitle.append(PopMenuArray(title: "Favorite", image: "ic_fav_white"))
        }
        if !self.isCount1 {
            if self.isPined {
                self.arrOFTitle.append(PopMenuArray(title: "Unpin from top", image: "ic_pin_white"))
            } else {
                self.arrOFTitle.append(PopMenuArray(title: "Pin to Top", image: "ic_pin_white"))
            }
        }
        let arrays: [PopMenuAction] = self.arrOFTitle.map({PopMenuDefaultAction(title: $0.title, image: UIImage(named: $0.image), color: UIColor.white)})
        
        let controller = PopMenuViewController(sourceView: sender, actions: arrays)
        // Customize appearance
        controller.contentView.backgroundColor = hexStringToUIColor(hex: "#7A7AFC")
        controller.appearance.popMenuFont = Font(.installed(.Medium), size: .standard(.S14)).instance
        controller.accessibilityLabel = "\(sender.tag)"
        
        controller.appearance.popMenuColor.actionColor = .tint(.clear)
        controller.appearance.popMenuBackgroundStyle = .dimmed(color: UIColor.black, opacity: 0.5)
        controller.appearance.popMenuColor.backgroundColor = PopMenuActionBackgroundColor.solid(fill: hexStringToUIColor(hex: "#776ADA"))
        controller.appearance.popMenuCornerRadius = 10
        controller.appearance.popMenuItemSeparator = .fill(hexStringToUIColor(hex: "#675BC8"), height: 1)
        
        // Configure options
        controller.shouldDismissOnSelection = true
        controller.delegate = self
        
        controller.didDismiss = { selected in
            print("Menu dismissed: \(selected ? "selected item" : "no selection")")
        }
        
        // Present menu controller
        UIApplication.topViewController2()?.present(controller, animated: true, completion: nil)
    }
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        print("index tapped", index)
        self.indexTapped?(index)
    }
}
