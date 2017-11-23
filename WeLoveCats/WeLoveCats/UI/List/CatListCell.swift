
import UIKit
import Cartography

class CatListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(likeButton)
        constrainSubviews()
    }
    
    // MARK: - Private: Autolayout
    private func constrainSubviews() {
        constrain(imageView, self) { imageView, superview in
            imageView.edges == superview.edges
        }
        
        constrain(likeButton, self) { likeButton, superview in
            likeButton.right == superview.right - 10
            likeButton.bottom == superview.bottom - 10
        }
    }
    
    // MARK: - Subviews
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        
        likeButton.setImage(UIImage(named: "like"), for: .normal)
        likeButton.setImage(UIImage(named: "likeFilled"), for: .selected)
        
        return likeButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
