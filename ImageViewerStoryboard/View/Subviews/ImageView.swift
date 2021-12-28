//
//  ImageView.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 26.12.2021.
//

import Foundation
import UIKit
import SDWebImage

class ImageView: UIImageView {

    var unsplashPhoto:UnsplashPhoto?{
        didSet{
            let photoUrl = unsplashPhoto?.urls[UnsplashPhoto.URLSizes.regular.rawValue]
            DispatchQueue.global().async {
                guard let photoUrl = photoUrl, let url = URL(string: photoUrl) else {return}
                DispatchQueue.main.async {
                    self.sd_setImage(with: url, completed: nil)
                }
            }
        }
    }

    
    override init(frame: CGRect = UIScreen.main.bounds) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
