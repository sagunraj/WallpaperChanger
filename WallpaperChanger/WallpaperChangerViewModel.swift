//
//  ViewModel.swift
//  WallpaperChanger
//
//  Created by Sagun Raj Lage on 30/05/2021.
//

import Foundation
import AppKit

class WallpaperChangerViewModel: ObservableObject {
    @Published var wallpapers: [WallpaperImage] = [WallpaperImage(startDate: "", url: "", copyright: "", copyrightLink: "", title: "", quiz: "")]
    
    /// Fetches the wallpaper by performing API call.
    /// - Parameter days: Defines how many days old wallpaper you would like to get.
    func fetchWallpaper(before days: Int = 6, of location: String = "en-US", completion: @escaping (Error?) -> Void) {
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
                    print(error.localizedDescription)
                }
                completion(error)
            }
        }
        task.resume()
    }
    
    func saveAndSetWallpaper(with url: URL?, completion: @escaping (Error?, Bool) -> Void) {
        guard let url = url else { return }
        let task = URLSession.shared.downloadTask(with: url) { urlOrNil, responseOrNil, errorOrNil in
            if errorOrNil == nil {
                if let response = responseOrNil as? HTTPURLResponse, response.statusCode == 200 {
                    guard let fileURL = urlOrNil else { return }
                    do {
                        let fileManager = FileManager.default
                        let downloadsURL = try fileManager.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let folderURL = downloadsURL.appendingPathComponent("wallpaper-changer-files")
                        if fileManager.fileExists(atPath: folderURL.path) {
                            try fileManager.removeItem(at: folderURL)
                        }
                        try fileManager.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
                        let savedURL = folderURL.appendingPathComponent(fileURL.lastPathComponent)
                        try fileManager.moveItem(at: fileURL, to: savedURL)
                        self.setDesktopWallpaper(with: savedURL) { wallpaperSettingError, isSuccessful in
                            completion(wallpaperSettingError, isSuccessful)
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion(errorOrNil, false)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func setDesktopWallpaper(with savedURL: URL, completion: (Error?, Bool) -> Void) {
        do {
            let workspace = NSWorkspace.shared
            if let screen = NSScreen.main  {
                try workspace.setDesktopImageURL(savedURL, for: screen, options: [:])
                completion(nil, true)
            }
        } catch {
            print(error.localizedDescription)
            completion(error, false)
        }
    }
}
