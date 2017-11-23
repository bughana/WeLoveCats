//
//  AppDelegate.swift
//  WeLoveCats
//
//  Created by Hannah Teuteberg on 23.11.17.
//  Copyright © 2017 Bughana. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupCatLists()
        return true
    }

    private func setupCatLists() {
        guard let rootController = window?.rootViewController as? UITabBarController, let catList = rootController.viewControllers?.first as? CatListController else { return }
        
        let catListViewModel = CatListViewModel(type: .all)
        catList.setup(with: catListViewModel)
        
        guard let favourites = rootController.viewControllers?.last as? CatListController else { return }
        
        let favoritesViewModel = CatListViewModel(type: .favourites)
        favourites.setup(with: favoritesViewModel)
    }
}

