
import Foundation

enum CatListType {
    case all
    case favourites
    
    var pageTitle: String {
        switch self {
        case .all:
            return "All these cats"
        case .favourites:
            return "My favourites"
        }
    }
    
    var apiRequest: ApiRequest {
        switch self {
        case .all:
            return .getCatImages
        case .favourites:
            return .getFavourites
        }
    }
}

class CatListViewModel {
    
    var catImages: [CatImage] = []
    
    var pageTitle: String {
        return type.pageTitle
    }
    
    private let networkService = NetworkService()
    private let type: CatListType
    
    // MARK: - Public interface
    init(type: CatListType) {
        self.type = type
    }
    
    func getCatImages(_ completion: @escaping (_ shouldReload: Bool) -> ()) {
        getCatImages(for: type, completion)
    }
    
    // MARK: - Private Helper
    private func getCatImages(for type: CatListType, _ completion: @escaping (_ shouldReload: Bool) -> ()) {
        networkService.apiOperation(type.apiRequest) { [weak self] result in
            if let catImages = result.catImages {
                self?.catImages = catImages
                completion(true)
            }
        }
    }
}
