//
//  NetworkService.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 02.01.2022.
//

import Foundation

protocol NetworkFetchServiceWorking{
    var networkFetcher:NetworkFetchService? {get}
}

protocol NetworkFetchService{
    func fetchImage(complition: @escaping ((UnsplashPhoto?, ImageError?)) -> Void)
}
