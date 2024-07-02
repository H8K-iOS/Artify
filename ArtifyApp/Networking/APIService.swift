import UIKit

enum APIServiceError: Error {
    case serverError(String)
    case decodingError(String)
    case invalidResponse
}

final class APIService {
    static let shared = APIService()
    
    func fetchImage(for prompt: String, completion: @escaping(Result<[ImageModel], APIServiceError>) -> Void) {
        guard let request = Endpoint.fetchImages(prompt: prompt).request else {
            completion(.failure(.invalidResponse))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError("Server error: \(httpResponse.statusCode)")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let imageResp = try decoder.decode(ImageResponse.self, from: data)
                completion(.success(imageResp.data))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
    //
}

