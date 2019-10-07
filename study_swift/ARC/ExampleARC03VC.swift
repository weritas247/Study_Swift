//
//  ArcExample03VC.swift
//  study_swift
//
//  Created by MyMacBookPro on 05/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import UIKit

class ExampleARC03VC: UIViewController {
    
    class Customer {
        let name: String
        var card: CreditCard?
        
        init(name: String) {
            self.name = name
        }
        deinit { print("\(name) is being deinitialized") }
    }
    
    class CreditCard {
        let number: UInt64
        unowned let customer: Customer
        
        init(number: UInt64, customer: Customer) {
            self.number = number
            self.customer = customer
        }
        deinit { print("Card #\(number) is being deinitialized") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var john: Customer? = Customer(name: "John Appleseed")
        john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
        john = nil
        // Prints "John Appleseed is being deinitialized"
        // Prints "Card #1234567890123456 is being deinitialized"
    }
    

   

}
