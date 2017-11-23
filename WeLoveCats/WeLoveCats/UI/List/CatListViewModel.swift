
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
    
    var imageUrls: [URL] = []
    
    var pageTitle: String {
        return type.pageTitle
    }
    
    private let networkService = NetworkService()
    private let type: CatListType
    
    // MARK: - Public interface
    init(type: CatListType) {
        self.type = type
    }
    
    func getCatImageUrls(_ completion: @escaping (_ shouldReload: Bool) -> ()) {
        getCatImageUrls(for: type, completion)
    }
    
    // MARK: - Private Helper
    private func getCatImageUrls(for type: CatListType, _ completion: @escaping (_ shouldReload: Bool) -> ()) {
        networkService.apiOperation(type.apiRequest) { [weak self] result in
            if let urls = result.imageUrls {
                self?.imageUrls = urls
                completion(true)
            }
        }
    }
}
