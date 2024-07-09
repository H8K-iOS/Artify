import Foundation
import UIKit

final class HistoryScreenViewModel {
    
    private(set) var images: [Image?] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    public var onUpdate: (()->Void)?
    
    init() {
        fetchCreations()
    }
    public func creationsCount() -> Int {
        self.images.count
    }
    
    public func fetchCreations() {
        CoreDataManager.shared.fetchImages { [weak self] images in
            self?.images = images
        }
    
    }
}
