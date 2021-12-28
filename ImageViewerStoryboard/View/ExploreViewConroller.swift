//
//  ExploreViewConroller.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 24.12.2021.
//

import UIKit
import SwiftEntryKit

extension UIView {
    func addSubview(_ view:UIView, position:()->Void){
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        position()
    }
}

final class ExploreViewConroller: UIViewController {
    
    private lazy var favoriteMark: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(favoriteMarkPressed))
    }()
    private var databaseService:DatabaseService?
    private var descriptionImageView:DescriptionImageView = DescriptionImageView()
    private let imageView = ImageView()
    private let networkDataFetcher:NetworkDataFetcher = NetworkDataFetcher()
//    private let imageSetupTimer = UIBarButtonItem(customView: ImageSetupTimer())
    lazy var imageSetupTimerLabel = ImageSetupTimerLabel(timeCount: 10, complition: setupImage)
    private var isHidden = false
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
        navigationsButtonsIsHidden = true
        navigationItem.titleView = imageSetupTimerLabel
    }
    
    // MARK: - Buttons actions

    @objc func favoriteMarkPressed() {
        databaseService?.write(imageView.unsplashPhoto)
        navigationsButtonsIsHidden = true
        
    }
}


// MARK: - receiving and handling images
extension ExploreViewConroller{
    
    private func setupImage(){
        self.networkDataFetcher.fetchImage {[weak self] (unsplashPhotoResult, error) in
            if let error = error{
                self?.handleTheError(error: error)
            }
            else{
                self?.handleEmptyError()
            }
            
            self?.handleTheResult(unsplashPhotoResult: unsplashPhotoResult)
        }
    }
    
    private func handleEmptyError(){
        imageSetupTimerLabel.isError = false
        navigationsButtonsIsHidden = false
    }
    
    private func handleTheError(error:String){
        if isHidden {return}
        errorRecieveNetworkData(error: error)
        imageSetupTimerLabel.isError = true
        navigationsButtonsIsHidden = true
    }
    
    private func handleTheResult(unsplashPhotoResult:UnsplashPhoto?){
        descriptionImageView.unsplashPhoto = unsplashPhotoResult
        imageView.unsplashPhoto = unsplashPhotoResult
        
    }
    
    private func errorRecieveNetworkData(error:String){
        SwiftEntryKit.display(entry: PopUpView(with: error), using: EKAttributes.topToast)
    }
}


// MARK: - Setup UI elements position
extension ExploreViewConroller {
    
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

extension ExploreViewConroller : DatabaseServiceWorking{
    
    func setupDatabaseService(_ databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
}

