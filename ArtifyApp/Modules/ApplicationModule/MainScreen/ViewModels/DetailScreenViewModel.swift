import Foundation
import UIKit

final class DetailScreenViewModel {
    private let photoLibrary = PhotoLibraryManager()
    private let coreDataManager = CoreDataManager.shared
    
    init() {}
    
    func saveImage(image: UIImage, completion: @escaping(Error?)->Void) {
        photoLibrary.saveImage(image: image, completion: completion)
    }
    
    func saveImageWithCoreData(image: UIImage, height: Int16) {
        coreDataManager.addImage("", image: image, height: height)
    }
    
    func loadImage(imageUrl: String, completion: @escaping(UIImage?)->Void) {
        guard let url = URL(string: imageUrl) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, resp, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
