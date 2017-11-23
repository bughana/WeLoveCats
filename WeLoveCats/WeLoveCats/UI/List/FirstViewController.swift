//
//  FirstViewController.swift
//  WeLoveCats
//
//  Created by Hannah Teuteberg on 23.11.17.
//  Copyright © 2017 Bughana. All rights reserved.
//

import UIKit
import Cartography

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private let cellIdentifier = "CatListCell"
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        constrain(collectionView, view) { collectionView, superview in
            collectionView.edges == superview.edges
        }
    }
    
    // MARK: - Collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CatListCell
        
        return cell
    }
    
    // MARK: - Private: CollectionView + Layout
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.backgroundColor = .white
        collectionView.register(CatListCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 6
        
        return layout
    }()
}

extension FirstViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth / 3.0) - 7
        let cellWidth = screenWidth > 0 ? width : 0
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        
        return cellSize
    }
}
