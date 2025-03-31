//
//  NotificationViewController.swift
//  NotificationViewController
//
//  Created by Jigar Khatri on 12/03/25.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

   
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        
        if let urlImageString = content.userInfo["image"] as? String {
            setImage(urlImageString: urlImageString)
        }
        else if let fcmOptions = content.userInfo["fcm_options"] as? NSDictionary {
            if let urlImageString = fcmOptions["image"] as? String {
                setImage(urlImageString: urlImageString)
            }
        }
    }
    
    func setImage(urlImageString : String){
        if let url = URL(string: urlImageString) {
            URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                if let _ = error {
                    return
                }
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}


extension URLSession {
    
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}
