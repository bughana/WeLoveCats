
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupCatLists()
        return true
    }

    private func setupCatLists() {
        let root = UITabBarController()
        let catListViewModel = CatListViewModel()
        let catList = MainCatListController(viewModel: catListViewModel)
        catList.tabBarItem = UITabBarItem(title: "Cat List", image: UIImage(named: "first"), tag: 1)
        
        let likedCatListViewModel = LikesCatListViewModel()
        let likedCatList = LikesCatListController(viewModel: likedCatListViewModel)
        likedCatList.tabBarItem = UITabBarItem(title: "My Favourties", image: UIImage(named: "second"), tag: 2)
        
        root.setViewControllers([catList, likedCatList], animated: false)
        window?.rootViewController = root
    }
}

