//
//  UnsplashModel.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 23.12.2021.
//

import Foundation
import RealmSwift

struct UnsplashPhoto: Decodable, Hashable{
    let id: String
    let width: Int
    let height: Int
    let color: String
    let created_at:String
    let updated_at:String
    let downloads:Int
    let likes:Int
    let urls:[URLSizes.RawValue:String]
    
    
    
    enum URLSizes:String{
        case taw
        case full
        case regular
        case small
        case thumb
    }
}

