//
//  Library.swift
//  Music Player
//
//  Created by Saidaxmad on 02/10/22.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                GeometryReader { geometry in
                    HStack(spacing: 10) {
                        Button(action: {
                            print("777")
                        },
                               label: {
                            Image(systemName: "play.fill")
                                .frame(width: 185, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                                .background(Color.init(UIColor.systemGray6.cgColor)).cornerRadius(10)
                        })
                        Button(action: {
                            print("444")
                        },
                               label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: 185, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                                .background(Color.init(UIColor.systemGray6.cgColor)).cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                List {
                    LibraryCell()
                }
            }
            
            .navigationBarTitle("Library")
        }
        
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("search").resizable().frame(width: 60, height: 60).cornerRadius(10)
            VStack {
                Text("Track Name")
                Text("Artist Name")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
