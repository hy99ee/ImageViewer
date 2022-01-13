//
//  ExploreViewAssembly.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 13.01.2022.
//

import Foundation
import EasyDi

class ExploreViewAssembly: Assembly {

  lazy var exploreViewModelAssembly: ExploreViewModelAssembly = self.context.assembly()

    var viewController: UIViewController {
        return define(init: ExploreViewConroller()) {
            $0.viewModel = self.exploreViewModelAssembly.viewModel
            return $0
        }
    }
}

class ExploreViewModelAssembly: Assembly {
    
    var viewModel: ExploreViewModel {
        return define(init: ExploreViewModel()) {
            $0.databaseService = self.createDatabase
            $0.networkFetcher = self.createNetwork
            $0.isCreated = true
            return $0
        }
    }
    
    var createDatabase: DatabaseService {
        return RealmDatabaseService()
    }
    
    var createNetwork: NetworkFetchService {
        return NetworkDataFetcher()
    }
    
}
