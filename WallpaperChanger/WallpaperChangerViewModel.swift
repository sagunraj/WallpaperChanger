//
//  ViewModel.swift
//  WallpaperChanger
//
//  Created by Sagun Raj Lage on 30/05/2021.
//

import Foundation

class WallpaperChangerViewModel: ObservableObject {
    @Published var wallpapers: [WallpaperImage] = [WallpaperImage(startDate: "", url: "", copyright: "", copyrightLink: "", title: "", quiz: "")]
    
    /// Fetches the wallpaper by performing API call.
    /// - Parameter days: Defines how many days old wallpaper you would like to get.
    func fetchWallpaper(before days: Int = 0, of location: String = "en-US", completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://www.bing.com/HPImageArchive.aspx?format=js&idx=\(days)&n=1&mkt=\(location)") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                do {
                    let wallpaperResponse = try JSONDecoder().decode(WallpaperResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.wallpapers = wallpaperResponse.images
                    }
                } catch {
                    print("JSON Decoding Error.")
                }
                completion(error)
            }
        }
        task.resume()
    }
}
