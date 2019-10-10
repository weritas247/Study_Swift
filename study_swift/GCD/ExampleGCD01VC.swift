//
//  ExampleGCD01VC.swift
//  study_swift
//
//  Created by MyMacBookPro on 06/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//
// ref. https://brunch.co.kr/@tilltue/29

import UIKit

class ExampleGCD01VC: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func gcdStart(_ sender: Any) {
        gcd1()
    }
    
    func gcd1() {
        let group = DispatchGroup()
        
        let queue1 = DispatchQueue(label: "task1")
        let queue2 = DispatchQueue(label: "task2")
        let queue3 = DispatchQueue(label: "task3")
        
        queue1.async(group: group) {
            //            sleep(1)
            print("task1-1")
        }
        queue1.async(group: group) {
            //            sleep(1)
            print("task1-2")
        }
        queue1.async(group: group) {
            //            sleep(1)
            print("task1-3")
        }
        
        queue2.async(group: group) {
            //            sleep(1)
            print("task2")
        }
        
        queue3.async(group: group) {
            //            sleep(1)
            print("task3")
        }
        
        group.notify(queue: queue1, execute: {
            
        })
        
        //        group.notify(queue: DispatchQueue.main) {
        //            print("======================== group notify ========================")
        //        }
        
        // 지정한 시간 후 실행
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            queue1.async(group: group) {
                print("task deadline 1-1")
            }
            queue1.async(group: group) {
                print("task deadline 1-2")
            }
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        //            print("DispatchQueue.main.asyncAfter + 2.0")
        //        }
    }
    
    func gcd2() {
    }
 

}
