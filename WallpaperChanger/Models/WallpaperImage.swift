//
//  WallpaperImage.swift
//  WallpaperChanger
//
//  Created by Sagun Raj Lage on 30/05/2021.
//

import Foundation

struct WallpaperImage: Decodable {
    let startDate: String
    let url: String
    let copyright: String
    let copyrightLink: String
    let title: String
    let quiz: String
    
    var fullUrl: URL? {
        return URL(string: "https://bing.com/\(self.url)")
    }
    
    public enum CodingKeys: String, CodingKey {
        case startDate = "startdate"
        case url
        case copyright
        case copyrightLink = "copyrightlink"
        case title
        case quiz
    }
}
