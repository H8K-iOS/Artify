import Foundation
import UIKit
enum ImageOrientation {
    case square
    case portrait
    case landscape
}

final class MainScreenViewModel {
    private let apiService = APIService.shared
    private let coreDataManager = CoreDataManager.shared
    var onUpdate: (()->Void)?
    
    private(set) var images: [ImageModel] = [] {
        didSet {
            self.onUpdate?()
        }
    }
    
    var selectedStyle: String?
    
    //TODO: -
    public let styles: [StylesModel] = [
        StylesModel(styleName: "3D Cartoon", styleImage: "3D Cartoon"),
        StylesModel(styleName: "Anime", styleImage: "Anime"),
        StylesModel(styleName: "3D Anime", styleImage: "3D Anime"),
        StylesModel(styleName: "Watercolor", styleImage: "Watercolor"),
        StylesModel(styleName: "Realistic", styleImage: "Realistic"),
        StylesModel(styleName: "Cyberpunk", styleImage: "Cyberpunk"),
        StylesModel(styleName: "Fantasy", styleImage: "Fantasy"),
        StylesModel(styleName: "Playful", styleImage: "Playful"),
        StylesModel(styleName: "HDR", styleImage: "HDR"),
        StylesModel(styleName: "Pop art", styleImage: "Pop art"),
        StylesModel(styleName: "Sticker", styleImage: "Sticker"),
        StylesModel(styleName: "Stencil", styleImage: "Stencil"),
        StylesModel(styleName: "Papercraft", styleImage: "Papercraft"),
        StylesModel(styleName: "Marker illustration", styleImage: "Marker illustration"),
        StylesModel(styleName: "Risograph", styleImage: "Risograph"),
        StylesModel(styleName: "Graffiti", styleImage: "Graffiti"),
        StylesModel(styleName: "Oil painting", styleImage: "Oil painting"),
        StylesModel(styleName: "Porcelain", styleImage: "Porcelain"),
        StylesModel(styleName: "Made of light", styleImage: "Made of light"),
        StylesModel(styleName: "Candy", styleImage: "Candy"),
        StylesModel(styleName: "Bubbles", styleImage: "Bubbles"),
        StylesModel(styleName: "Crystals", styleImage: "Crystals")
    ]
    
    public let promtText = "Describe your ideas: objects, colors, places, people..."
    
    
    init() {}
    
    func makePrompt(prompt: String, style: String) -> String{
        return "\(prompt). + style: \(style)"
        
    }
    
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
    
    //TODO: -
    public let randomPrompts = [
        "A mystical island with floating lanterns",
        "A towering treehouse village in a dense forest",
        "A hidden underwater cave with ancient treasures",
        "A vibrant city with rainbow-colored buildings",
        "A snowy landscape with a castle made of ice",
        "A spaceship exploring the outer reaches of the galaxy",
        "A bustling harbor in a steampunk world",
        "A desert filled with gigantic sandworms",
        "A neon-lit alleyway in a futuristic metropolis",
        "A tranquil garden with oversized flowers and insects",
        "A hidden realm where time stands still",
        "A futuristic theme park with advanced robots",
        "A ghost town in the old west",
        "A sprawling vineyard under a golden sunset",
        "A quiet village nestled in the mountains",
        "A moonlit beach with bioluminescent waves",
        "A high-tech control room on a spaceship",
        "A mystical forest with ancient stone carvings",
        "A bustling marketplace filled with exotic goods",
        "A serene monastery on a mountain peak",
        "A magical library with floating books",
        "A futuristic city with flying cars",
        "A hidden waterfall in a lush jungle",
        "A floating island in a fantasy world",
        "A massive underwater coral reef",
        "A haunted lighthouse on a rocky cliff",
        "A snowy village with twinkling lights",
        "A bustling city center in a cyberpunk world",
        "A serene lake surrounded by weeping willows",
        "A bustling spaceport with ships from different worlds",
        "A mysterious desert with ancient ruins",
        "A tranquil meadow filled with wildflowers",
        "A bustling futuristic market with alien vendors",
        "A hidden grotto with sparkling waters",
        "A fantasy realm with a crystal castle",
        "A whimsical forest with talking trees",
        "A peaceful village during a festival",
        "A futuristic underwater research facility",
        "A mysterious cave with glowing crystals",
        "A dreamlike landscape with floating islands",
        "A surreal cityscape with gravity-defying architecture",
        "A bustling harbor in a steampunk city",
        "A snowy mountain peak with a hidden temple",
        "A futuristic skyline with hovering skyscrapers",
        "A tranquil beach with crystal-clear waters",
        "A magical forest with bioluminescent plants",
        "A mysterious island with ancient stone statues",
        "A vibrant jungle with hidden ruins",
        "A floating fortress in a fantasy world",
        "A futuristic laboratory with advanced technology",
        "A bustling city square in a cyberpunk world",
        "A tranquil river flowing through a dense forest",
        "A futuristic city with towering skyscrapers",
        "A magical forest with shimmering lights",
        "A hidden oasis in a vast desert",
        "A vibrant city with neon signs and flying cars",
        "A mysterious temple in a dense jungle",
        "A futuristic space station orbiting a distant planet",
        "A quiet village under a starry sky",
        "A bustling market in a fantasy city",
        "A serene garden with blooming flowers",
        "A futuristic city with advanced technology",
        "A hidden cave with sparkling gems",
        "A magical realm with floating islands",
        "A tranquil forest with a babbling brook",
        "A bustling city with flying vehicles",
        "A futuristic research facility in space",
        "A quiet beach with golden sands",
        "A magical library with endless shelves",
        "A bustling harbor in a fantasy world",
        "A serene village surrounded by mountains",
        "A futuristic metropolis with neon lights",
        "A mysterious forest with ancient ruins",
        "A tranquil meadow under a clear blue sky",
        "A bustling space station with alien species",
        "A hidden cave with glowing stalactites",
        "A magical forest with enchanted creatures",
        "A futuristic city with floating islands",
        "A serene lake with a hidden cave",
        "A bustling market in a steampunk world",
        "A mystical island with a hidden treasure",
        "A tranquil garden with koi ponds",
        "A futuristic laboratory with robotic assistants",
        "A hidden waterfall in a dense forest",
        "A bustling city center in a futuristic world",
        "A tranquil village by the sea",
        "A magical forest with shimmering streams",
        "A futuristic city with flying drones",
        "A serene mountain peak with a hidden shrine",
        "A bustling harbor in a cyberpunk city",
        "A hidden grotto with sparkling waters",
        "A vibrant jungle with ancient temples",
        "A floating city in a fantasy realm",
        "A futuristic metropolis with advanced technology",
        "A tranquil beach with swaying palm trees",
        "A magical library with floating lanterns",
        "A bustling marketplace in a fantasy world",
        "A serene meadow with colorful flowers",
        "A futuristic city with gravity-defying buildings",
        "A hidden cave with ancient carvings"
    ]

}
