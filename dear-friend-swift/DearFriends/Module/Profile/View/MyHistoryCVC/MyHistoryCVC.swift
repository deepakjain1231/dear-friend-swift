//
//  MyHistoryCVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 23/05/23.
//

import UIKit
import PopMenu

class MyHistoryCVC: UICollectionViewCell {
    
    @IBOutlet weak var vwPremium: UIView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgBG: UIImageView!

    var playTapped: voidCloser?
    var moreTapped: voidCloser?
    var favTapped: voidCloser?
    var deleteTapped: voidCloser?
    
    var newMenuTapped: intCloser?
    
    var arrOFTitle = [PopMenuArray]()
    var currentScreen: CurrentScreen = .history
    var isLiked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgBG.viewCorneRadius(radius: 10)
    }

    @IBAction func btnPlayTapped(_ sender: UIButton) {
        self.playTapped?()
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        if self.currentScreen != .download {
            self.showOptionsOf(sender: sender)
        } else {
            self.deleteTapped?()
        }
    }
    
    func dataBind(current: CommonAudioList) {
        let str_title = current.title ?? ""
        let ddd = current.audioDuration?.doubleValue ?? 0
        let str_duration = TimeInterval(ddd).formatDuration()
        
        self.lblTitle.configureLable(textColor: .text_color_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 20, text: str_title)
        self.lblDuration.configureLable(textColor: UIColor(named: "subTitleTextColor"), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 10, text: str_duration)

        GeneralUtility().setImage(imgView: self.imgMain, placeHolderImage: placeholderImage, imgPath: current.image ?? "")
    }
}

// MARK: - PopMenuViewControllerDelegate

extension MyHistoryCVC: PopMenuViewControllerDelegate {
    
    func showOptionsOf(sender: UIView) {
        
        self.arrOFTitle.removeAll()
        if self.currentScreen == .favourites {
            self.arrOFTitle.append(PopMenuArray(title: "Download", image: "ic_download_white"))
            self.arrOFTitle.append(PopMenuArray(title: "Remove from favorite", image: "ic_fav_white"))
        }
        if self.currentScreen == .history {
            self.arrOFTitle.append(PopMenuArray(title: "Download", image: "ic_download_white"))
            if self.isLiked {
                self.arrOFTitle.append(PopMenuArray(title: "Remove from favorite", image: "ic_fav_white"))
                
            } else {
                self.arrOFTitle.append(PopMenuArray(title: "Favorite", image: "ic_fav_white"))
            }
        }
        if self.currentScreen == .customAudio {
            self.arrOFTitle.append(PopMenuArray(title: "Download", image: "ic_download_white"))
            self.arrOFTitle.append(PopMenuArray(title: "Pin to Top", image: "ic_pin_white"))
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
        self.newMenuTapped?(index)
    }
}
