//
//  AssemblyLayer.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 02.01.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class ExploreViewModel:DatabaseServiceWorking, NetworkServiceWorking {
        
    var databaseService: DatabaseService!
    var networkFetcher: NetworkDataFetcher!
    let bag = DisposeBag()
    var unsplashPhoto = BehaviorRelay<(data:UnsplashPhoto?,error:ImageError?)>(value: (UnsplashPhoto(id: "", width: 0, height: 0, color: "", created_at: "", updated_at: "", downloads: 0, likes: 0, urls: [:]),nil))
    private let defaults = UserDefaults.standard
    private let updateTime = 10
    let timer:ImageSetupTimer!
    
    
    init(networkFetcher:NetworkDataFetcher, databaseService: DatabaseService) {
        
        self.networkFetcher = networkFetcher
        self.databaseService = databaseService
        
        timer = ImageSetupTimer(timeCount: updateTime)
        timer.timerCount.asObservable()
            .filter { value in
                value == 0
            }
            .subscribe { [weak self] time in
            guard let self = self else {return}
            self.setupImage()
        }
            .disposed(by: bag)
    }
 
    
    public func writeToDatabaseService() {
        databaseService?.write(unsplashPhoto.value.data)
    }
    
    // MARK: - receiving and handling images
    func setupImage(){
        self.networkFetcher.fetchImage {[weak self] (unsplashPhotoResult, error) in
            if let error = error{
                self?.handleTheError(error: error)
            }
            else{
                if let unsplashPhotoResult = unsplashPhotoResult {
                    self?.handleEmptyError(unsplashPhoto: unsplashPhotoResult)
                }
            }
        }
    }
    
    func handleEmptyError(unsplashPhoto:UnsplashPhoto){
        self.unsplashPhoto.accept((unsplashPhoto,nil))
        defaults.set(unsplashPhoto.id,forKey: UnsplashPhotoKeys.keyId.rawValue)
        defaults.set(unsplashPhoto.likes,forKey: UnsplashPhotoKeys.keyLikes.rawValue)
        defaults.set(unsplashPhoto.downloads,forKey: UnsplashPhotoKeys.keyDownloads.rawValue)
        defaults.set(unsplashPhoto.urls["regular"],forKey: UnsplashPhotoKeys.keyUrl.rawValue)
        timer.isError = false
    }
    
    
    func handleTheError(error:ImageError){
        
        var unsplashPhoto:UnsplashPhoto?
        if let id = defaults.object(forKey: UnsplashPhotoKeys.keyId.rawValue) as? String,
           let likes = defaults.object(forKey: UnsplashPhotoKeys.keyLikes.rawValue) as? Int,
           let downloads = defaults.object(forKey: UnsplashPhotoKeys.keyDownloads.rawValue) as? Int,
           let url = defaults.object(forKey: UnsplashPhotoKeys.keyUrl.rawValue) as? String{
            unsplashPhoto = UnsplashPhoto(id: id, width: 0, height: 0, color: "", created_at: "", updated_at: "", downloads: downloads, likes: likes, urls: [UnsplashPhoto.URLSizes.regular.rawValue: url])
        }
        timer.isError = true
        
        
        self.unsplashPhoto.accept((unsplashPhoto,error))
        
    }
    
    
    
 
}
