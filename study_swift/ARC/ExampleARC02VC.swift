//
//  ArcExample02VC.swift
//  study_swift
//
//  Created by MyMacBookPro on 05/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import UIKit

class ExampleARC02VC: UIViewController {
    
    
    class Person {
        let name: String
        var apartment: Apartment?
        
        init(name: String) {
            self.name = name
            print("\(name) is being initialized")
        }
        deinit { print("\(name) is being deinitialized") }
    }
    
    class Apartment {
        let unit: String
        var tenant: Person?
        
        init(unit: String) {
            self.unit = unit
            print("Apartment \(unit) is being initialized")
        }
        deinit { print("Apartment \(unit) is being deinitialized") }
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("func viewDidLoad()")

        var john: Person? = Person(name: "John Appleseed")
        var unit4A: Apartment? = Apartment(unit: "4A")
        
        john!.apartment = unit4A
        unit4A!.tenant = john
        // 두 인스턴스의 프로퍼티 변수 간에 강한 상호 참조 발생 (Strong Reference Cycle)
        
        john = nil
        unit4A = nil
        // 메모리 사이클 발생시 프로퍼티 간 상호 참조 때문에 두 인스턴스 모두를 nil로 해도 deallocation 되지 않음
        // deinit 호출되지 않음
    }

    override func loadView() {
        super.loadView()
        
        print("func loadView()")
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
