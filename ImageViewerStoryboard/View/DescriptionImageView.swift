//
//  DescriptionImageView.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 27.12.2021.
//

import Foundation
import UIKit

class DescriptionImageView: UILabel{
    
    override init(frame: CGRect = UIScreen.main.bounds) {
        super.init(frame: frame)
        numberOfLines = 0
        layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        textAlignment = .left
//        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    var unsplashPhoto:UnsplashPhoto?{
        didSet{
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                var str = ""
                str.append("ID - \(self.unsplashPhoto?.id ?? "")"); str.append("\n")
                str.append("Likes - \(self.unsplashPhoto?.likes ?? 0)"); str.append("\n")
                str.append("Downloads - \(self.unsplashPhoto?.downloads ?? 0)")
                DispatchQueue.main.async {
                    
                    self.text = str
                }
            }
        }
    }
    
    private let topInset:CGFloat = 5, leftInset:CGFloat = 30, bottomInset:CGFloat = 5, rightInset:CGFloat = 30
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }

}
