//
//  ViewController.swift
//  ios-responder
//
//  Created by Chris on 2019/1/14.
//  Copyright © 2019 putao. All rights reserved.
//

import UIKit

class RootView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         print("touchesBegan: \(NSStringFromClass(type(of: self)))")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded: \(NSStringFromClass(type(of: self)))")
        super.touchesEnded(touches, with: event)
    }
}

class View1: RootView {
    
}

class View2: RootView {
    
}

class View3: RootView {
    
}

class View4: RootView {
    
}


class ViewController: UIViewController {

    @IBOutlet weak var view3: View3!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var nextResponder = self.view3.next
        var pre = "nextResponder--"
        while (nextResponder != nil) {
            print("\(pre)\(nextResponder!.classForCoder)")
            pre = "\(pre)--"
            nextResponder = nextResponder?.next
        }
    }
}

