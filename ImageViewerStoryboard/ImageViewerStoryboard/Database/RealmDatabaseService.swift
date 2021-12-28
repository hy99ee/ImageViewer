//
//  RealmDatabaseService.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 28.12.2021.
//

import Foundation
import RealmSwift



final class RealmDatabaseService: DatabaseService{
    
    
    private var _objects: Results<UnsplashPhotoObject>!
    func objects() -> [UnsplashPhoto?] {
        return _objects.map({ UnsplashPhoto(managedObject: $0)})
    }
    
    
    private let realm:Realm = try! Realm()
    
    func updateObjects(){
        _objects = realm.objects(UnsplashPhotoObject.self)
    }
    init(){
        updateObjects()
    }
    
    func write(_ object:UnsplashPhoto?){
        guard let unsplashObject = object else {return}
        try! realm.write({
            if let object = convertInputObject(unsplashObject){
                realm.add(object)
            }
        })
        
        updateObjects()
    }
 
    func remove(_ indexPaths:[IndexPath]) {
        
        let indexes = indexPaths.map { item in
            item.item
        }
        var newImages = [UnsplashPhotoObject]()
        for (index, image) in _objects.enumerated() {
            if indexes.contains(index){
                newImages.append(image)
            }
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(newImages)
        }
    }
    
    private func convertInputObject(_ object:UnsplashPhoto) -> Object? {
        return object.managedObject()
    }
    
}
