//
//  ThreadTest01ViewController.swift
//  study_swift
//
//  Created by 이승호 on 10/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//
// VeaSoftware
// ref. https://www.youtube.com/watch?v=-xnt70_gMqQ

import UIKit

class ThreadTest01ViewController: UIViewController {

    let imageUrl = URL(string: "https://cdn.apartmenttherapy.info/image/upload/f_auto,q_auto:eco,c_fill,g_auto,w_848,h_848/at%2Farchive%2F7a8036a737efb36f0d28c1c342a972b894577f22") // 고용량 이미지
    //    let imageUrl = URL(string: "https://i.stack.imgur.com/LqXFE.png") // 저용량 이미지
    //    let imageUrl = URL(string: "http://img.naver.net/static/www/mobile/edit/2017/0313/mobile_113541740646.png") // 저용량 이미지(네이버)
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    
    @IBOutlet var mainThreadTimeLabel: UILabel!
    @IBOutlet var backgroundThreadTimeLabel: UILabel!
    
    @IBAction func mainThreadImageDownload(_ sender: Any) {
        mainThread()
    }
    
    @IBAction func backgroundThreadAllImageDownload(_ sender: Any) {
        backgroundThread()
    }
    
    @IBAction func main_background(_ sender: Any) {
        mainThread()
        backgroundThread()
    }
    
    @IBAction func background_main(_ sender: Any) {
        mainThread()
        backgroundThread()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
    }
    
    func mainThread() {
        let methodStart = Date()
        
        do {
            let data = try Data(contentsOf: imageUrl!)
            self.imageView1.image = UIImage(data: data)
        } catch  {
            print("error")
        }
        
        let executionTime = Date().timeIntervalSince(methodStart)
        self.mainThreadTimeLabel.text = "Execution Time :\(executionTime)"
        print("🔆 mainThread() - ExecutionTime: \(executionTime)")
    }
    
    func backgroundThread() {
        DispatchQueue.global(qos: .background).async {
            let methodStart = Date()
            
            do {
                let data = try Data(contentsOf: self.imageUrl!)
                
                DispatchQueue.main.async {
                    self.imageView2.image = UIImage(data: data)
                    
                    let executionTime = Date().timeIntervalSince(methodStart)
                    self.backgroundThreadTimeLabel.text = "Execution Time :\(executionTime)"
                    print("🔆 backgroundThread() - ExecutionTime: \(executionTime)")
                }
                
            } catch  {
                print("error")
            }
        }
    }
}
