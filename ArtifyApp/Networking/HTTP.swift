import Foundation
enum HTTP {
    
    enum Methods: String {
        case post = "POST"
        case get = "GET"
    }
    
    enum Headers: String {
        case contentType = "Content-Type"
        case apiKey = "Authorization"
        
        enum Values: String {
            case applicationJson = "application/json"
            case bearer = "Bearer"
        }
    }
    
    enum Body {
        static func generateBody(for endpoint: Endpoint, prompt: String) -> Data? {
               switch endpoint {
               case .fetchSquareImage:
                   let body: [String: Any] = [
                       "model": "dall-e-3",
                       "prompt": prompt,
                       "n": 1,
                       "size": "1024x1024"
                   ]
                   return try? JSONSerialization.data(withJSONObject: body, options: [])
                   
               case .fetchPortaitImage:
                   let body: [String: Any] = [
                       "model": "dall-e-3",
                       "prompt": prompt,
                       "n": 1,
                       "size": "1024x1792"
                   ]
                   return try? JSONSerialization.data(withJSONObject: body, options: [])
                   
               case .fetchLandscapeImage:
                   let body: [String: Any] = [
                       "model": "dall-e-3",
                       "prompt": prompt,
                       "n": 1,
                       "size": "1792x1024"
                   ]
                   return try? JSONSerialization.data(withJSONObject: body, options: [])

               }
           }
    }
   
}
