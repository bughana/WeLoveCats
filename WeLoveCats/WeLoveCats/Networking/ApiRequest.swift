
import Foundation

struct ApiRequestResult {
    let catImages: [CatImage]?
    let error: Error?
}

enum ApiRequest {
    static let baseURLPath = "http://thecatapi.com/api/images"
    static let apiKey = "MjQ2MTkz"
    
    case getCatImages
    case getFavourites
    case likeImage(imageId: String)
    case unlikeImage(imageId: String)
    
    internal var urlRequest: URLRequest? {
        let result: (path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .getCatImages:
                return ("/get?api_key=\(ApiRequest.apiKey)&format=xml&results_per_page=20", nil)
            case .getFavourites:
                return ("/getfavourites?api_key=\(ApiRequest.apiKey)", nil)
            case .likeImage(let id):
                return ("/favourite?api_key=\(ApiRequest.apiKey)&image_id=\(id)&action=add", nil)
            case .unlikeImage(let id):
                return ("/favourite?api_key=\(ApiRequest.apiKey)&image_id=\(id)&action=remove", nil)
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
