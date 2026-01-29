//
//  Created by Dimitrios Chatzieleftheriou on 10/06/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import Foundation

/// Helper method to dispatch the given block asynchronously on the MainQueue
func asyncOnMain(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

/// Helper method to dispatch the given block asynchronously on the MainQueue, after a given time interval
/// - note: This account for `.now()` plus the passed deadline
func asyncOnMain(deadline: DispatchTimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + deadline, execute: block)
}


// MARK: - Static Properties for De-Duping
private extension DispatchQueue {
    static var workItems = [AnyHashable : DispatchWorkItem]()
    static var weakTargets = NSPointerArray.weakObjects()
    static func dedupeIdentifierFor(_ object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())." + String(describing: object)
    }
}


extension DispatchQueue {
    
    public func asyncDeduped(target: AnyObject, after delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        let dedupeIdentifier = DispatchQueue.dedupeIdentifierFor(target)
        if let existingWorkItem = DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier) {
            existingWorkItem.cancel()
            NSLog("Deduped work item: \(dedupeIdentifier)")
        }
        let workItem = DispatchWorkItem {
            DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier)
            for ptr in DispatchQueue.weakTargets.allObjects {
                if dedupeIdentifier == DispatchQueue.dedupeIdentifierFor(ptr as AnyObject) {
                    work()
                    NSLog("Ran work item: \(dedupeIdentifier)")
                    break
                }
            }
        }
        DispatchQueue.workItems[dedupeIdentifier] = workItem
        DispatchQueue.weakTargets.addPointer(Unmanaged.passUnretained(target).toOpaque())
        asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}
