
import Foundation
import RxSwift

class LikeStore {
    
    static let sharedInstance = LikeStore()
    
    let likesImageIds: Variable<Set<String>> = Variable(Set())
    
    func saveLikeIdsFromServer(ids: [String]) {
        likesImageIds.value = Set(ids)
    }
    
    func isLiked(id: String) -> Bool {
        return likesImageIds.value.contains(id)
    }
    
    func like(id: String) {
        likesImageIds.value.insert(id)
    }
    
    func unlike(id: String) {
        likesImageIds.value.remove(id)
    }
}
