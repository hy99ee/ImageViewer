//
//  UnsplashPhotoObject.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 25.12.2021.
//

import Foundation
import RealmSwift

final class UnsplashPhotoObject: Object {
    @objc dynamic var id = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var color = ""
    @objc dynamic var created_at = ""
    @objc dynamic var updated_at = ""
    @objc dynamic var downloads = 0
    @objc dynamic var likes = 0
    @objc dynamic var defaultUrl:String?
}

extension UnsplashPhoto: Persistable {
    func managedObject() -> UnsplashPhotoObject {
        let character = UnsplashPhotoObject()
        character.id = id
        character.width = width
        character.height = height
        character.color = color
        character.created_at = created_at
        character.updated_at = updated_at
        character.downloads = downloads
        character.likes = likes
        if let defaultUrl = urls[UnsplashPhoto.URLSizes.regular.rawValue]{
            character.defaultUrl = defaultUrl
        }
        return character
    }
    
    init(managedObject: UnsplashPhotoObject) {
        id = managedObject.id
        width = managedObject.width
        height = managedObject.height
        color = managedObject.color
        created_at = managedObject.created_at
        updated_at = managedObject.updated_at
        downloads = managedObject.downloads
        likes = managedObject.likes
        if let defaultUrl = managedObject.defaultUrl{
            urls = [UnsplashPhoto.URLSizes.regular.rawValue : defaultUrl]
        }
        else{
            urls = [:]
        }
    }
}





public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

