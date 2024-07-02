import Foundation

enum Endpoint {
    case fetchImages(prompt: String)
    
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
        case .fetchImages:
            return "/v1/images/generations"
            //        return ""
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .fetchImages:
            return HTTP.Methods.post.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .fetchImages(let prompt):
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
    //
}
