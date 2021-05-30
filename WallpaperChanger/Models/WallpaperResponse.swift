//
//  WallpaperResponse.swift
//  WallpaperChanger
//
//  Created by Sagun Raj Lage on 30/05/2021.
//

import Foundation

struct WallpaperResponse: Decodable {
    let images: [WallpaperImage]
    
    public enum CodingKeys: String, CodingKey {
        case images
    }
}
