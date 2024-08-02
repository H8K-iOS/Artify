import Foundation

final class HistoryDetailScreenViewModel {
    
    private(set) var image: Image
    
    init(_ image: Image) {
        self.image = image
    }
    
    var imageData: Data {
        guard let data = self.image.image else { return Data() }
        return data
    }
    
    var height: Int {
        Int(self.image.height)
    }
    
    var style: String? {
        self.image.style
    }
    
    var ratio: String? {
        self.image.ratio
    }
}
