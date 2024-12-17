//
//  ChooseBackgroundVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 18/05/23.
//

import UIKit
import BottomPopup

class ChooseBackgroundVC: BottomPopupViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - VARIABLES
    
    var fileSelected: intCloser?
    var index: Int?
    
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
    
    var arrOfBackgroundMusic = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .clear
        pickerView.tintColor = .clear
        pickerView.reloadAllComponents()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnApplyTapped(_ sender: UIButton) {
        if self.arrOfBackgroundMusic.count == 1 {
            self.fileSelected?(0)
        } else {
            if let intN = self.index {
                self.fileSelected?(intN)
            }
        }
        self.dismiss(animated: true)
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods

extension ChooseBackgroundVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrOfBackgroundMusic.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let rowSize = pickerView.rowSize(forComponent: component)
        let width = rowSize.width
        let height = rowSize.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: frame)
        label.font = Font(.installed(.Medium), size: .standard(.S20)).instance
        label.textColor = .white
        label.textAlignment = .center
        label.text = arrOfBackgroundMusic[row]
        
        pickerView.subviews.forEach { vi in
            vi.backgroundColor = .clear
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrOfBackgroundMusic[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = arrOfBackgroundMusic[row]
        self.index = row
        print("Selected option: \(selectedOption)")
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55
    }
}
