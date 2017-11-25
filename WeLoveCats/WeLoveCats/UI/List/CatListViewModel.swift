
import Foundation
import RxSwift

class CatListViewModel {
    
    var catImages: [CatImage] = []

    var pageTitle: String {
        return "All these cats"
    }
    
    var likesChangedObservable: Observable<Void> {
        return likeStore.likesImageIds.asObservable().map { _ in () }
    }
    
    fileprivate var networkService: NetworkService {
        return NetworkService.sharedInstance
    }
    
    fileprivate var likeStore: LikeStore {
        return LikeStore.sharedInstance
    }

    func getCatImages(_ completion: @escaping (_ shouldReload: Bool) -> ()) {
        networkService.apiOperation(.getCatImages) { [weak self] result in
            if let catImages = result.catImages {
                self?.catImages = catImages
                completion(true)
            }
        }
    }
    
    func toggleLike(at index: Int) {
        guard let image = catImages[safe: index] else { return }
        let apiRequest: ApiRequest
        if likeStore.isLiked(id: image.id) {
            apiRequest = .unlikeImage(imageId: image.id)
            likeStore.unlike(id: image.id)
        } else {
            apiRequest = .likeImage(imageId: image.id)
            likeStore.like(id: image.id)
        }
        // TODO: add error handling for this
        networkService.apiOperation(apiRequest) { _ in }
    }
    
    func isLiked(at indexPath: IndexPath) -> Bool {
        guard let image = catImages[safe: indexPath.row] else { return false }
        return likeStore.isLiked(id: image.id)
    }
}

class LikesCatListViewModel: CatListViewModel {
    override var pageTitle: String {
        return "My favourites"
    }
    
    override func getCatImages(_ completion: @escaping (_ shouldReload: Bool) -> ()) {
        networkService.apiOperation(.getFavourites) { [weak self] result in
            if let catImages = result.catImages {
                self?.catImages = catImages
                let ids = catImages.map { $0.id }
                self?.likeStore.saveLikeIdsFromServer(ids: ids)
                completion(true)
            }
        }
    }
}
