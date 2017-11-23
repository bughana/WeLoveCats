
import Foundation

class CatListViewModel {
    
    private let networkService = NetworkService()
    
    func getCatImageUrls() -> [URL] {
        networkService.apiOperation(.getCatImages) { result in
            print(result)
        }
        return []
    }
}
