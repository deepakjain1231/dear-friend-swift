//
//  TabbarVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 02/05/23.
//

import UIKit

class TabbarVC: UITabBarController {

    var currentIndex = 0

    let bgView2: UIImageView = UIImageView(image: UIImage(named: "ic_tab_1"))
    
    // MARK: Instance Method
    class func instance() -> UIViewController {
        let vc = TabbarVC.instantiate(appStoryboard: .Tabbar)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func relosdMYPage(_ notification: NSNotification) {
        if let data = notification.userInfo?["hide"] as? String {
            if data == "1" {
                UIView.animate(withDuration: 0.1) {
                    self.bgView2.alpha = 0
                }
            } else {
                UIView.animate(withDuration: 1.5) {
                    self.bgView2.alpha = 1
                }
            }
        }
    }
    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        let rect = CGRect(x:0, y: 0, width: size.width, height: size.height)
        let rectLine = CGRect(x:0, y:size.height-lineSize.height,width: lineSize.width,height: lineSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func frameForTab(atIndex index: Int) -> CGRect {
        var frames = view.subviews.compactMap { (view:UIView) -> CGRect? in
            if let view = view as? UIControl {
                return view.frame
            }
            return nil
        }
        frames.sort { $0.origin.x < $1.origin.x }
        if frames.count > index {
            return frames[index]
        }
        return frames.last ?? CGRect.zero
    }
}

extension TabbarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.currentIndex = tabBarController.selectedIndex
                
        let tabViewControllers = tabBarController.viewControllers!
        guard let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }
      
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.currentIndex != self.selectedIndex {
            GeneralUtility().addButtonTapHaptic()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Tag", item.tag)
        if item.tag == 0 {
            self.bgView2.image = UIImage(named: "ic_tab_1")
            
        } else if item.tag == 1 {
            self.bgView2.image = UIImage(named: "ic_tab_2")
            
        } else if item.tag == 2 {
            self.bgView2.image = UIImage(named: "ic_tab_3")
        }
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let timeInterval: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.1) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}

class CustomTabBar: UITabBar {
    
    let tabbarHeight: CGFloat = 105
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if self.tabbarHeight > 0.0 {
            if !UIDevice().hasNotch {
                sizeThatFits.height = 90
            } else {
                sizeThatFits.height = tabbarHeight
            }
        }
        return sizeThatFits
    }
}

extension CGPoint {
    static var Center: CGPoint {
        return CGPoint(x: UIScreen.main.bounds.maxX/2, y: UIScreen.main.bounds.maxY/2)
    }
}
