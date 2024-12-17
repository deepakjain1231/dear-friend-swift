//
//  LeftSideScriptTVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 24/10/23.
//

import UIKit

class LeftSideScriptTVC: UITableViewCell {

    @IBOutlet weak var btnScrtip: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vwMain.cornerRadius = 8
        self.vwMain.layer.maskedCorners = [.bottomRight, .topRight, .topLeft]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
