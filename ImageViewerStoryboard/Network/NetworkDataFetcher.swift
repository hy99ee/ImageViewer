//
//  NetworkDataFetcher.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 23.12.2021.
//

import Foundation

final class NetworkDataFetcher{
    let networkService = NetworkService()
    
    func fetchImage(complition: @escaping ((UnsplashPhoto?, String?)) -> Void){
        networkService.request() { (data, error) in
            if let _ = error {
//                print("Error recieved data: \(error.localizedDescription)")
                let errorString = NetworkError.ConnectionError.rawValue
                complition((nil, errorString))
                return
            }
            let unsplashPhotoResult = self.decodeJSON(type: UnsplashPhoto.self, from: data)
            complition(unsplashPhotoResult)
            
        }
    }
    
    func fetchImages(complition: @escaping (UnsplashPhoto?) -> Void){
        networkService.request() { (data, error) in
            if let _ = error {
                complition(nil)
                return
            }
            let decode = self.decodeJSON(type: UnsplashPhoto.self, from: data)
            complition(decode.0)
        }
    }
    
    func decodeJSON<T:Decodable>(type:T.Type, from data: Data?) -> (T?,String?){
        guard let data = data else {return (nil,nil)}
        let decoder = JSONDecoder()
        do {
            let objects = try decoder.decode(type.self, from: data)
            return (objects,nil)
        } catch let jsonError {
            let error = NetworkError.ServiceError.rawValue
            return (nil, error)
        }
    }
}
