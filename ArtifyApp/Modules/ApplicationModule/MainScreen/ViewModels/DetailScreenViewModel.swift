import Foundation
import UIKit

final class DetailScreenViewModel {
    
    init() {}
    
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
