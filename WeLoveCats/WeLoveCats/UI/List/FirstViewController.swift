//
//  FirstViewController.swift
//  WeLoveCats
//
//  Created by Hannah Teuteberg on 23.11.17.
//  Copyright © 2017 Bughana. All rights reserved.
//

import UIKit
import Cartography

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        constrain(collectionView, view) { collectionView, superview in
            collectionView.edges == superview.edges
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        return layout
    }()
}

