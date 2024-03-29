
// https://www.raywenderlich.com/5370-grand-central-dispatch-tutorial-for-swift-4-part-1-2

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let backgroundImageOpacity: CGFloat = 0.1

// 1 - You compile this code only in DEBUG mode to prevent "interested parties" from gaining a lot of insight into your app. :] DEBUG is defined by adding -D DEBUG under Project Settings -> Build Settings -> Swift Compiler - Custom Flags -> Other Swift Flags -> Debug. It should be set already in the starter project.
#if DEBUG

// 2 - You declare a signal variable of type DispatchSourceSignal for use in monitoring Unix signals.
var signal: DispatchSourceSignal?

// 3 - You create a block assigned to the setupSignalHandlerFor global variable that you'll use for one-time setup of your dispatch source.
private let setupSignalHandlerFor = { (_ object: AnyObject) in
    let queue = DispatchQueue.main
    
    // 4 - Here you set up signal. You indicate that you're interested in monitoring the SIGSTOP Unix signal and handling received events on the main queue — you'll discover why shortly.
    signal = DispatchSource.makeSignalSource(signal: SIGSTOP, queue: queue)
    
    // 5 - If the dispatch source is successfully created, you register an event handler closure that's invoked whenever you receive the SIGSTOP signal. Your handler prints a message that includes the class description.
    signal?.setEventHandler{
        print("Hi, I am: \(object.description!)")
    }
    
    // 6 - All sources start off in the suspended state by default. Here you tell the dispatch source to resume so it can start monitoring events.
    signal?.resume()
}
#endif

final class PhotoCollectionViewController: UICollectionViewController {
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    #if DEBUG
    setupSignalHandlerFor(self)
    #endif
    
    let backgroundImageView = UIImageView(image: UIImage(named:"background"))
    backgroundImageView.alpha = backgroundImageOpacity
    backgroundImageView.contentMode = .center
    collectionView?.backgroundView = backgroundImageView
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(contentChangedNotification(_:)),
      name: PhotoManagerNotification.contentUpdated,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(contentChangedNotification(_:)),
      name: PhotoManagerNotification.contentAdded,
      object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showOrHideNavPrompt()
  }
  
  // MARK: - IBAction Methods
  @IBAction private func addPhotoAssets(_ sender: Any) {
    let alert = UIAlertController(title: "Get Photos From:", message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    
    let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsStoryboard") as? UINavigationController
      if let viewController = viewController,
        let albumsTableViewController = viewController.topViewController as? AlbumsTableViewController {
        albumsTableViewController.assetPickerDelegate = self
        self.present(viewController, animated: true, completion: nil)
      }
    }
    alert.addAction(libraryAction)
    
    let internetAction = UIAlertAction(title: "Le Internet", style: .default) { _ in
      self.downloadImageAssets()
    }
    alert.addAction(internetAction)
    
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - Private Methods
private extension PhotoCollectionViewController {
  func showOrHideNavPrompt() {
   let delayInsSeconds = 2.0
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInsSeconds) { [weak self] in
        guard let self = self else {
            return
        }
        
        if PhotoManager.shared.photos.count > 0 {
            self.navigationItem.prompt = nil
        } else {
            self.navigationItem.prompt = "Add photos with faces to Googlyify them!"
        }
        
        self.navigationController?.viewIfLoaded?.setNeedsLayout()
    }
  }
  
  func downloadImageAssets() {
    PhotoManager.shared.downloadPhotos() { [weak self] error in
      let message = error?.localizedDescription ?? "The images have finished downloading"
      let alert = UIAlertController(title: "Download Complete", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - Notification handlers
extension PhotoCollectionViewController {
  @objc func contentChangedNotification(_ notification: Notification!) {
    collectionView?.reloadData()
    showOrHideNavPrompt()
  }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return PhotoManager.shared.photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
    
    let photoAssets = PhotoManager.shared.photos
    let photo = photoAssets[indexPath.row]
    
    switch photo.statusThumbnail {
    case .goodToGo:
      cell.thumbnailImage = photo.thumbnail
    case .downloading:
      cell.thumbnailImage = UIImage(named: "photoDownloading")
    case .failed:
      cell.thumbnailImage = UIImage(named: "photoDownloadError")
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let photos = PhotoManager.shared.photos
    let photo = photos[indexPath.row]
    
    switch photo.statusImage {
    case .goodToGo:
      let viewController = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailStoryboard") as? PhotoDetailViewController
      if let viewController = viewController {
        viewController.image = photo.image
        navigationController?.pushViewController(viewController, animated: true)
      }
      
    case .downloading:
      let alert = UIAlertController(title: "Downloading",
                                    message: "The image is currently downloading",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
      
    case .failed:
      let alert = UIAlertController(title: "Image Failed",
                                    message: "The image failed to be created",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - AssetPickerDelegate

extension PhotoCollectionViewController: AssetPickerDelegate {
  func assetPickerDidCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  func assetPickerDidFinishPickingAssets(_ selectedAssets: [PHAsset])  {
    for asset in selectedAssets {
      let photo = AssetPhoto(asset: asset)
      PhotoManager.shared.addPhoto(photo)
    }
    
    dismiss(animated: true, completion: nil)
  }
}
