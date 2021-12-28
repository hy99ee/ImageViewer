//
//  ExploreViewConroller.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 24.12.2021.
//

import UIKit
import RealmSwift
import SwiftEntryKit

extension UIView {
    func addSubview(_ view:UIView, position:()->Void){
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        position()
    }
}

class ExploreViewConroller: UIViewController {

//    private var gradientView:GradientView
//    private var imageView:UIImageView{
//        return UIImageView(frame: CGRect(x: view.center.x, y: view.center.y, width: view.frame.width, height: view.frame.height))
//    }
    private lazy var favoriteMark: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(favoriteMarkPressed))
    }()
    private var descriptionImageView:DescriptionImageView = DescriptionImageView()
    private let imageView = ImageView()
    private let networkDataFetcher:NetworkDataFetcher = NetworkDataFetcher()
    private var _navigationsButtonsIsHidden:Bool = true
    private var navigationsButtonsIsHidden:Bool{
        set{
            if newValue{
                navigationItem.rightBarButtonItem = favoriteMark
            }
            else{
                navigationItem.rightBarButtonItem = nil
            }
        }
        get{
            return _navigationsButtonsIsHidden
        }
    }
    // MARK: - View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView, position: photoViewPosition)
        view.addSubview(descriptionImageView, position: descriptionImageViewPosition)
        navigationsButtonsIsHidden = true
//        view.addSubview(favoriteMark, position: favoriteMarkPosition)
//        view.addSubview(imageText, position: imageTextPosition)
//        favoriteMark.addTarget(self, action: #selector(favoriteMarkPressed), for: .touchUpInside)

    }
    
    // MARK: - Buttons actions

    @objc func favoriteMarkPressed() {
        let realm = try! Realm()
        try! realm.write{
            if let unsplashPhoto = imageView.unsplashPhoto {
                realm.add(unsplashPhoto.managedObject())
            }
        }
        navigationsButtonsIsHidden = false
        
        
    }
    

    
    // MARK: - Take image from image generator and install this in the ImageView class
   
    private func setupImage(){
        self.networkDataFetcher.fetchImage {[weak self] (unsplashPhotoResult, error) in
            if let error = error { self?.errorRecieveNetworkData(error: error) }
            self?.descriptionImageView.unsplashPhoto = unsplashPhotoResult
            self?.imageView.unsplashPhoto = unsplashPhotoResult
            self?.navigationsButtonsIsHidden = true
        }

    }
    
    private func errorRecieveNetworkData(error:String){
        SwiftEntryKit.display(entry: PopUpView(with: error), using: EKAttributes.topToast)
    }
}
    
extension ExploreViewConroller {
    
    // MARK: - Setup UI elements position
    
    private func photoViewPosition(){
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    
    
    private func descriptionImageViewPosition(){
        NSLayoutConstraint.activate([
            descriptionImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            descriptionImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            descriptionImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
    
    
    
}

