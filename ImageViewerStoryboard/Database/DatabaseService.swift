//
//  DatabaseService.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 28.12.2021.
//

import Foundation

protocol DatabaseService{
    func write(_ object:UnsplashPhoto?)
    func objects() -> [UnsplashPhoto?]
    func remove(_ indexPaths:[IndexPath])
    func updateObjects()
}

protocol DatabaseServiceWorking{
    var databaseService:DatabaseService! {get}
}
