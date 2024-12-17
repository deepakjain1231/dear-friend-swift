//
//  UploadScriptVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 19/10/23.
//

import UIKit
import QuickLookThumbnailing

class UploadScriptVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblFileName: UILabel!
    
    // MARK: - VARIABLES
    
    var customVM = CreateCustomAudioViewModel()
    var documentUploaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if !self.documentUploaded {
            GeneralUtility().showErrorMessage(message: "Please select document to continue")
            return
        }
        let vc: CreateStep3VC = CreateStep3VC.instantiate(appStoryboard: .CreateMusic)
        vc.customVM = self.customVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnChooseTapped(_ sender: UIButton) {
        self.openDocumentPicker()
    }
}

//MARK: - Document Picker

extension UploadScriptVC: UIDocumentPickerDelegate {
    
    private func openDocumentPicker() {
        let documentStyles = ["com.adobe.pdf"]
        var documentPicker = UIDocumentPickerViewController(documentTypes: documentStyles, in: .import)
        
        if #available(iOS 14.0, *) {
            let supportedTypes = [UTType.pdf]
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        }
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    //MARK: -
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Picked document URLS : \(urls)")
        
        for url in urls {
            if let data = try? Data(contentsOf: url) {
                
                let fileName = url.getDocumentName()
                self.customVM.selectedDoc = ServiceManager.MultiPartDataType(mimetype: "application/pdf", fileName: fileName, fileData: data, keyName: "script")
                self.lblFileName.text = fileName
                self.documentUploaded = true
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
