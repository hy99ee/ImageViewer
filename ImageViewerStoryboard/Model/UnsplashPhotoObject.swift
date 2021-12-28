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
//    @objc dynamic var urls:[UnsplashPhoto.URLSizes.RawValue: String] = [:]
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
//        character.urls = urls
        if let defaultUrl = urls[UnsplashPhoto.URLSizes.regular.rawValue]{
            character.defaultUrl = defaultUrl
        }
//        character.defaultUrl = urls[UnsplashPhoto.URLSizes.regular]
//        character.name = name
//        character.realName = realName
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
//        urls = managedObject.urls
        if let defaultUrl = managedObject.defaultUrl{
            urls = [UnsplashPhoto.URLSizes.regular.rawValue : defaultUrl]
        }
        else{
            urls = [:]
        }
    }
}

public final class WriteTransaction {
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func add<T: Persistable>(_ value: T, update: Bool = true) {
        realm.add(value.managedObject(), update: .all)
    }
}

// Implement the Container
public final class Container {
    private let realm: Realm
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func write(_ block: (WriteTransaction) throws -> Void)
    throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }
}
    


public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

//
//class MyRealObject : Object {
//
//    @objc private dynamic var structData:Data? = nil
//
//    var myStruct : UnsplashPhoto? {
//        get {
//            if let data = structData {
//                return try? JSONDecoder().decode(UnsplashPhoto.self, from: data)
//            }
//            return nil
//        }
//        set {
//            structData = try? JSONEncoder().encode(newValue)
//        }
//    }
//}
