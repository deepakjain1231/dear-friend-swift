//
//  TimelineTVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 15/12/23.
//

import UIKit

class TimelineTVC: UITableViewCell {

    @IBOutlet weak var vwLine: VerticalDottedLineView!
    @IBOutlet weak var lblDec: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
