//
//  ContentView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/13.
//

import SwiftUI
import SwiftData

enum NowView {
    case start
    case setting
    case game
    case gameOver
    case win
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var records: [Records]
    
    @ObservedObject var info = GameInfo()
    
    @State var nowView: NowView = .start
    
    @State var gameOver = false
    @State var win = false
    
    var body: some View {
        VStack {
            StartView(info: info, records: records)
                .onChange(of: info.HP) {
                    if info.HP == 0 {
                        gameOver = true
                        info.gameStarted = false
                    }
                }
                .onChange(of: info.win) {
                    print("win")
                    win = info.win
                    info.gameStarted = false
                }
                .fullScreenCover(isPresented: $gameOver, onDismiss: {
                    for i in 0..<info.rows {
                        for j in 0..<info.columns {
                            info.stateArray[i][j] = .Show
                        }
                    }
                }) {
                    ZStack {
                        backGroundWhite
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            Text("Game Over")
                                .font(.custom("Luminari", size: 50))
                                .padding(40)
                            let (count, bomb, last) = info.countMine()
                            let score = getScore(count: count, bomb: bomb, last: last)
                            Text("得分:\(score)")
                                .font(.title2)
                                .bold()
                                .padding(10)
                            Text("排雷:\(count)")
                                .font(.title2)
                                .bold()
                                .padding(10)
                            Text("触雷:\(bomb)")
                                .font(.title2)
                                .bold()
                                .padding(10)
                            Text("剩余:\(last)")
                                .font(.title2)
                                .bold()
                                .padding(10)
                            Spacer()
                            HStack {
                                DIYBackButton {
                                    HStack {
                                        MyBackButton()
                                        Text("Back")
                                            .bold()
                                            .font(.title2)
                                    }
                                }
                            }
                        }
                    }
                }.fullScreenCover(isPresented: $win, onDismiss: {
                    for i in 0..<info.rows {
                        for j in 0..<info.columns {
                            info.stateArray[i][j] = .Show
                        }
                    }
                }) {
                    ZStack {
                        backGroundWhite
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            Text("Win")
                                .font(.custom("Luminari", size: 50))
                                .padding(40)
                            let (count, bomb, last) = info.countMine()
                            let score = getScore(count: count, bomb: bomb, last: last)
                            Text("得分:\(score)")
                                .font(.title2)
                                .bold()
                                .padding(10)
                            Text("排雷:\(count)")
                                .font(.title2)
                                .bold()
                                .padding(10)
                            Text("触雷:\(bomb)")
                                .font(.title2)
                                .bold()
                                .padding(10)
                            Spacer()
                            HStack {
                                DIYBackButton {
                                    HStack {
                                        MyBackButton()
                                        Text("Back")
                                            .bold()
                                            .font(.title2)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        let (count, bomb, last) = info.countMine()
                        let score = getScore(count: count, bomb: bomb, last: last)
                        addRecord(score: score, username: "Sam")
                    }
                }
        }
    }
    private func addRecord(score: Int, username: String) {
        withAnimation {
            let newRecord = Records(score: score, username: username)
            modelContext.insert(newRecord)
        }
    }
    private func getScore(count: Int, bomb: Int, last: Int) -> Int {
        return 500 + max(-400, (count * 100 - bomb * 100 - last * 10))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Records.self, inMemory: true)
}
