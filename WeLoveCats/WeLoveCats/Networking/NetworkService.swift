
import Foundation

class NetworkService {
    
    // MARK: - Public: Get api operation
    func apiOperation(_ apiRequest: ApiRequest, completion: @escaping (ApiRequestResult) -> ()) {
        
        guard let urlRequest = apiRequest.urlRequest else {
            completion(ApiRequestResult(jsonResponse: nil, error: NSError(domain: "yeay", code: 2000, userInfo: ["description": "No UrlRequest"])))
            return
        }
        let task = urlDataTask(forUrlRequest: urlRequest, completion: completion)
        task.resume()
    }
    
    // MARK: - Public: create url data task
    private func urlDataTask(forUrlRequest urlRequest: URLRequest, completion: @escaping (ApiRequestResult) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) -> Void in
            guard error == nil else {
                DispatchQueue.main.async(execute: {
                    completion(ApiRequestResult(jsonResponse: nil, error: error))
                })
                return
            }
            
            guard let safeData = data else {
                DispatchQueue.main.async(execute: {
                    completion(ApiRequestResult(jsonResponse: nil, error: NSError(domain: "NetworkService", code: 1001, userInfo: ["message": "Data can not be converted to JSON"])))
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                completion(ApiRequestResult(jsonResponse: nil, error: nil))
            })
        })
    }
}
