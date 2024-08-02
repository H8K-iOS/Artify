import Foundation
import UIKit

final class DetailScreenViewModel {
    private let photoLibrary = PhotoLibraryManager()
    private let coreDataManager = CoreDataManager.shared
    
    init() {}
    
    func saveImage(image: UIImage, completion: @escaping(Error?)->Void) {
        photoLibrary.saveImage(image: image, completion: completion)
    }
    
    func saveImageWithCoreData(prompt: String, image: UIImage, ratio: String?, style: String?, height: Int16) {
        coreDataManager.addImage(prompt: prompt, image: image, style: style, ratio: ratio, height: height)
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
