//
//  SettingView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var info: GameInfo
    
    var body: some View {
        TabView {
            MapSettingView(info: info)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(0)
//            Text("Event")
//                .tabItem {
//                    Image(systemName: "list.clipboard")
//                    Text("Event")
//                }
//                .tag(1)
            PlayerSettingView(info: info)
                .tabItem {
                    Image(systemName: "person")
                    Text("Player")
                }
                .tag(2)
            ViewSettingView(mainInfo: info)
                .tabItem {
                    Image(systemName: "aspectratio")
                    Text("View")
                }
                .tag(3)
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                MyBackButton()
            }
        }
    }
}

struct testSettingView: View {
    @ObservedObject var info = GameInfo()
    var body: some View {
        SettingView(info: info)
    }
}

#Preview {
    testSettingView()
}
