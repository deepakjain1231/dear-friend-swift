//
//  APICallHelper.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 19/12/25.
//

import Foundation

final class LogoutService {

    static let shared = LogoutService()

    private init() {}

    private var timer: Timer?
    private let interval: TimeInterval = 30

    // MARK: - Start Polling
    func start() {
        stop()
        timer = Timer.scheduledTimer( timeInterval: interval, target: self, selector: #selector(callAPI), userInfo: nil, repeats: true)

        timer?.fire()
    }

    // MARK: - Stop Polling
    func stop() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - API Call
    @objc private func callAPI() {
        print("API Call every 30 sec")
        self.callAPIforCheckAnotherDeviceLogin()
    }
    
    func callAPIforCheckAnotherDeviceLogin() {
        if (CurrentUser.shared.user?.internalIdentifier) == nil || (CurrentUser.shared.user?.internalIdentifier) == 0 {
        }
        else {
            DispatchQueue.main.asyncDeduped(target: self, after: 0.75) { [weak self] in
                guard let self = self else { return }
                CurrentUser.shared.checkAnotherDeviceLoginService(success: { json_response in
                    print(json_response)
                }, failure: { errorr in
                    print(errorr)
                })
            }
        }
    }
}
