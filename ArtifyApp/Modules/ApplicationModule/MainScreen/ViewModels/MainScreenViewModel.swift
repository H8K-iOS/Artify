import Foundation
final class MainScreenViewModel {
    private let apiService = APIService.shared
    var onUpdate: (()->Void)?
    private(set) var images: [ImageModel] = [] {
        didSet {
            self.onUpdate?()
        }
    }
    
    init() {}
    
    func fetchImage(for prompt: String) {
        apiService.fetchImage(for: prompt) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self?.images = images
                case .failure(let error):
                    print("Error fetching image: \(error)")
                    if case .serverError(let message) = error {
                        print("Server error message: \(message)")
                    }
                }
            }
        }
    }
    //
}
