//
//  PopupViewController.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 28/11/24.
//

import UIKit

protocol PopUpProtocol : AnyObject {
    func SelctMenuIndex(Index : Int ,type : String)
}


class PopupViewController: UIViewController {
    weak var delegate : PopUpProtocol? = nil
    var arr_MenuList: [String] = []
    var arr_TypeList: [String] = []

    var selectIndex : Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

}


class cellPopUpList: UITableViewCell{
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewLine: UIView!
    @IBOutlet var imgSelect: UIImageView!
    @IBOutlet var imgPremium: UIImageView!
}

extension PopupViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_MenuList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return manageWidth(size: 50)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier:"cellPopUpList", for: indexPath) as? cellPopUpList{
            cell.backgroundColor = indexPath.row == selectIndex ? hexStringToUIColor(hex: "0E064A") : .clear
            
            cell.lblName.text = arr_MenuList[indexPath.row]
            
            //SET IMAGE
            cell.imgSelect.isHidden = indexPath.row == selectIndex ? false : true
            cell.viewLine.borderColor = hexStringToUIColor(hex: "0E064A")

            cell.imgPremium.isHidden = true
            if self.arr_TypeList[indexPath.row].lowercased() == "premium" && !appDelegate.isPlanPurchased {
                cell.imgPremium.isHidden = false
            }

            return cell
        }
        return UITableViewCell()
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        delegate?.SelctMenuIndex(Index: indexPath.row, type: self.arr_TypeList[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}

