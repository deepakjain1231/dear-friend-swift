//
//  ContactSupportVC.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 15/10/24.
//

import UIKit
import PopMenu
import AVFoundation

struct ContactMedia {
    var type = ""
    var url = URL(string: "")
    var image = UIImage()
}

class ContactMediaCVCell: UICollectionViewCell {
    @IBOutlet weak var imgMedia: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
}

class ContactSupportVC: UIViewController {

    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSubmit: AppButton!
    @IBOutlet weak var txtMessage: AppCommonTextView!
    
    @IBOutlet weak var lblUploadPhotoTitle: UILabel!
    @IBOutlet weak var lblUploadPhotoSubTitle: UILabel!
    
    @IBOutlet weak var lblContactSupportTitle: UILabel!
    @IBOutlet weak var lblMessageTitle: UILabel!
    
    @IBOutlet weak var imgVideoBug: UIImageView!
    @IBOutlet weak var imgBug: UIImageView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var btnDeleteMedia: UIButton!
    @IBOutlet weak var viewSelectedMedia: UIView!
    @IBOutlet weak var viewMedia: UIView!
    @IBOutlet weak var collectionSupportMedia: UICollectionView!
    
    var arrTitle: [ContactSupport] = ContactSupport.allCases
    var seletedTitle = -1
    var selectedImage: UIImage?
    var selectedVideoURL: URL?
    var controller: PopMenuViewController?
    var profileVM = ProfileViewModel()
    var arrMedia = [ContactMedia]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogoutService.shared.callAPIforCheckAnotherDeviceLogin()
    }
    
    //SET THE VIEW
    func setTheView() {
//        self.txtMessage.iq_addDone(target: self, action: #selector(self.btn_done_action), title: "Type message...")
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Contact Support")
        
        self.lblContactSupportTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 16, text: "Contact support")
        self.lblMessageTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 16, text: "Message")
        
        self.lblUploadPhotoTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Upload photo or video")
        self.lblUploadPhotoSubTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 12, text: "Please upload a photo or a video to show us what's going on, we really appreciate you taking the time to bring this to our attention")
        
        self.btnSubmit.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Submit")
        self.btnSubmit.backgroundColor = .buttonBGColor
    }
    
    @objc func btn_done_action() {
        self.view.endEditing(true)
    }
    
    func setupUI () {
        self.viewMedia.isHidden = arrMedia.count > 0
        self.viewSelectedMedia.isHidden = !self.viewMedia.isHidden
        self.viewImage.isHidden = true
        self.viewVideo.isHidden = true
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnSelectTitle(_ sender: UIButton) {
        self.showContactSupportOption(sender: sender)
    }
    
    private func updateMediaViews() {
        viewMedia.isHidden = arrMedia.count > 0
        viewSelectedMedia.isHidden = !viewMedia.isHidden
        collectionSupportMedia.reloadData()
    }

    private func handleImageAddition(img: UIImage) {
        let arrImgs = arrMedia.filter { $0.type == "image" }
        if arrImgs.count == 2 {
            GeneralUtility().showErrorMessage(message: "You can select maximum 2 photos")
        } else {
            arrMedia.append(ContactMedia(type: "image", url: URL(string: ""), image: img))
            DispatchQueue.main.async { 
                self.updateMediaViews()
            }
        }
    }

    private func handleVideoAddition(thumbImg: UIImage, videoUrl: URL) {
        let arrVideo = arrMedia.filter { $0.type == "video" }
        if arrVideo.isEmpty {
            convertVideoToMP4(inputURL: videoUrl) { outputURL, error in
                if let outputURL = outputURL {
                    print("Video successfully converted to MP4 at \(outputURL)")
                    self.selectedVideoURL = outputURL
                    self.arrMedia.append(ContactMedia(type: "video", url: outputURL, image: thumbImg))
                    DispatchQueue.main.async { self.updateMediaViews() }
                } else if let error = error {
                    print("Error converting video: \(error.localizedDescription)")
                }
            }
        } else {
            GeneralUtility().showErrorMessage(message: "You can select maximum 1 video")
        }
    }

    @IBAction func btnUploadMediaTapped(_ sender: Any) {
        if arrMedia.count == 3 {
            GeneralUtility().showErrorMessage(message: "Maximum media selected")
        } else {
            ImagePickerManager().pickMedia(self, sourceType: .gallery) { img in
                self.handleImageAddition(img: img)
            } _: { thumbImg, videoUrl in
                self.handleVideoAddition(thumbImg: thumbImg, videoUrl: videoUrl)
            }
        }
    }

    @IBAction func btnSubmitTapped(_ sender: Any) {
        if seletedTitle != -1 {
            let title = arrTitle[seletedTitle].displayName
            var images = [UIImage]()
            for media in arrMedia.filter({ $0.type == "image" }) {
                images.append(media.image)
            }
            profileVM.contactSupport(type: title, title: title, photos: images, video: selectedVideoURL, message: txtMessage.text) { response in
                self.goBack(isGoingTab: true)
                GeneralUtility().showSuccessMessage(message: SuccessMessage.successContactSupport)
            } failure: { errorResponse in
                GeneralUtility().showErrorMessage(message: errorResponse["message"].stringValue)
            }
        }
    }

    @IBAction func btnDeleteMedia(_ sender: Any) {
        if arrMedia.count == 3 {
            GeneralUtility().showErrorMessage(message: "Maximum media selected")
        } else {
            ImagePickerManager().pickMedia(self, sourceType: .gallery) { img in
                self.handleImageAddition(img: img)
            } _: { thumbImg, videoUrl in
                self.handleVideoAddition(thumbImg: thumbImg, videoUrl: videoUrl)
            }
        }
    }
    
    @objc func btnDeleteMediaClicked(sender : UIButton) {
        self.arrMedia.remove(at: sender.tag)
        self.viewMedia.isHidden = arrMedia.count > 0
        self.viewSelectedMedia.isHidden = !self.viewMedia.isHidden
        self.collectionSupportMedia.reloadData()
    }
    
    func convertVideoToMP4(inputURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        // Create an AVAsset from the input URL
        let asset = AVURLAsset(url: inputURL)
        
        // Create an export session with the asset and set the preset to high quality
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            let error = NSError(domain: "ExportSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot create export session"])
            completion(nil, error)
            return
        }
        
        // Set the output URL - typically in the temporary directory
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        
        // Set the output file type to mp4
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        // Export the video asynchronously
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                // Return the output URL when the export is successful
                completion(outputURL, nil)
            case .failed, .cancelled:
                // Handle error if export fails
                if let error = exportSession.error {
                    completion(nil, error)
                } else {
                    let error = NSError(domain: "ExportSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown export error"])
                    completion(nil, error)
                }
            default:
                break
            }
        }
    }
}

// MARK: - PopMenuViewControllerDelegate

extension ContactSupportVC: PopMenuViewControllerDelegate {
    
    func showContactSupportOption(sender: UIView) {
        var arrays: [PopMenuAction] = self.arrTitle.map({PopMenuDefaultAction(title: $0.displayName, color: UIColor.white)})
        if self.seletedTitle != -1 {
            
//            let action = PopMenuDefaultAction(title: self.arrTitle[self.seletedTitle].displayName, image: UIImage(named: "ic_selected_check"), color: hexStringToUIColor(hex: "#776ADA"), highlighted: true, backgroundColor2: hexStringToUIColor(hex: "#212159"))
//            action.highlightActionView(true)
//            action.tintColor = .white
            
//            arrays[self.seletedTitle] = action
        }
        
        self.controller = PopMenuViewController(sourceView: sender, actions: arrays)
        // Customize appearance
        self.controller?.contentView.backgroundColor = hexStringToUIColor(hex: "#7A7AFC")
        self.controller?.appearance.popMenuFont = Font(.installed(.Medium), size: .standard(.S14)).instance
        self.controller?.accessibilityLabel = "Contact Support"
        
        self.controller?.appearance.popMenuColor.actionColor = .tint(.clear)
        self.controller?.appearance.popMenuBackgroundStyle = .dimmed(color: UIColor.black, opacity: 0.5)
        self.controller?.appearance.popMenuColor.backgroundColor = PopMenuActionBackgroundColor.solid(fill: hexStringToUIColor(hex: "#776ADA"))
        self.controller?.appearance.popMenuCornerRadius = 10
        self.controller?.appearance.popMenuItemSeparator = .fill(hexStringToUIColor(hex: "#675BC8"), height: 1)
        
        // Configure options
        self.controller?.shouldDismissOnSelection = true
        self.controller?.delegate = self
        
        self.controller?.didDismiss = { selected in
            print("Menu dismissed: \(selected ? "selected item" : "no selection")")
        }
        
        // Present menu controller
        UIApplication.topViewController2()?.present(self.controller!, animated: true, completion: nil)
    }
    
   
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        print("index tapped", index)
        popMenuViewController.dismiss(animated: true)
       
            if self.seletedTitle == index {
                self.lblTitle.text = self.lblTitle.text
            } else {
                self.seletedTitle = index
                self.lblTitle.text = self.arrTitle[index].displayName
            }
    }
}

extension ContactSupportVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactMediaCVCell", for: indexPath) as! ContactMediaCVCell
        let media = self.arrMedia[indexPath.row]
        cell.imgMedia.image = media.image
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteMediaClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 3 - 30 // Adjust the division and padding
        return CGSize(width: cellWidth, height: cellWidth) // Make it square
    }
}
