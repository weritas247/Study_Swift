//
//  ViewController.swift
//  study_swift
//
//  Created by MyMacBookPro on 05/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import UIKit

class ArcExample01VC: UIViewController {

    
    var r1: Person?
    var r2: Person?
    var r3: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        r1 = Person(name: "John Appleseed")
        r2 = r1
        r3 = r1
        
        print(CFGetRetainCount(r1))
        r1 = nil

        print(CFGetRetainCount(r2))
        r2 = nil
        
        print(CFGetRetainCount(r3))
        r3 = nil
    }


}

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initilized")
    }
    
    deinit {
        print("\(name) is being deinitilized")
    }
}
