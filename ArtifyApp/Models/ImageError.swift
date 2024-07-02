import Foundation

class ImageStatus: Decodable {
    let status: ImageError
}

struct ImageError: Decodable {

    let errorCode: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
    //
}

