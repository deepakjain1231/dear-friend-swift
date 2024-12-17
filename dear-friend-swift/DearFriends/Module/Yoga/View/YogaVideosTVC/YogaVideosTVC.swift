//
//  YogaVideosTVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/09/23.
//

import UIKit
import youtube_ios_player_helper

class YogaVideosTVC: UITableViewCell {

    @IBOutlet weak var imgPremium: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var videoID = ""
    var isPremium = false
    var premimTpaped: voidCloser?
    var playTapped: voidCloser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnPlayTapped(_ sender: UIButton) {
        if self.isPremium {
            self.premimTpaped?()
        } else {
            self.playTapped?()
        }
    }    
}
