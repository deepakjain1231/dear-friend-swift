//
//  FullImageVC.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 31/03/25.
//


import UIKit

class FullImageVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: - OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: - VARIABLES
    
    var homeVM = HomeViewModel()
    var customID = ""
    var file = ""
    var reloadIndex: intCloser?
    var isFromPush = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        updateZoomFor(size: self.view.bounds.size)

        GeneralUtility().setImage(imgView: self.img, imgPath: self.file)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomFor(size: view.bounds.size)
    }
        
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img
    }

    func updateZoomFor(size: CGSize) {
        let widthScale = size.width / img.bounds.width
        let heightScale = size.height / img.bounds.height
        let scale = min(widthScale,heightScale)
        scrollView.minimumZoomScale = scale
    }
    
    
    // MARK: - Other Functions
    
    func setupUI() {
        if self.isFromPush {
            self.homeVM.readNotifcation(id: "\(self.customID)", isShowLoader: false) { success in
             
                if let index = self.homeVM.arrOfNotifications.firstIndex(where: {$0.internalIdentifier == Int(self.customID)}) {
                    self.reloadIndex?(index)
                }
                
            } failure: { errorResponse in
                
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        appDelegate.isFromPush = false
        appDelegate.isOpenedFromNoti = false
        self.dismiss(animated: true)
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods

