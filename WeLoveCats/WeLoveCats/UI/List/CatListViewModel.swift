
import Foundation

class CatListViewModel {
    
    private let networkService = NetworkService()
    
    var imageUrls: [URL] = []
    
    func getCatImageUrls(_ completion: @escaping (_ shouldReload: Bool) -> ()) {
        networkService.apiOperation(.getCatImages) { [weak self] result in
            if let urls = result.imageUrls {
                self?.imageUrls = urls
                completion(true)
            }
        }
    }
}
