import UIKit

enum APIServiceError: Error {
    case serverError(String)
    case decodingError(String)
    case invalidResponse
}

final class APIService {
    static let shared = APIService()
    
    private func perfomRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping(Result<T, APIServiceError>) -> Void) {
        guard let request = endpoint.request else {
            completion(.failure(.invalidResponse))
            return
        }
        print(request.url ?? "Invalid URL")
        
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
                completion(.success(imageResp.data as! T))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
}

//MARK: - Extensions
extension APIService {
    public func fetchSquareImage(prompt: String, completion: @escaping((Result<[ImageModel], APIServiceError>)->Void)) {
        self.perfomRequest(endpoint: .fetchSquareImage(prompt: prompt), completion: completion)
    }
    
    public func fetchPortaitImage(prompt: String, completion: @escaping((Result<[ImageModel], APIServiceError>)->Void)) {
        self.perfomRequest(endpoint: .fetchPortaitImage(prompt: prompt), completion: completion)
    }
    
    public func fetchLandscapeImage(prompt: String, completion: @escaping((Result<[ImageModel], APIServiceError>)->Void)) {
        self.perfomRequest(endpoint: .fetchLandscapeImage(prompt: prompt), completion: completion)
    }
}

