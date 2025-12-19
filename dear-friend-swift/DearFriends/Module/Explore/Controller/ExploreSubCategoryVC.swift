//
//  ExploreSubCategoryVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 16/05/23.
//

import UIKit
import CollectionViewPagingLayout

class ExploreSubCategoryVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var colleView: UICollectionView!
    
    // MARK: - VARIABLES
    
    var currentIndex = 0
    var homeVM = HomeViewModel()
    var strTitle : String = ""
    var arrSize : [Float] = [170, 220, 210, 200]
    var previousSize : Float = 0
    // Extract unique numbers
//    let uniqueNumbers = Array(Set(inputNumbers))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTheView()
        self.setupUI()
        self.setCollectionViewLayout()
    }
    
    
     //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogoutService.shared.callAPIforCheckAnotherDeviceLogin()
        
        //RELOAD TABLE
//        self.colleView.reloadData()
    }

    
    // MARK: - Other Functions
    
    func setupUI() {
        self.colleView.setDefaultProperties(vc: self)
        self.colleView.registerCell(type: MusicCategoryCVC.self)
        self.setTheSize()
        self.lblTitle.text = self.strTitle
        
        self.colleView.restore()
        if (self.homeVM.currentCategory?.subCategory?.count ?? 0) == 0 {
            self.colleView.setEmptyMessage("No Sub Categories found")
        }
    }
        
    func setTheSize(){
//        fo self.homeVM.currentCategory?.subCategory?.count ?? 0
        for subCategory in self.homeVM.currentCategory?.subCategory ?? [] {
            if subCategory.size == nil { // First time
                let size = self.getRandomValue(from: self.arrSize, excluding: previousSize) ?? 0
                self.previousSize = size

                subCategory.size = size
            }
        }
        
        //RELOAD TABLE
        self.colleView.reloadData()

    }
    func setCollectionViewLayout(){
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 00
        layout.minimumInteritemSpacing = 15
        self.colleView.collectionViewLayout = layout

    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

extension ExploreSubCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,WaterfallLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeVM.currentCategory?.subCategory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCategoryCVC", for: indexPath) as? MusicCategoryCVC else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        
        let current = self.homeVM.currentCategory?.subCategory?[indexPath.row]
        
        cell.lblTitle.configureLable(textAlignment: .center, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 18, text: current?.title ?? "")
        cell.lblTitle.numberOfLines = 0
        
        GeneralUtility().setImage(imgView: cell.imgMain, imgPath: current?.icon ?? "")
        
      
        //SET VIEW
        cell.vwMain.viewCorneRadius(radius: 40)
        cell.vwMain.backgroundColor = .primary?.withAlphaComponent(0.5)
        cell.vwMain.viewBorderCorneRadius(borderColour: .secondary)
        addDropShadow(to: cell.vwMain, color: .primary ?? .black, opacity: 1, x: 0, y: 4, blur: 4)
        addInnerShadow(to: cell.vwMain, color: .primary ?? .black, opacity: 1, x: 0, y: 4, blur: 15)
//        addInnerShadow(to: cell.vwMain, color: .black, opacity: 0.5, radius: 5, offset: CGSize(width: -2, height: -2))

//
//        //SET VIEW
//        cell.vwMain.viewCorneRadius(radius: 25)
//        cell.vwMain.backgroundColor = .primary?.withAlphaComponent(0.7)
//        cell.vwMain.viewBorderCorneRadius(borderColour: .secondary)
//        
        
        
//        cell.consWidth.isActive = false
//        cell.consHeight.isActive = false
        
//        cell.consHeight.constant = 100
        
        cell.layoutIfNeeded()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.size.width - 20) / 2, height: 150)
    }
    
    
    func getRandomValue(from array: [Float], excluding lastValue: Float?) -> Float? {
        guard !array.isEmpty else { return nil }
        
        // Filter out the last value, if provided
        let filteredArray = lastValue != nil ? array.filter { $0 != lastValue } : array
        
        // Ensure there are values left to select from
        guard !filteredArray.isEmpty else { return nil }
        
        // Return a random value from the filtered array
        return filteredArray.randomElement()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = self.getRandomValue(from: self.arrSize, excluding: previousSize) ?? 0
//        self.previousSize = size
//        print("ttt======> \(size)")
//        
//        
////        for subCategory in self.homeVM.currentCategory?.subCategory ?? [] {

        return CGSize(width: (collectionView.frame.size.width - 20) / 2, height: manageWidth(size:  Double(self.homeVM.currentCategory?.subCategory?[indexPath.row].size ?? 0)))
    }
    
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? MusicCategoryCVC {
            //SET VIEW
            currentCell.vwMain.viewCorneRadius(radius: 40)
            currentCell.vwMain.backgroundColor = UIColor.init(hexString: "A8A8DF").withAlphaComponent(0.7)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? MusicCategoryCVC {
            //SET VIEW
            currentCell.vwMain.viewCorneRadius(radius: 40)
            currentCell.vwMain.backgroundColor = .primary?.withAlphaComponent(0.6)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? MusicCategoryCVC {
            currentCell.vwMain.viewCorneRadius(radius: 40)
            currentCell.vwMain.backgroundColor = UIColor.init(hexString: "A8A8DF").withAlphaComponent(0.7)

            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timerrrs in
                timerrrs.invalidate()
                currentCell.vwMain.backgroundColor = .primary?.withAlphaComponent(0.6)

                let vc: ExploreDetailsVC = ExploreDetailsVC.instantiate(appStoryboard: .Explore)
                vc.hidesBottomBarWhenPushed = true
                self.homeVM.currentFilterType = .none
                self.homeVM.currentAudioType = .normal
                self.homeVM.currentSubCategory = self.homeVM.currentCategory?.subCategory?[indexPath.row]
                vc.homeVM = self.homeVM
                self.navigationController?.pushViewController(vc, animated: true)
                
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timerrrs in
                    timerrrs.invalidate()
//                    collectionView.reloadData()
                }
            }
        }
    }
}


extension ExploreSubCategoryVC{
    func addDropShadow(to view: UIView, color: UIColor = .black, opacity: Float = 0.5, x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = 5.0) {
        view.layer.shadowColor = color.cgColor       // Shadow color
        view.layer.shadowOpacity = opacity          // Shadow opacity
        view.layer.shadowOffset = CGSize(width: x, height: y) // Shadow offset (x, y)
        view.layer.shadowRadius = blur              // Shadow blur radius
        view.layer.masksToBounds = false            // Prevent clipping of the shadow
    }
    
    
    func addInnerShadow(to view: UIView, color: UIColor = .black, opacity: Float = 0.5, x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = 5.0) {
        // Remove existing inner shadow layers (optional, for repeated calls)
        view.layer.sublayers?.removeAll(where: { $0.name == "InnerShadowLayer" })

        let innerShadowLayer = CAShapeLayer()
        innerShadowLayer.name = "InnerShadowLayer" // For identification if needed
        innerShadowLayer.frame = view.bounds

        // Create the shadow path
        let shadowPath = UIBezierPath(rect: view.bounds)
        let insetPath = UIBezierPath(rect: view.bounds.insetBy(dx: -blur, dy: -blur))
        shadowPath.append(insetPath)
        shadowPath.usesEvenOddFillRule = true

        innerShadowLayer.path = shadowPath.cgPath
        innerShadowLayer.fillRule = .evenOdd

        // Configure shadow properties
        innerShadowLayer.shadowColor = color.cgColor
        innerShadowLayer.shadowOpacity = opacity
        innerShadowLayer.shadowOffset = CGSize(width: x, height: y)
        innerShadowLayer.shadowRadius = blur
        innerShadowLayer.fillColor = UIColor.clear.cgColor

        // Add the inner shadow layer
        view.layer.addSublayer(innerShadowLayer)
    }
}
