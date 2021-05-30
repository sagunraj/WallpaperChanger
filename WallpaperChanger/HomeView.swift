//
//  ContentView.swift
//  WallpaperChanger
//
//  Created by Sagun Raj Lage on 28/05/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @ObservedObject var wcViewModel = WallpaperChangerViewModel()
    @State var isAlertShown = false
    @State var alertInfo = (title: "", message: "")
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing,
                                    vertical: .bottom)) {
            WebImage(url: wcViewModel.wallpapers[0].fullUrl)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
            VStack(alignment: .trailing) {
                Button(action: {
                    wcViewModel.saveAndSetWallpaper(with: wcViewModel.wallpapers[0].fullUrl) { error, isSuccessful in
                        handleAlert(with: error, and: isSuccessful)
                    }
                }, label: {
                    Text("Set as wallpaper")
                }).background(Color.blue).padding()
                Spacer()
                VStack(alignment: .trailing) {
                    Text(wcViewModel.wallpapers[0].title)
                        .font(.title)
                        .padding([.trailing], 8)
                    Text(wcViewModel.wallpapers[0].copyright)
                        .font(.caption2)
                        .multilineTextAlignment(.trailing)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                }
                .background(Color.black.opacity(0.4))
            }
        }
        .frame(minWidth: 800, minHeight: 300)
        .alert(isPresented: $isAlertShown, content: {
                Alert(title: Text(alertInfo.title),
                      message: Text(alertInfo.message),
                      dismissButton: .default(Text("OK")))}
        )
        .onAppear(perform: {
            wcViewModel.fetchWallpaper { error in
                handleAlert(with: error)
            }
        })
    }
    
    func handleAlert(with errorData: Error?, and success: Bool = false) {
        if success {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alertInfo = ("Wallpaper set!", "Cheers! You now have a new wallpaper.")
                isAlertShown = success
            }
        }
        guard let errorData = errorData else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertInfo = ("", "")
                isAlertShown = false
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alertInfo = ("A problem has occurred", errorData.localizedDescription)
            isAlertShown = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
