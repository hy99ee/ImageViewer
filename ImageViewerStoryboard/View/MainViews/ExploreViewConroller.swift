//
//  ExploreViewConroller.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 24.12.2021.
//

import UIKit
import SwiftEntryKit
import RxSwift
import RxCocoa

extension UIView {
    func addSubview(_ view:UIView, position:()->Void){
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        position()
    }
}

final class ExploreViewConroller: UIViewController {
    
    private lazy var favoriteMark: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(favoriteMarkPressed))
    }()
    
    private var descriptionImageView = DescriptionImageView()
    private let imageView = ImageView()
    private var isHidden = false
    private let viewModel = ExploreViewModel()
    private let bag = DisposeBag()
    private let timerLabel:UILabel = UILabel()
    private var _navigationsButtonsIsHidden:Bool = true
    private var navigationsButtonsIsHidden:Bool{
        set{
            if newValue{
                navigationItem.rightBarButtonItem = nil
            }
            else{
                navigationItem.rightBarButtonItem = favoriteMark
            }
        }
        get{
            return _navigationsButtonsIsHidden
        }
    }
    
    // MARK: - View Life Cycle

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView, position: photoViewPosition)
        view.addSubview(descriptionImageView, position: descriptionImageViewPosition)
        timerLabel.text = "0"
        navigationItem.titleView = timerLabel
//        navigationsButtonsIsHidden = true
        // TODO: this must be in the create layer
        viewModel.databaseService = RealmDatabaseService()
        viewModel.networkFetcher = NetworkDataFetcher()
        viewModel.unsplashPhoto.asObservable().subscribe { [weak imageView, weak descriptionImageView] unsplashPhoto in
            imageView?.unsplashPhoto = unsplashPhoto.element
            descriptionImageView?.unsplashPhoto = unsplashPhoto.element
        }.disposed(by: bag)
        viewModel.timer.timerCount.asObservable().subscribe { [weak self] timerCount in
            print(timerCount)
            self?.updateTimerLabel(timerCount: timerCount.element ?? 0)
        }.disposed(by: bag)
        
//        navigationItem.titleView = imageSetupTimerLabel
    }
    
    private func updateTimerLabel(timerCount:Int){
        timerLabel.text = String(timerCount)
        
    }
    
    
    
    // MARK: - Buttons actions

    @objc func favoriteMarkPressed() {
//        databaseService?.write(imageView.unsplashPhoto)
        viewModel.writeToDatabaseService()
        navigationsButtonsIsHidden = true
        
    }
}

// MARK: - receiving and handling images
//extension ExploreViewConroller {
//
//    func setupImage(){
//        self.networkDataFetcher.fetchImage {[weak self] (unsplashPhotoResult, error) in
//            if let error = error{
//                self?.handleTheError(error: error)
//            }
//            else{
//                self?.handleEmptyError(unsplashPhoto: unsplashPhotoResult)
//            }
//        }
//    }
//
//    func handleEmptyError(unsplashPhoto:UnsplashPhoto?){
//
//        imageSetupTimerLabel.isError = false
//        navigationsButtonsIsHidden = false
//
//        descriptionImageView.unsplashPhoto = unsplashPhoto
//        imageView.unsplashPhoto = unsplashPhoto
//
//        guard let unsplashPhoto = unsplashPhoto else {return}
//        defaults.set(unsplashPhoto.id,forKey: UnsplashPhotoKeys.keyId.rawValue)
//        defaults.set(unsplashPhoto.likes,forKey: UnsplashPhotoKeys.keyLikes.rawValue)
//        defaults.set(unsplashPhoto.downloads,forKey: UnsplashPhotoKeys.keyDownloads.rawValue)
//        defaults.set(unsplashPhoto.urls["regular"],forKey: UnsplashPhotoKeys.keyUrl.rawValue)
//    }
//
//    func handleTheError(error:String){
//        if isHidden {return}
//        errorRecieveNetworkData(error: error)
//        imageSetupTimerLabel.isError = true
//        navigationsButtonsIsHidden = true
//
//        guard let id = defaults.object(forKey: UnsplashPhotoKeys.keyId.rawValue) as? String,
//              let likes = defaults.object(forKey: UnsplashPhotoKeys.keyLikes.rawValue) as? Int,
//              let downloads = defaults.object(forKey: UnsplashPhotoKeys.keyDownloads.rawValue) as? Int,
//              let url = defaults.object(forKey: UnsplashPhotoKeys.keyUrl.rawValue) as? String
//        else{
//            return
//        }
//
//        let unsplashPhoto = UnsplashPhoto(id: id, width: 0, height: 0, color: "", created_at: "", updated_at: "", downloads: downloads, likes: likes, urls: [UnsplashPhoto.URLSizes.regular.rawValue: url])
//
//
//        descriptionImageView.unsplashPhoto = unsplashPhoto
//        imageView.unsplashPhoto = unsplashPhoto
//
//    }
//
//
//    private func errorRecieveNetworkData(error:String){
//        SwiftEntryKit.display(entry: PopUpView(with: error), using: EKAttributes.topToast)
//    }
//}


// MARK: - Setup UI elements position
extension ExploreViewConroller {
    
    private func photoViewPosition(){
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    
    private func descriptionImageViewPosition(){
        NSLayoutConstraint.activate([
            descriptionImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            descriptionImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            descriptionImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
}
