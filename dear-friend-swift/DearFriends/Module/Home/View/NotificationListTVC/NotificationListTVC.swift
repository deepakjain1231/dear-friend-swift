//
//  NotificationListTVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 17/05/23.
//

import UIKit

class NotificationListTVC: UITableViewCell {

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "")
        self.lblMsg.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "")
        self.lblTime.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 11, text: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
