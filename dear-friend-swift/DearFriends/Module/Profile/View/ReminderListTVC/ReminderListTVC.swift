//
//  ReminderListTVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 20/05/23.
//

import UIKit
import SkeletonView
import PopMenu

struct PopMenuArray {
    var title = ""
    var image = ""
}

class ReminderListTVC: UITableViewCell {

    @IBOutlet weak var vwLeft: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrOfDays = ["M", "T", "W", "T", "F", "S", "S"]
    var current: ReminderListingModel?
    var editTapped: voidCloser?
    var deleteTapped: voidCloser?
    
    var arrOFTitle = [PopMenuArray]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.vwLeft.clipsToBounds = true
        self.vwLeft.layer.cornerRadius = 8
        self.vwLeft.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.showOptionsOf(sender: sender)
    }
}

// MARK: - PopMenuViewControllerDelegate

extension ReminderListTVC: PopMenuViewControllerDelegate {
    
    func showOptionsOf(sender: UIView) {
        
        self.arrOFTitle.removeAll()
        self.arrOFTitle.append(PopMenuArray(title: "Edit", image: "ic_edit"))
        self.arrOFTitle.append(PopMenuArray(title: "Remove", image: "ic_delete_3"))
        let arrays: [PopMenuAction] = self.arrOFTitle.map({PopMenuDefaultAction(title: $0.title, image: UIImage(named: $0.image), color: UIColor.white)})
        //PopMenuDefaultAction(title: "Acton Title 1")
        
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
        controller.shouldDismissOnSelection = false
        controller.delegate = self
        
        controller.didDismiss = { selected in
            print("Menu dismissed: \(selected ? "selected item" : "no selection")")
        }
        
        // Present menu controller
        UIApplication.topViewController2()?.present(controller, animated: true, completion: nil)
    }
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        
        print("index tapped", index)
        
        UIApplication.topViewController2()?.dismiss(animated: true) {
            if let indexx = Int(popMenuViewController.accessibilityLabel ?? "") {
                switch ["Edit", "Delete"][index] {
                    
                case "Delete" :
                    print("Delete Tapped")
                    self.deleteTapped?()
                    
                case "Edit" :
                    print("Edit Tapped")
                    self.editTapped?()
                    
                default :
                    break
                }
            }
        }
    }
}
