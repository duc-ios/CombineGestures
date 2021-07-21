//
//  NSObject+Cancellables.swift
//
//  Created by Duc on 22/7/2021.
//

import Foundation
import Combine

public extension NSObject {
    private struct AssociatedKeys {
        static var cancellables = "cancellables"
    }
    
    var cancellables: [AnyCancellable] {
        get {
            if let cancellables = objc_getAssociatedObject(self, &AssociatedKeys.cancellables) as? [AnyCancellable] {
                return cancellables
            } else {
                let cancellables = [AnyCancellable]()
                objc_setAssociatedObject(self, &AssociatedKeys.cancellables, cancellables, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellables
            }
        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.cancellables, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
