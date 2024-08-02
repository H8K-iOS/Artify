import Foundation
import UIKit

final class HistoryScreenViewModel {
    
    private(set) var images: [Image?] = [] {
        didSet {
            if !isFetching {
                onUpdate?()
            }
            
        }
    }
    
    var test: [Int] = []
    
    private var isFetching = false
    public var onUpdate: (()->Void)?
    
    init() {
        fetchCreations()
    }
    public func creationsCount() -> Int {
        self.images.count
    }
    
    public func fetchCreations() {
        guard !isFetching else { return }
        self.isFetching = true
        
        CoreDataManager.shared.fetchImages { [weak self] images in
            DispatchQueue.main.async {
                print("Fetched \(images.count) images")
                self?.images = images
                self?.isFetching = false
            }
        }
    }
}
