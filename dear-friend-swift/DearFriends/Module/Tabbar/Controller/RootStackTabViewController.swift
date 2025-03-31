//
//  RootStackTabViewController.swift
//  MYTabBarDemo
//
//  Created by Abhishek Thapliyal on 30/05/20.
//  Copyright © 2020 Abhishek Thapliyal. All rights reserved.
//

import UIKit
import SwiftyJSON

class RootStackTabViewController: UIViewController {

    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
    var currentIndex = 0
    
    var customVM = CreateCustomAudioViewModel()
    
    var tab1VC = NewHomeVC.newInstance
    var tab2VC = ExploreVC.newInstance
    var tab3VC = CreateSectionVC.newInstance
    var tab4VC = NewProfileVC.newInstance
    var tab5VC = CustomAudioRequestVC.newInstance
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        for _ in 0..<5 {
            items.append(StackItemView.newInstance)
        }
        return items
    }()
    
    lazy var viewControllers: [UIViewController] = {
        return [self.tab1VC, self.tab2VC, /*self.tab3VC,*/ self.tab4VC]
    }()
    
    lazy var tabModels: [BottomStackItem] = {
        return [
            BottomStackItem(title: "Home", image: "ic_home_0", selectedImage: "ic_home_1"),
            BottomStackItem(title: "Explore", image: "ic_explore_0", selectedImage: "ic_explore_1"),
            /*BottomStackItem(title: "Create", image: "ic_create_0", selectedImage: "ic_create_0"),*/
            BottomStackItem(title: "Profile", image: "ic_profile_0", selectedImage: "ic_profile_1")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.setupTabs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.relosdMYPage(_:)), name: Notification.Name("BottomView"), object: nil)
    }
    
    func setTheView(){
        
        //SET VIEW
        self.vwBottom.viewCorneRadius(radius: 0)
        self.vwBottom.backgroundColor = .clear
//        self.vwBottom.viewBorderCorneRadius(borderColour: .primary)
    }
    @objc func relosdMYPage(_ notification: NSNotification) {
        if let data = notification.userInfo?["hide"] as? String {
            if data == "1" {
                UIView.animate(withDuration: 1.0) {
                    self.vwBottom.alpha = 0
                    self.vwBottom.isHidden = true
                }
            } else {
                UIView.animate(withDuration: 1.0) {
                    self.vwBottom.alpha = 1
                    self.vwBottom.isHidden = false
                }
            }
        }
    }

    func setupTabs() {
        for (index, model) in self.tabModels.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            self.bottomStack.addArrangedSubview(tabView)
        }
        if let first = self.tabs.first {
            self.handleTap2(first)
        }
    }
}

extension RootStackTabViewController: StackItemViewDelegate {
    
    func handleTap(_ view: StackItemView) {
        self.tabs[self.currentIndex].isSelected = false
        view.isSelected = true
        self.handleTap2(view)
    }
    
    private func handleTap2(_ view: StackItemView) {
       /* if (self.tabs.firstIndex(where: { $0 === view }) ?? 0) == 2 {
            
            self.customVM.getCustomAudioRequests(isShowLoader: true) { response in
                if response["data"].arrayValue.count == 0 {
                    self.customVM.type = "completed"
                    self.customVM.getCustomAudioRequests(isShowLoader: true) { response in
                        
                        view.isSelected = false
                        self.tabs[self.currentIndex].isSelected = true
                        if self.customVM.arrOfCustomRequests.count > 0 {
                            let vc: CustomAudioRequestVC = CustomAudioRequestVC.instantiate(appStoryboard: .CreateMusic)
                            vc.hidesBottomBarWhenPushed = true
                            vc.customVM = self.customVM
                            UIApplication.topViewController2()?.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc: CreateSectionVC = CreateSectionVC.instantiate(appStoryboard: .CreateMusic)
                            vc.hidesBottomBarWhenPushed = true
                            UIApplication.topViewController2()?.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    } failure: { errorResponse in
                        
                    }
                } else {
                    view.isSelected = false
                    self.tabs[self.currentIndex].isSelected = true
                    if self.customVM.arrOfCustomRequests.count > 0 {
                        let vc: CustomAudioRequestVC = CustomAudioRequestVC.instantiate(appStoryboard: .CreateMusic)
                        vc.hidesBottomBarWhenPushed = true
                        vc.customVM = self.customVM
                        UIApplication.topViewController2()?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc: CreateSectionVC = CreateSectionVC.instantiate(appStoryboard: .CreateMusic)
                        vc.hidesBottomBarWhenPushed = true
                        UIApplication.topViewController2()?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } failure: { errorResponse in
                
            }
            
        } else {*/
            let previousIndex = self.currentIndex
            let previousVC = self.viewControllers[previousIndex]
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
            
            self.currentIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
            let vc = viewControllers[self.currentIndex]
            self.addChild(vc)
            vc.view.frame = self.containerView.bounds
            self.containerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        
    }
}

extension UIViewController {
    
    var rootVC: RootStackTabViewController? {
        var selfVC = self
        while let parentVC = selfVC.parent {
            if let vc = parentVC as? RootStackTabViewController {
                return vc
            } else {
                selfVC = parentVC
            }
        }
        return nil
    }
}
