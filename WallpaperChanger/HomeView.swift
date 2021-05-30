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
    @State var errorMessage = ""
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing,
                                    vertical: .bottom)) {
            WebImage(url: wcViewModel.wallpapers[0].fullUrl)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
            VStack(alignment: .trailing) {
                Button(action: {}, label: {
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
                Alert(title: Text("Error"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))}
        )
        .onAppear(perform: {
            wcViewModel.fetchWallpaper { error in
                handleErrorMessageAlert(with: error)
            }
        })
    }
    
    func handleErrorMessageAlert(with errorData: Error?) {
        guard let errorData = errorData else {
            isAlertShown = false
            errorMessage = ""
            return
        }
        isAlertShown = true
        errorMessage = errorData.localizedDescription
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
