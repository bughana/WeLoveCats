
import Foundation
import Fuzi

class NetworkService {
    
    static let sharedInstance = NetworkService()
    
    // MARK: - Public: Get api operation
    func apiOperation(_ apiRequest: ApiRequest, completion: @escaping (ApiRequestResult) -> ()) {
        
        guard let urlRequest = apiRequest.urlRequest else {
            completion(ApiRequestResult(catImages: nil, error: NSError(domain: "NetworkService", code: 2000, userInfo: ["description": "No UrlRequest"])))
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
                    completion(ApiRequestResult(catImages: nil, error: error))
                })
                return
            }
            
            guard let safeData = data else {
                DispatchQueue.main.async(execute: {
                    completion(ApiRequestResult(catImages: nil, error: NSError(domain: "NetworkService", code: 1001, userInfo: ["message": "Data can not be converted to URL array"])))
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                let images = self.parseXml(data: safeData)
                completion(ApiRequestResult(catImages: images, error: nil))
            })
        })
    }
    
    private func parseXml(data: Data) -> [CatImage] {
        do {
            var catImages: [CatImage] = []
            let doc = try XMLDocument(data: data)
            guard let root = doc.root,
                let data = root.children.first,
                let images = data.children.first else { return [] }
            for image in images.children {
                var imageUrl: URL?
                var id: String?
                for attribute in image.children {
                    if attribute.tag == "url" {
                        let urlStr = attribute.stringValue
                        if let url = URL(string: urlStr) {
                            imageUrl = url
                        }
                    } else if attribute.tag == "id" {
                        id = attribute.stringValue
                    }
                }
                if let imageUrl = imageUrl, let id = id {
                    catImages.append(CatImage(url: imageUrl, id: id))
                }
            }
            return catImages
        } catch { }
        return []
    }
}
