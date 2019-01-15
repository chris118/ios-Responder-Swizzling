//
//  UIView+extension.swift
//  ios-responder
//
//  Created by Chris on 2019/1/15.
//  Copyright © 2019 putao. All rights reserved.
//

import UIKit

extension UIView: SelfAware {
    static func awake() {
        UIView.classInit()
    }
    
    static func classInit() {
        methodSwizzling
    }
    
    private static let methodSwizzling: Void = {
        let original_hitTestSelector = #selector(hitTest(_:with:))
        let swizzled_hitTestSelector = #selector(swizzled_hitTest(_:with:))
        swizzlingForClass(UIView.self, originalSelector: original_hitTestSelector, swizzledSelector: swizzled_hitTestSelector)
        
        let original_pointInsideSelector = #selector(point(inside:with:))
        let swizzled_pointInsideSelector = #selector(swizzled_pointInside(inside:with:))
        swizzlingForClass(UIView.self, originalSelector: original_pointInsideSelector, swizzledSelector: swizzled_pointInsideSelector)
    }()
    
    @objc func swizzled_hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("hitTest: \(NSStringFromClass(type(of: self)))")
        let result = self.swizzled_hitTest(point, with: event)
        print("\(NSStringFromClass(type(of: self))) hitTest return: \(NSStringFromClass(type(of: result ?? self)))")
        return result
    }
    
    @objc func swizzled_pointInside(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("pointInside: \(NSStringFromClass(type(of: self)))")
        let result = self.swizzled_pointInside(inside: point, with: event)
        print("\(NSStringFromClass(type(of: self))) pointInside return: \(result ? "true": "false")")
        return result
    }
    
    private static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        
        guard let _originalMethod = originalMethod, let _swizzledMethod = swizzledMethod else {
            return
        }
        
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(_originalMethod, _swizzledMethod)
        }
    }
}
