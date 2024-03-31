//
//  PlayerSettingView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

struct PlayerSettingView: View {
    @ObservedObject var info: GameInfo
    
    @State var HPpercent: Float = 0.1
    @State var SightPercent: Float = 0.1
    
    var body: some View {
        ZStack {
            Color(red: 1, green: 250/255, blue: 240/255)
                .ignoresSafeArea()
            VStack {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        VStack (spacing: 1) {
                            ForEach(0..<info.rows, id: \.self) { row in
                                HStack (spacing: 1){
                                    ForEach(0..<info.columns, id: \.self) { column in
                                        if(info.eventArray[row][column] == .Bomb) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(lightRed)
                                            //.frame(maxWidth: 20, maxHeight: 20)
                                                .aspectRatio(1, contentMode: .fit)
                                        }
                                        else {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(lightGreen)
                                            //.frame(maxWidth: 20, maxHeight: 20)
                                                .aspectRatio(1, contentMode: .fit)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width - 10)
                        Text("地雷数量：\(info.numberOfMines)")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(10)
                        Spacer()
                    }
                    .padding(5)
                }
                
                RegtangleSliderView(actualProgress: $HPpercent, enable: .constant(true), minProgress: 0.1)
                    .overlay() {
                        Text("最大HP：\(info.MaxHP)")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .onChange(of: HPpercent) {
                        info.MaxHP = Int(Float(info.numberOfMines) * HPpercent)
                        info.initializeMines()
                    }
                    .padding(10)
                RegtangleSliderView(actualProgress: $SightPercent, enable: .constant(true), minProgress: 0.1)
                    .overlay() {
                        Text("初始视野：\(info.sightRange)")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .onChange(of: SightPercent) {
                        info.sightRange = Int(SightPercent * 10)
                        info.initializeMines()
                    }
                    .padding(10)
            }
        }
    }
}
struct testPlayerSettingView: View {
    @ObservedObject var info: GameInfo = GameInfo()
    
    var body: some View {
        PlayerSettingView(info: info)
    }
}

#Preview {
    testPlayerSettingView()
}
