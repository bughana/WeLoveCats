
import Foundation

struct ApiRequestResult {
    let imageUrls: [URL]?
    let error: Error?
}

enum ApiRequest {
    static let baseURLPath = "http://thecatapi.com/api/images"
    
    case getCatImages
    
    internal var urlRequest: URLRequest? {
        let result: (path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .getCatImages:
                return ("/get?format=xml&results_per_page=20", nil)
            }
        }()
        
        guard let url = URL(string: "\(ApiRequest.baseURLPath)\(result.path)") else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        if let parameters = result.parameters {
            urlRequest.httpBody = tokenizeParameters(parameters)
        }
        
        return urlRequest
    }
    
    private func tokenizeParameters(_ params: [String : AnyObject]) -> Data {
        if let string = jsonify(params) {
            if let data = string.data(using: String.Encoding.utf8) {
                return data
            }
        }
        return Data()
    }
    
    private func jsonify(_ dict: Dictionary<String, AnyObject>) -> String? {
        var data: Data? = nil
        do {
            data = try JSONSerialization.data(withJSONObject: dict,
                                              options: JSONSerialization.WritingOptions(rawValue: 0))
        } catch {
            return nil
        }
        
        guard let sData = data else { return nil }
        return String(data: sData, encoding: String.Encoding.utf8)
    }
}
