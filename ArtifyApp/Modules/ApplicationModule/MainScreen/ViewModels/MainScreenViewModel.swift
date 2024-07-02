import Foundation
final class MainScreenViewModel {
    private let apiService = APIService.shared
    var onUpdate: (()->Void)?
    private(set) var images: [ImageModel] = [] {
        didSet {
            self.onUpdate?()
        }
    }
    
    let randomPromts = [
        "A surreal landscape with flying elephants",
        "A futuristic cityscape at night",
        "An underwater world with glowing jellyfish",
        "A steampunk-themed carnival",
        "A magical forest with glowing mushrooms",
        "A cyberpunk street with neon signs",
        "A space station orbiting a distant planet",
        "An ancient temple hidden in a jungle",
        "A whimsical garden with talking animals",
        "A time-traveling pirate ship",
        "A desert oasis with a mirage of a castle",
        "A floating city in the clouds",
        "A haunted mansion on a stormy night",
        "A post-apocalyptic wasteland with ruins",
        "A parallel universe where gravity is reversed",
        "A fantastical underwater city of mermaids",
        "A galaxy made of colorful candies",
        "A medieval castle guarded by dragons",
        "An enchanted ice cave with glowing crystals",
        "A bustling marketplace on an alien planet",
        "A volcanic island with mythical creatures",
        "A futuristic laboratory conducting experiments",
        "A hidden cave with ancient hieroglyphs",
        "A cosmic ballet of stars and planets",
        "A robotic jungle inhabited by mechanical animals",
        "A journey through a labyrinth of illusions",
        "A celestial phenomenon with swirling galaxies",
        "A dreamlike carnival of illusions",
        "An interstellar journey through a wormhole",
        "A time loop where past and future collide"
    ]
    let promtText = "Describe your ideas: objects, colors, places, people..."
    
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
