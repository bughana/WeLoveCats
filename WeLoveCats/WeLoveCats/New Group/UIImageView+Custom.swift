
import Foundation
import Kingfisher

extension UIImageView {
    func setImageWithUrl(_ url: URL?, completion: ((_ image: UIImage?) -> Void)?) {
        if let url = url {
            self.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.25))], progressBlock: nil) { (image, error, cacheType, imageUrl) in
                if let completion  = completion {
                    let image = image ?? nil
                    completion(image)
                }
            }
        } else {
            self.image = nil
            if let completion = completion {
                completion(nil)
            }
        }
    }
}
