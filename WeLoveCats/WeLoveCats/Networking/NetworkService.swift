
import Foundation
import Fuzi

class NetworkService {
    
    // MARK: - Public: Get api operation
    func apiOperation(_ apiRequest: ApiRequest, completion: @escaping (ApiRequestResult) -> ()) {
        
        guard let urlRequest = apiRequest.urlRequest else {
            completion(ApiRequestResult(imageUrls: nil, error: NSError(domain: "NetworkService", code: 2000, userInfo: ["description": "No UrlRequest"])))
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
                    completion(ApiRequestResult(imageUrls: nil, error: error))
                })
                return
            }
            
            guard let safeData = data else {
                DispatchQueue.main.async(execute: {
                    completion(ApiRequestResult(imageUrls: nil, error: NSError(domain: "NetworkService", code: 1001, userInfo: ["message": "Data can not be converted to URL array"])))
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                let urls = self.parseXml(data: safeData)
                completion(ApiRequestResult(imageUrls: urls, error: nil))
            })
        })
    }
    
    private func parseXml(data: Data) -> [URL] {
        do {
            var urls: [URL] = []
            let doc = try XMLDocument(data: data)
            guard let root = doc.root,
                let data = root.children.first,
                let images = data.children.first else { return [] }
            for image in images.children {
                for attribute in image.children {
                    if attribute.tag == "url" {
                        let urlStr = attribute.stringValue
                        if let url = URL(string: urlStr) {
                            urls.append(url)
                        }
                    }
                }
            }
            return urls
        } catch { }
        return []
    }
}
