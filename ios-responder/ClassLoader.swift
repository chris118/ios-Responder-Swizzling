//
//  ClassLoader.swift
//  ios-responder
//
//  Created by Chris on 2019/1/15.
//  Copyright © 2019 putao. All rights reserved.
//

import UIKit

//iOS响应者链 参考 https://www.dandj.top/2018/07/06/iOS%E5%93%8D%E5%BA%94%E8%80%85%E9%93%BE%E5%BD%BB%E5%BA%95%E6%8E%8C%E6%8F%A1/

protocol SelfAware: class {
    static func awake()
}

class ClassLoader {
    // objective-c 参考 https://www.jianshu.com/p/bf6c81fc2434
    static func loadClasses() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate()
    }
}
/*
 extension AppDelegate {
 private static let singleInstance: Void = {
 ClassLoader.loadClasses()
 }()
 
 override var next: UIResponder? {
 AppDelegate.singleInstance
 return super.next
 }
 }
 */
