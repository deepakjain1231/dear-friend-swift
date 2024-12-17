//
//  LoadingTVC.swift
//  ChillsQatarCustomer
//
//  Created by M1 Mac mini 4 on 05/08/22.
//

import UIKit

class LoadingTVC: UITableViewCell {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loader.startAnimating()
    }

    func startLoading() {
        loader.startAnimating()
    }
    
    func stopLoading() {
        loader.stopAnimating()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
