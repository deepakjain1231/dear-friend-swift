//
//  RightSideMsgTVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 23/10/23.
//

import UIKit

class RightSideMsgTVC: UITableViewCell {

    @IBOutlet weak var acti: UIActivityIndicatorView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vwMain.cornerRadius = 8
        self.vwMain.layer.maskedCorners = [.topLeft, .topRight, .bottomLeft]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}