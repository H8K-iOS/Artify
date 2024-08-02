import Foundation

enum Endpoint {
    case fetchSquareImage(prompt: String)
    case fetchPortaitImage(prompt: String)
    case fetchLandscapeImage(prompt: String)
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        request.addValues(for: self)
        return request
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseUrl
        components.port = Constants.port
        components.path = self.path
        return components.url
    }
    
    private var path: String {
        switch self {
        case .fetchSquareImage:
            return Constants.path
        case .fetchPortaitImage:
            return Constants.path
        case .fetchLandscapeImage:
            return Constants.path
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .fetchSquareImage:
            return HTTP.Methods.post.rawValue
        case .fetchPortaitImage:
            return HTTP.Methods.post.rawValue
        case .fetchLandscapeImage:
            return HTTP.Methods.post.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .fetchSquareImage(prompt: let prompt):
            HTTP.Body.generateBody(for: self, prompt: prompt)
        case .fetchPortaitImage(prompt: let prompt):
            HTTP.Body.generateBody(for: self, prompt: prompt)
        case .fetchLandscapeImage(prompt: let prompt):
            HTTP.Body.generateBody(for: self, prompt: prompt)
        }
    }
}



extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        self.addValue(HTTP.Headers.Values.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.contentType.rawValue)
        
        
        if let apiKey = KeychainManager.shared.getApiKey() {
            self.addValue("\(HTTP.Headers.Values.bearer.rawValue) \(apiKey)", forHTTPHeaderField: HTTP.Headers.apiKey.rawValue)
        }
    }
}
