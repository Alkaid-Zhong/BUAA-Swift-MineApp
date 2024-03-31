//
//  GameView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

let BGEcolor = Color(red: 255/255, green: 250/255, blue: 240/255)

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var info: GameInfo
    @State var eventTiggered: CellEvent = .None
    
    @State var selectionActionShow: Bool = false
    
    @State var showEventView = false
    @State var showNewSpace = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 255/255, green: 250/255, blue: 240/255)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    MapView(info: info, eventTiggered: $eventTiggered, rows: $info.rows, columns: $info.columns)
                        .onChange(of: eventTiggered) {
                            switch eventTiggered {
                            case .None:
                                break
                            case .Bomb:
                                break
                            case .Gift:
                                showEventView = true
                            case .NewSpace:
                                showNewSpace = true
                            case .CheckedBomb:
                                break
                            }
                        }
                        .fullScreenCover(isPresented: $showEventView, onDismiss: {
                            showEventView = false
                            eventTiggered = .None
                        }) {
                            EventView(info: info)
                        }
                        .fullScreenCover(isPresented: $showNewSpace, onDismiss: {
                            showNewSpace = false
                            eventTiggered = .None
                        }) {
                            NewSpaceView(info: info, lucknum: Int.random(in: 0..<9))
                        }
                    if info.HP > 0 || !info.win {
                        ActionBarView(info: info)
                            .onChange(of: info.experience) {
                                if info.experience >= info.MaxExperience {
                                    info.experience -= info.MaxExperience
                                    eventTiggered = .Gift
                                }
                            }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                MyBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: HelpView()) {
                    Image(systemName: "questionmark.app")
                        .foregroundColor(.black)
                        .offset(y: 1)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ViewSettingView(mainInfo: info)
                    .navigationBarBackButtonHidden()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            MyBackButton()
                        }
                    }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
    }
}

struct testGameView: View {
    var info = GameInfo()
    var body: some View {
        GameView(info: info)
            .onAppear {
                info.rows = 15
                info.columns = 15
                info.initializeMines()
                info.autoCellSize = false
            }
    }
}

#Preview {
    testGameView()
}
