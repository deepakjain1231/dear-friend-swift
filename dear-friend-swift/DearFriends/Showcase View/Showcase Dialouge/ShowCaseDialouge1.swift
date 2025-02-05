//
//  ShowCaseDialouge1.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 29/12/24.
//

protocol delegate_done_showcase {
    func done_click_showcase(_ success: Bool, action: String)
}


import UIKit

class ShowCaseDialouge1: UIViewController {

    var scrollIndx = 0
    var str_desc_text = String()
    var tblFrame = CGRectMake(0, 0, 0, 0)
    var btnMusicOptionFrame = CGRect()
    var currentSubCategory: SubCategory?
    var arr_AudioList = [CommonAudioList]()
    var screenFrom = ""
    var delegate: delegate_done_showcase?
    
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var btn_Skip: UIButton!
    @IBOutlet weak var btn_Next: UIButton!
    @IBOutlet weak var btn_Prev: UIButton!
    @IBOutlet weak var btn_Option: UIButton!
    @IBOutlet weak var btn_music_Option: UIButton!
    @IBOutlet weak var img_Option: UIImageView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var view_animateOption_BG: UIView!
    @IBOutlet weak var view_animateMusic_Option_BG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_Prev.isHidden = true
        self.img_Option.isHidden = true
        self.btn_Option.isHidden = true
        self.btn_music_Option.isHidden = true
        self.setTheView()
        self.setupUI()
        
        self.view_main.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.perform(#selector(show_animation), with: nil, afterDelay: 0.1)
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.btn_Skip.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20.0, text: "Skip")
        self.btn_Prev.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20.0, text: "Prev")
        self.btn_Next.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20.0, text: "Next")
        
        //SET VIEW
        addDropShadow(to: self.btn_Option, color: .white, opacity: 0.5, x: 0, y: 4, blur: 4)
        addInnerShadow(to: self.btn_Option, color: .white, opacity: 0.5, x: 0, y: 4, blur: 15)
        
        addDropShadow(to: self.btn_music_Option, color: .white, opacity: 0.5, x: 0, y: 4, blur: 4)
        addInnerShadow(to: self.btn_music_Option, color: .white, opacity: 0.5, x: 0, y: 4, blur: 15)
    }
    
    func start_OptionButton_Animations() {
        let options: UIView.KeyframeAnimationOptions = [.curveEaseInOut, .repeat]
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: options, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.view_animateOption_BG.alpha = ANI_RIPPLE_ALPHA
                self.btn_Option.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.view_animateOption_BG.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
                self.view_animateMusic_Option_BG.alpha = ANI_RIPPLE_ALPHA
                self.btn_music_Option.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.view_animateMusic_Option_BG.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.btn_Option.transform = CGAffineTransform.identity
                self.view_animateOption_BG.alpha = 0
                self.view_animateOption_BG.transform = CGAffineTransform(scaleX: aniRippleScale, y: aniRippleScale)
                
                self.btn_music_Option.transform = CGAffineTransform.identity
                self.view_animateMusic_Option_BG.alpha = 0
                self.view_animateMusic_Option_BG.transform = CGAffineTransform(scaleX: aniRippleScale, y: aniRippleScale)
            })
            
        }, completion: nil)
    }
    
    func setupUI() {
        self.pagecontrol.numberOfPages = 2
        self.collection_view.delegate = self
        self.collection_view.dataSource = self
        self.collection_view.registerCell(type: ShowCaseCollectionCell_1.self)
        self.collection_view.reloadData()
        
        if self.screenFrom == "player" {
            self.img_Option.isHidden = false
            self.btn_Option.isHidden = false
            self.start_OptionButton_Animations()
        }
        
        self.btn_music_Option.frame = self.btnMusicOptionFrame
        self.btn_music_Option.frame.origin.y = self.btnMusicOptionFrame.origin.y - (appDelegate.window?.safeAreaInsets.top ?? 20)
        self.view_animateMusic_Option_BG.frame = self.btnMusicOptionFrame
    }
    
    @objc func show_animation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_main.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.view.layoutIfNeeded()
        }) { (success) in
            self.collection_view.reloadData()
        }
    }
    
    func clkToClose(_ action: Bool = false, str_action_name: String = "") {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_main.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.layoutIfNeeded()
            if self.screenFrom == "" {
                self.delegate?.done_click_showcase(true, action: str_action_name)
            }
        }) { (success) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            if action {
                self.delegate?.done_click_showcase(true, action: str_action_name)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func clkToClose(_ sender: Any) {
        self.clkToClose(true, str_action_name: "skip")
    }
    
    @IBAction func clkToPrev(_ sender: Any) {
        self.scrollIndx = self.scrollIndx - 1
        let desiredOffset = CGPoint(x: self.scrollIndx * Int(screenWidth), y: 0)
        self.collection_view.setContentOffset(desiredOffset, animated: true)
        self.setupButton()
    }
    
    @IBAction func clkToDone(_ sender: UIButton) {
        if (sender.titleLabel?.text ?? "") == "Next" {
            self.scrollIndx = self.scrollIndx + 1
            
            let desiredOffset = CGPoint(x: self.scrollIndx * Int(screenWidth), y: 0)
            self.collection_view.setContentOffset(desiredOffset, animated: true)
            self.setupButton()
        }
        else {
            self.clkToClose(true, str_action_name: "done")
        }
    }
    
    func setupButton() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if self.scrollIndx == 0 {
                self.btn_Prev.isHidden = true
                self.pagecontrol.currentPage = 0
                self.btn_music_Option.isHidden = true
                self.btn_Next.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20.0, text: "Next")
                self.btn_Option.isHidden = self.screenFrom == "player" ? false : true
                self.img_Option.isHidden = self.screenFrom == "player" ? false : true
                
                
            }
            else {
                self.img_Option.isHidden = true
                self.btn_Option.isHidden = true
                self.btn_Prev.isHidden = false
                self.pagecontrol.currentPage = 1
                self.btn_Next.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20.0, text: "Done")
                
                if self.screenFrom == "player" {
                    self.btn_music_Option.isHidden = false
                }
            }
        }
    }
}


// MARK: - Collection Methods

extension ShowCaseDialouge1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collection_view.contentOffset, size: self.collection_view.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collection_view.indexPathForItem(at: visiblePoint) {
            self.scrollIndx = visibleIndexPath.row
            self.pagecontrol.currentPage = visibleIndexPath.row
            self.setupButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCaseCollectionCell_1", for: indexPath) as? ShowCaseCollectionCell_1 else { return UICollectionViewCell() }
        cell.layoutIfNeeded()
        
        var str_showcaseTitle = indexPath.row == 0 ? showcase_1_indx_0_Title : showcase_1_indx_1_Title
        var str_showcase_subTitle = indexPath.row == 0 ? showcase_1_indx_0_subTitle : showcase_1_indx_1_subTitle
        
        if self.screenFrom == "player" {
            cell.tblMain.isHidden = true
            cell.img_arrow.isHidden = true
            str_showcaseTitle = indexPath.row == 0 ? showcase_2_indx_0_Title : showcase_2_indx_1_Title
            str_showcase_subTitle = indexPath.row == 0 ? showcase_2_indx_0_subTitle : showcase_2_indx_1_subTitle
            cell.img_option.isHidden = indexPath.row == 0 ? true : false
            cell.consraint_stack_bottom.constant = indexPath.row == 0 ? -50 : 50
            cell.img_arrow_1.isHidden = indexPath.row == 0 ? false : true
            cell.img_option.image = UIImage.init(named: "icon_showcase_2_bottom")
            cell.img_option.frame = CGRect(x: screenWidth - 155, y: self.btn_music_Option.frame.origin.y - 45, width: 90, height: 172)
        }
        else {
            //Table View
            cell.img_arrow_1.isHidden = true
            cell.tblMain.isHidden = false
            cell.tblMain.delegate = self
            cell.tblMain.dataSource = self
            cell.tblMain.registerCell(type: NewMusicListTVC.self)
            cell.tblMain.reloadData()
            cell.tblMain.accessibilityHint = "\(indexPath.row)"
            cell.img_option.image = UIImage.init(named: "icon_showcase_1")
            cell.img_option.frame = CGRect(x: screenWidth - 170, y: self.tblFrame.origin.y + 55, width: 125, height: 132)
            cell.consraint_stack_bottom.constant = -75
            
            cell.lblDecs.setupLabel()
            cell.lblDecs.collapsed = true
            cell.lblDecs.text = self.currentSubCategory?.info ?? ""
            cell.img_option.isHidden = indexPath.row == 0 ? true : false
        }
        
        cell.img_arrow.isHidden = indexPath.row == 0 ? true : false
        
        
        cell.lbl_tile.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 20, text: str_showcaseTitle)
        cell.lbl_subtile.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 15, text: str_showcase_subTitle)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


// MARK: - Tableview Methods

extension ShowCaseDialouge1: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_AudioList.count == 0 ? 1 : self.arr_AudioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewMusicListTVC") as? NewMusicListTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        
        if self.arr_AudioList.count == 0 {
            cell.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 16, text: "Body Scan")
            cell.lblSub.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 10, text: "10:23 min")
            
            cell.img.image = UIImage.init(named: "ic_temp3")
            cell.isUnFav = false
            
            cell.vwPremius.isHidden = true
            
            
            cell.progress.isHidden = true
            cell.imgPlayed.isHidden = true
            cell.progress.isHidden = true
            cell.progress.tintColor = hexStringToUIColor(hex: "#838383")
            cell.imgPlayed.isHidden = true
           
            //SET PIN
            cell.isPined = true
            cell.imgPin.isHidden = true
            
        }
        else {
            let current = self.arr_AudioList[indexPath.row]
            cell.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 16, text: current.title ?? "")
            
            let ddd = current.audioDuration?.doubleValue ?? 0
            cell.lblSub.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 10, text: TimeInterval(ddd).formatDuration())
            
            GeneralUtility().setImage(imgView: cell.img, imgPath: current.image ?? "")
            
            cell.isUnFav = (current.isLiked ?? 0) == 1
            
            if current.forSTr == "premium" && !appDelegate.isPlanPurchased {
                cell.vwPremius.isHidden = false
            } else {
                cell.vwPremius.isHidden = true
            }
            
            cell.progress.isHidden = true
            cell.imgPlayed.isHidden = true
            if appDelegate.isPlanPurchased{
                cell.progress.isHidden = !(current.audioProgress ?? "" != "")
                if let currentTime = current.audioProgress, let duration = current.audioDuration {
                    let progress = (Float(currentTime) ?? 0.0) / (Float(duration) ?? 0.0)
                    cell.progress.tintColor = progress <= 1 ? hexStringToUIColor(hex: "#7884E0") : hexStringToUIColor(hex: "#838383")
                    cell.imgPlayed.isHidden = progress <= 1
                    cell.progress.setProgress(Float(progress), animated: true)
                }
            }
           
            //SET PIN
            cell.isPined = ((current.pin_date ?? "") != "")
            cell.imgPin.isHidden = !cell.isPined
        }
        cell.isCount1 = self.arr_AudioList.count == 1
        
        if tableView.accessibilityHint == "0" {
            cell.startAnimations()
            cell.lblTitle.isHidden = false
            cell.lblSub.isHidden = false
            cell.img.isHidden = false
            cell.view_BG.backgroundColor = .primary
            cell.constraint_view_main_BG_top.constant = 12
            cell.constraint_view_main_BG_leading.constant = 12
            cell.constraint_view_main_BG_trelling.constant = 12
        }
        else {
            cell.startAnimations_forButton()
            cell.lblTitle.isHidden = true
            cell.lblSub.isHidden = true
            cell.img.isHidden = true
            cell.isUnFav = true
            cell.vwPremius.isHidden = true
            cell.imgPlayed.isHidden = true
            cell.isPined = true
            cell.imgPin.isHidden = true
            cell.view_BG.backgroundColor = .clear
            cell.constraint_view_main_BG_top.constant = 0
            cell.constraint_view_main_BG_leading.constant = 0
            cell.constraint_view_main_BG_trelling.constant = 0
        }
        
        
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension ShowCaseDialouge1{
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
