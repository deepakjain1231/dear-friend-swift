//
//  ShowCaseCollectionCell_1.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 29/12/24.
//

import UIKit

class ShowCaseCollectionCell_1: UICollectionViewCell {

    @IBOutlet weak var vwDec: UIView!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var lblDecs: AppExpandableLabel!
    @IBOutlet weak var lbl_tile: UILabel!
    @IBOutlet weak var lbl_subtile: UILabel!
    @IBOutlet weak var img_option: UIImageView!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var img_arrow_1: UIImageView!
    @IBOutlet weak var consraint_stack_bottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.img_option.isHidden = true
        self.img_arrow.isHidden = true
        self.lblDecs.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 13, text: "")
        
        
    }

}
