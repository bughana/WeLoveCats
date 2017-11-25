
import UIKit
import Cartography

class CatListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(likeImageView)
        constrainSubviews()
    }
    
    func setup(with url: URL, isLiked: Bool) {
        imageView.setImageWithUrl(url, completion: nil)
        let image = isLiked ? UIImage(named: "likeFilled") : UIImage(named: "like")
        likeImageView.image = image
    }
    
    // MARK: - Private: Autolayout
    private func constrainSubviews() {
        constrain(imageView, self) { imageView, superview in
            imageView.edges == superview.edges
        }
        
        constrain(likeImageView, self) { likeImageView, superview in
            likeImageView.right == superview.right - 10
            likeImageView.bottom == superview.bottom - 10
        }
    }
    
    // MARK: - Subviews
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var likeImageView: UIImageView = {
        let likeImageView = UIImageView()
        
        likeImageView.image = UIImage(named: "like")
        
        return likeImageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
