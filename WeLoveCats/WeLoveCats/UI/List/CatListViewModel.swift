
import Foundation

enum CatListType {
    case all
    case favourites
}

class CatListViewModel {
    
    var imageUrls: [URL] = []
    
    var pageTitle: String {
        switch type {
        case .all:
            return "All these cats"
        case .favourites:
            return "My favourites"
        }
    }
    
    private let networkService = NetworkService()
    private let type: CatListType
    
    init(type: CatListType) {
        self.type = type
    }
    
    func getCatImageUrls(_ completion: @escaping (_ shouldReload: Bool) -> ()) {
        networkService.apiOperation(.getCatImages) { [weak self] result in
            if let urls = result.imageUrls {
                self?.imageUrls = urls
                completion(true)
            }
        }
    }
}
