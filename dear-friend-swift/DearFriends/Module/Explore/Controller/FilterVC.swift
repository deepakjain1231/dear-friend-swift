//
//  FilterVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 16/05/23.
//

import UIKit
import BottomPopup

class FilterVC: BottomPopupViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var txtSortBy: AppCommonTextField!
    
    // MARK: - VARIABLES
    
    var arrOfFilter = ["Newest", "Oldest", "Duration High", "Duration Low"]
    var indexx: Int?
    
    var height: CGFloat = 0.0
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override var popupHeight: CGFloat { return height }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    var submitted: audioModel?
    var audioVM = AudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if self.audioVM.currentFilterType != .none, let index = self.audioVM.currentFilterIndex {
            self.txtSortBy.text = self.arrOfFilter[index]
        }
    }
    
    // MARK: - Other Functions
    
    // MARK: - Button Actions
    
    @IBAction func btnDropDownTapped(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = self.arrOfFilter
        dropDown.separatorColor = hexStringToUIColor(hex: "#675BC8")
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender.bounds.height))
        dropDown.backgroundColor = hexStringToUIColor(hex: "#776ADA")
        dropDown.selectionBackgroundColor = hexStringToUIColor(hex: "#212159")
        dropDown.textFont = Font(.installed(.Regular), size: .standard(.S12)).instance
        dropDown.textColor = .white
        
        if self.audioVM.currentFilterType != .none, let index = self.audioVM.currentFilterIndex {
            dropDown.selectRow(at: index)
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtSortBy.text = self.arrOfFilter[index]
            self.indexx = index
            self.audioVM.currentFilterIndex = index
            dropDown.hide()
        }

        dropDown.width = sender.frame.size.width
        dropDown.show()
    }
    
    @IBAction func btnResetTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        if self.audioVM.currentFilterType != .none {
            self.audioVM.currentFilterType = .none
            self.audioVM.currentFilterIndex = nil
            self.submitted?(self.audioVM)
        }
    }
    
    @IBAction func btnApplyTapped(_ sender: AppButton) {
        if let ind = self.indexx {
            self.audioVM.currentFilterType = FilterTypes.allCases[ind + 1]
            self.submitted?(self.audioVM)
        }
        self.dismiss(animated: true)
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods
