//
//  ImagesCollectionViewAssembly.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 13.01.2022.
//

import Foundation
import EasyDi

class ImagesCollectionViewAssembly: Assembly {
    
    var viewController: UICollectionViewController {
        return define(init: ImagesCollectionViewController()) {
            $0.databaseService = self.createDatabase
            return $0
        }
    }
    
    var createDatabase: DatabaseService {
        return RealmDatabaseService()
    }
    
    
}
