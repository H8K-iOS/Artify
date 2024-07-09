import PhotosUI

final class PhotoLibraryManager {
    
    func saveImage(image: UIImage, completion: @escaping(Error?)->Void) {
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            request.creationDate = Date()
        } completionHandler: { _, error in
            DispatchQueue.main.async {
                if let error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
