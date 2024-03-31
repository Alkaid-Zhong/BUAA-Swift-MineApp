//
//  StartView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

let backGroundWhite = Color(red: 1, green: 250/255, blue: 240/255)

struct StartView: View {
    @ObservedObject var info: GameInfo
    var records: [Records]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 250/255, blue: 240/255)
                    .ignoresSafeArea()
                VStack {
                    Text("Mine")
                        .font(.custom("Luminari", size: 100))
                    if info.gameStarted {
                        NavigationLink(destination: GameView(info: info)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(lightRed)
                                    .frame(width: 282, height: 80)
                                HStack {
                                    Text("Continue")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                        .bold()
                                    Image(systemName: "forward.frame.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(7)
                        }
                    }
                    NavigationLink(destination: GameView(info: info).onAppear{
                        withAnimation {
                            info.gameStarted = true
                        }
                        info.HP = info.MaxHP
                        info.numberOfTools = info.MaxTools
                        info.experience = 0
                        info.sightRange = 1
                        info.initializeMines()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(lightRed)
                                .frame(width: 282, height: 80)
                            HStack {
                                Text("New Game")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .bold()
                                Image(systemName: "play.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                    }
                    
                    HStack {
                        NavigationLink(destination: SettingView(info: info).onAppear{
                            withAnimation {
                                info.gameStarted = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(lightRed)
                                    .frame(width: 80, height: 80)
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(7)
                        NavigationLink(destination: HelpView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(lightRed)
                                    .frame(width: 80, height: 80)
                                Image(systemName: "questionmark.app")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(7)
                        NavigationLink(destination: RecordView(records: records)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(lightRed)
                                    .frame(width: 80, height: 80)
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(7)
                    }
                }
            }
        }
    }
}

struct testStartView: View {
    @ObservedObject var info = GameInfo(gameStarted: true)
    var body: some View {
        StartView(info: info, records: [])
    }
}

#Preview {
    testStartView()
}
