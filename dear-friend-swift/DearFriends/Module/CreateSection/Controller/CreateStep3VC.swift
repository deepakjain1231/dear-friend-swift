//
//  CreateStep3VC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 19/10/23.
//

import UIKit

class CreateStep3VC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var colleView: UICollectionView!
    
    // MARK: - VARIABLES
    
    var index = -1
    var tempArray = ["You decide, Im Not Sure", "Short - Beginner", "A Bit Longer- Intermiediate", "Long - Expert"]
    var customVM = CreateCustomAudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        let tagsFlowLayout = TagsFlowLayout(alignment: .left ,minimumInteritemSpacing: 0, minimumLineSpacing: 0, sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.colleView.collectionViewLayout = tagsFlowLayout
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: ListSelectionCVC.self)
        self.colleView.reloadData()
        self.tableHeightManage()
    }
    
    func tableHeightManage() {
        self.colleView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.colleView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UICollectionView {
            if obj == self.colleView {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.consHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if self.index == -1 {
            GeneralUtility().showErrorMessage(message: "Please select your pause duration")
            return
        }
        self.customVM.pause_duration = self.tempArray[self.index]
        let vc: CreateStep4VC = CreateStep4VC.instantiate(appStoryboard: .CreateMusic)
        vc.customVM = self.customVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Collection Methods

extension CreateStep3VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tempArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListSelectionCVC", for: indexPath) as? ListSelectionCVC else { return UICollectionViewCell() }
        
        cell.lbl.text = self.tempArray[indexPath.row]
        if self.index == indexPath.row {
            cell.vwMain.borderWidth = 1
            cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#363C8A")
        } else {
            cell.vwMain.borderWidth = 0
            cell.vwMain.backgroundColor = hexStringToUIColor(hex: "#212159")
        }
        
        cell.vwMain.cornerRadius = 8
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.tempArray[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : Font(.installed(.Regular), size: .standard(.S14)).instance]).width + 32, height: 67)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.colleView.reloadData()
    }
}
