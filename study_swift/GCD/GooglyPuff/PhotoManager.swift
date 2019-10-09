

import UIKit

struct PhotoManagerNotification {
    // Notification when new photo instances are added
    static let contentAdded = Notification.Name("com.raywenderlich.GooglyPuff.PhotoManagerContentAdded")
    // Notification when content updates (i.e. Download finishes)
    static let contentUpdated = Notification.Name("com.raywenderlich.GooglyPuff.PhotoManagerContentUpdated")
}

struct PhotoURLString {
    // Photo Credit: Devin Begley, http://www.devinbegley.com/
    static let overlyAttachedGirlfriend = "https://pbs.twimg.com/profile_images/790925276087656448/JbK17g3S_400x400.jpg"
    static let successKid = "https://pbs.twimg.com/profile_images/631836592366186497/8ZuPCZyc_400x400.jpg"
    static let lotsOfFaces = "https://static.independent.co.uk/s3fs-public/thumbnails/image/2019/05/14/14/Real-Madrid.jpg?width=1000&height=614&fit=bounds&format=pjpg&auto=webp&quality=70&crop=16:9,offset-y0.5"
}

typealias PhotoProcessingProgressClosure = (_ completionPercentage: CGFloat) -> Void
typealias BatchPhotoDownloadingCompletionClosure = (_ error: NSError?) -> Void

final class PhotoManager {
    private init() {}
    static let shared = PhotoManager()
    
    private let concurrentPhotoQueue = DispatchQueue(label:  "com.raywenderlich.GooglyPuff.photoQueue",
                                                     attributes: DispatchQueue.Attributes.concurrent )
    private var unsafePhotos: [Photo] = []
    
    var photos: [Photo] {
        var photosCopy: [Photo]!
        
        concurrentPhotoQueue.sync {
            photosCopy = self.unsafePhotos
        }
        
        return unsafePhotos
    }
    
    func addPhoto(_ photo: Photo) {
        
        concurrentPhotoQueue.async(flags: DispatchWorkItemFlags.barrier) { [weak self] in
            guard let self = self else { return }
            
            self.unsafePhotos.append(photo)
            
            DispatchQueue.main.async { [weak self] in
                self?.postContentAddedNotification()
            }
        }
    }
    
    // Canceling Dispatch Blocks
    func downloadPhotos(withCompletion completion: BatchPhotoDownloadingCompletionClosure?) {
        
        var storedError: NSError?
        let downloadGroup = DispatchGroup()
        var addresses = [PhotoURLString.overlyAttachedGirlfriend,
                         PhotoURLString.successKid,
                         PhotoURLString.lotsOfFaces]
        addresses += addresses + addresses
        
        var blocks: [DispatchWorkItem] = []
        
        for index in 0..<addresses.count {
            downloadGroup.enter()
            
            let block = DispatchWorkItem(flags: DispatchWorkItemFlags.inheritQoS) {
                let address = addresses[index]
                let url = URL(string: address)
                let photo = DownloadPhoto(url: url!) { _, error in
                    if error != nil {
                        storedError = error
                    }
                    downloadGroup.leave()
                }
                PhotoManager.shared.addPhoto(photo)
            }
            blocks.append(block)
            DispatchQueue.main.async(execute: block)
        }
        
        for block in blocks[3..<blocks.count] {
            
            let cancel = Bool.random()
            if cancel {
                block.cancel()
                downloadGroup.leave()
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion?(storedError)
        }
    }
    
//    // for Loop를 DispatchQueue.concurrentPerform로 대체
//    func downloadPhotos(withCompletion completion: BatchPhotoDownloadingCompletionClosure?) {
//
//        var storedError: NSError?
//        let downloadGroup = DispatchGroup()
//        let addresses = [PhotoURLString.overlyAttachedGirlfriend,
//                        PhotoURLString.successKid,
//                        PhotoURLString.lotsOfFaces]
//        let _ = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
//        DispatchQueue.concurrentPerform(iterations: addresses.count) { (index) in
//            let address = addresses[index]
//            let url = URL(string: address)
//            downloadGroup.enter()
//            let photo = DownloadPhoto(url: url!) { _, error in
//                if error != nil {
//                    storedError = error
//                }
//                downloadGroup.leave()
//            }
//            PhotoManager.shared.addPhoto(photo)
//        }
//        downloadGroup.notify(queue: DispatchQueue.main) {
//            completion?(storedError)
//        }
//    }
    
    // downloadGroup.notify 이용
//    func downloadPhotos(withCompletion completion: BatchPhotoDownloadingCompletionClosure?) {
//
//        var storedError: NSError?
//        let downloadGroup = DispatchGroup()
//
//        for address in [PhotoURLString.overlyAttachedGirlfriend,
//                        PhotoURLString.successKid,
//                        PhotoURLString.lotsOfFaces] {
//                            let url = URL(string: address)
//
//                            downloadGroup.enter()
//                            let photo = DownloadPhoto(url: url!) { _, error in
//                                if error != nil {
//                                    storedError = error
//                                }
//
//                                downloadGroup.leave()
//                            }
//                            PhotoManager.shared.addPhoto(photo)
//        }
//
//        downloadGroup.notify(queue: DispatchQueue.main) {
//            completion?(storedError)
//        }
//    }
    
    // a clumsy way
//    func downloadPhotos(withCompletion completion: BatchPhotoDownloadingCompletionClosure?) {
//
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
//            var storedError: NSError?
//            let downloadGroup = DispatchGroup()
//
//            for address in [PhotoURLString.overlyAttachedGirlfriend,
//                            PhotoURLString.successKid,
//                            PhotoURLString.lotsOfFaces] {
//                                let url = URL(string: address)
//
//                                downloadGroup.enter()
//                                let photo = DownloadPhoto(url: url!) { _, error in
//                                    if error != nil {
//                                        storedError = error
//                                    }
//
//                                    downloadGroup.leave()
//                                }
//                                PhotoManager.shared.addPhoto(photo)
//            }
//
//            downloadGroup.wait()
//
//            DispatchQueue.main.async {
//                completion?(storedError)
//            }
//        }
//    }
    
    // Old
//    func downloadPhotos(withCompletion completion: BatchPhotoDownloadingCompletionClosure?) {
//        var storedError: NSError?
//        for address in [PhotoURLString.overlyAttachedGirlfriend,
//                        PhotoURLString.successKid,
//                        PhotoURLString.lotsOfFaces] {
//                            let url = URL(string: address)
//                            let photo = DownloadPhoto(url: url!) { _, error in
//                                if error != nil {
//                                    storedError = error
//                                }
//                            }
//                            PhotoManager.shared.addPhoto(photo)
//        }
//
//        completion?(storedError)
//    }
    
    private func postContentAddedNotification() {
        NotificationCenter.default.post(name: PhotoManagerNotification.contentAdded, object: nil)
    }
}


