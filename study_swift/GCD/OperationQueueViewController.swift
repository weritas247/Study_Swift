//
//  OperationQueueViewController.swift
//  study_swift
//
//  Created by 이승호 on 10/10/2019.
//  Copyright © 2019 Maverick DevStudioa. All rights reserved.
//

import UIKit


let imageURLs = ["https://www.bloter.net/wp-content/uploads/2019/10/Apple_macOS-catalina-available-today_100719-765x525.jpg",
                 "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
                 "https://i.ytimg.com/vi/zFSO_CC5FG8/hqdefault.jpg?custom=true&w=168&h=94&stc=true&jpg444=true&jpgq=90&sp=67&sigh=IGQimedCDPaTY2pRullU63pBAOU",
                 "https://www.bloter.net/wp-content/uploads/2019/10/macOS-Caltalina_10.15-765x356.png"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        
        let data = NSData(contentsOf: URL(string: url)!)
        return UIImage(data: data! as Data)
    }
}

class OperationQueueViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    var queue: OperationQueue!
    
    @IBAction func test(_ sender: Any) {
        test()
    }
    
    func test() {
        
        queue = OperationQueue()
        
        let operation1 = BlockOperation(block: {
            let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
            
            OperationQueue.main.addOperation({
                print("operation1")
                self.imageView1.image = img1
            })
        })
        
        operation1.completionBlock = {
            print(" @ Operation 1 completed")
        }
        queue.addOperation(operation1)
        
        
        
        let operation2 = BlockOperation(block: {
            let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
            
            OperationQueue.main.addOperation({
                print("operation2")
                self.imageView2.image = img2
            })
        })
        
        operation2.completionBlock = {
            print(" @ Operation 2 completed")
        }
        queue.addOperation(operation2)
        
        
        
        let operation3 = BlockOperation(block: {
            let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
            
            OperationQueue.main.addOperation({
                print("operation3")
                self.imageView3.image = img3
            })
        })
        
        operation3.completionBlock = {
            print(" @ Operation 3 completed")
        }
        queue.addOperation(operation3)
        
        
        
        let operation4 = BlockOperation(block: {
            let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
            
            OperationQueue.main.addOperation({
                print("operation4")
                self.imageView4.image = img4
            })
        })
        
        operation4.completionBlock = {
            print(" @ Operation 4 completed")
        }
        queue.addOperation(operation4)
    }
}
