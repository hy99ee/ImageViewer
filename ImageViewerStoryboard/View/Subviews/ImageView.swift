//
//  ImageView.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 26.12.2021.
//

import Foundation
import UIKit
import SDWebImage
import RxSwift
import RxCocoa

final class ImageView: UIImageView {

    var heightImage = BehaviorRelay<CGFloat>(value: 0)
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
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize
    {

        let frameSizeWidth = self.frame.size.width
        guard let image = self.image else
        {
            return CGSize(width: frameSizeWidth, height: 1.0)
        }

        let returnHeight = ceil(image.size.height * (frameSizeWidth / image.size.width))
        heightImage.accept(returnHeight)
        return CGSize(width: frameSizeWidth, height: returnHeight)
    }
    
}
