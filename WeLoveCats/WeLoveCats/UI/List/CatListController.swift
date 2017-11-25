
import UIKit
import Cartography
import RxSwift

class MainCatListController: CatListController<CatListViewModel> {}

class LikesCatListController: CatListController<LikesCatListViewModel> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataAndReload()
    }
}

class CatListController<T: CatListViewModel>: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let cellIdentifier = "CatListCell"
    private let disposeBag = DisposeBag()
    fileprivate var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(pageTitleView)
        view.addSubview(collectionView)
        constrainSubviews()
        
        viewModel.getCatImages() { [weak self] shouldReload in
            if shouldReload {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.likesChangedObservable.subscribe(onNext: { [weak self] in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.catImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CatListCell
        
        let url = viewModel.catImages[indexPath.row].url
        let isLiked = viewModel.isLiked(at: indexPath)
        cell.setup(with: url, isLiked: isLiked)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.toggleLike(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth / 3.0) - 7
        let cellWidth = screenWidth > 0 ? width : 0
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        
        return cellSize
    }
    
    // MARK: - Private: Get data
    fileprivate func getDataAndReload() {
        viewModel.getCatImages() { [weak self] shouldReload in
            if shouldReload {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private: Autolayout
    private func constrainSubviews() {
        constrain(pageTitleView, collectionView, view) { pageTitleView, collectionView, superview in
            pageTitleView.top == superview.top
            pageTitleView.left == superview.left
            pageTitleView.right == superview.right
            pageTitleView.height == 84
            
            collectionView.top == pageTitleView.bottom
            collectionView.left == superview.left
            collectionView.right == superview.right
            collectionView.bottom == superview.bottom
        }
    }
    
    // MARK: - Private: CollectionView + Layout
    private lazy var pageTitleView: UILabel = {
        let pageTitleView = UILabel()
        
        pageTitleView.text = viewModel.pageTitle
        pageTitleView.textAlignment = .center
        pageTitleView.font = .boldSystemFont(ofSize: 24)
        pageTitleView.backgroundColor = .white
        pageTitleView.layer.borderColor = UIColor.lightGray.cgColor
        pageTitleView.layer.borderWidth = 1
        
        return pageTitleView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.backgroundColor = .white
        collectionView.register(CatListCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 6
        
        return layout
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
