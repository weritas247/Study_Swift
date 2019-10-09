

import Foundation
import Photos

protocol AssetPickerDelegate {
  func assetPickerDidFinishPickingAssets(_ selectedAssets: [PHAsset])
  func assetPickerDidCancel()
}
