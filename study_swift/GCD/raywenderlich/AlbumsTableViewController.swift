

import UIKit
import Photos

private let reuseIdentifier = "AlbumsCell"

class AlbumsTableViewController: UITableViewController {

  var selectedAssets: SelectedAssets?
  var assetPickerDelegate: AssetPickerDelegate?
  
  private let sectionNames = ["","Albums"]
  private var userLibrary: PHFetchResult<PHAssetCollection>!
  private var userAlbums: PHFetchResult<PHCollection>!
  
  private var doneButton: UIBarButtonItem!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    if selectedAssets == nil {
      selectedAssets = SelectedAssets()
    }
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      guard let self = self else {
        return
      }
      
      DispatchQueue.main.async {
        switch status {
        case .authorized:
          self.fetchCollections()
          self.tableView.reloadData()
        default:
          self.showNoAccessAlertAndCancel()
        }
      }
    }
    doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed(_:)))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateDoneButton()
  }
  
  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination as! AssetsCollectionViewController
    // Set up AssetCollectionViewController
    destination.selectedAssets = selectedAssets
    let cell = sender as! UITableViewCell
    destination.title = cell.textLabel!.text
    destination.assetPickerDelegate = self
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    let indexPath = tableView.indexPath(for: cell)!
    switch (indexPath.section) {
    case 0:
      // Camera Roll
      let library = userLibrary[indexPath.row]
      destination.assetsFetchResults =
        PHAsset.fetchAssets(in: library,
                            options: options) as? PHFetchResult<AnyObject>
    case 1:
      // Albums
      let album = userAlbums[indexPath.row] as! PHAssetCollection
      destination.assetsFetchResults =
        PHAsset.fetchAssets(in: album,
                            options: options) as? PHFetchResult<AnyObject>
    default:
      break
    }
  }

  @IBAction func cancelPressed(_ sender: Any) {
    assetPickerDelegate?.assetPickerDidCancel()
  }
  
  @IBAction func donePressed(_ sender: Any) {
    // Should only be invoked when there are selected assets
    if let assets = selectedAssets?.assets {
      assetPickerDelegate?.assetPickerDidFinishPickingAssets(assets)
      // Clear out selections
      selectedAssets?.assets.removeAll()
    }
  }
  
}

// MARK: - Private Methods

extension AlbumsTableViewController {
  func fetchCollections() {
    userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    userLibrary = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumUserLibrary,
      options: nil)
  }
  
  func showNoAccessAlertAndCancel() {
    let alert = UIAlertController(title: "No Photo Permissions", message: "Please grant photo permissions in Settings", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
      return
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  private func updateDoneButton() {
    guard let selectedAssets = selectedAssets else { return }
    // Add a done button when there are selected assets
    if selectedAssets.assets.count > 0 {
      navigationItem.rightBarButtonItem = doneButton
    } else {
      navigationItem.rightBarButtonItem = nil
    }
  }
}

// MARK: - Table view data source

extension AlbumsTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionNames.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch (section) {
    case 0:
      return userLibrary?.count ?? 0
    case 1:
      return userAlbums?.count ?? 0
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    cell.textLabel!.text = ""
    
    switch(indexPath.section) {
    case 0:
      let library = userLibrary[indexPath.row]
      var title = library.localizedTitle!
      if (library.estimatedAssetCount != NSNotFound) {
        title += " (\(library.estimatedAssetCount))"
      }
      cell.textLabel!.text = title
    case 1:
      let album = userAlbums[indexPath.row] as! PHAssetCollection
      var title = album.localizedTitle!
      if (album.estimatedAssetCount != NSNotFound) {
        title += " (\(album.estimatedAssetCount))"
      }
      cell.textLabel!.text = title
    default:
      break
    }
    
    cell.accessoryType = .disclosureIndicator
    
    return cell
  }

}

// MARK: - AssetPickerDelegate

extension AlbumsTableViewController: AssetPickerDelegate {
  func assetPickerDidCancel() {
    assetPickerDelegate?.assetPickerDidCancel()
  }
  
  func assetPickerDidFinishPickingAssets(_ selectedAssets: [PHAsset])  {
    assetPickerDelegate?.assetPickerDidFinishPickingAssets(selectedAssets)
    // Clear out selections
    self.selectedAssets?.assets.removeAll()
  }
}
