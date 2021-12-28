//
//  TabBarConroller.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 23.12.2021.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let favoritesPhotos = ImagesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let exploreView = ExploreViewConroller()
        
        viewControllers = [
            generateNavigationController(rootViewController: exploreView, title: "Photos", image: #imageLiteral(resourceName: "photos")),
            generateNavigationController(rootViewController: favoritesPhotos, title: "Favourites", image: #imageLiteral(resourceName: "heart"))
        ]
    }
    

    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}

//
//extension UIImage{
//    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//
//        let widthRatio  = targetSize.width  / image.size.width
//        let heightRatio = targetSize.height / image.size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, size.height * heightRatio)
//        } else {
//            newSize = CGSize(size.width * widthRatio,  size.height * widthRatio)
//        }
//
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
//
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.drawInRect(rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage
//    }
//}
