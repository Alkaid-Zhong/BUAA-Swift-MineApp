//
//  ActionBarView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

let ActionBarHeight: CGFloat = 25

struct ActionBarView: View {
    
    @ObservedObject var info: GameInfo
    
    @State var HPpercent: CGFloat = 1
    @State var ToolPercent: CGFloat = 1
    @State var ExperienctPercent: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: 0xCCD2CC, alpha: 0.5), Color(hex: 0xDBD2C9, alpha: 0.5)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            // HP
            VStack(spacing: 0) {
                HStack {
                    GeometryReader{ proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .frame(width: proxy.size.width, height: ActionBarHeight)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(HPpercent <= 0.3 ? lightRed : HPpercent <= 0.6 ? lightOrange : lightGreen)
                                .frame(width: proxy.size.width * HPpercent, height: ActionBarHeight)
                                .onChange(of: info.HP) {
                                    withAnimation {
                                        HPpercent = CGFloat(Float(info.HP) / Float(info.MaxHP))
                                    }
                                }
                        }
                        .overlay {
                            Text("HP: \(info.HP) / \(info.MaxHP)")
                                .bold()
                        }
                    }
                }
                .padding(10)
                HStack {
                    // tools
                    GeometryReader{ proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .frame(width: proxy.size.width, height: ActionBarHeight)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ToolPercent <= 0.3 ? lightRed : ToolPercent <= 0.6 ? lightOrange : lightGreen)
                                .frame(width:proxy.size.width * ToolPercent, height: ActionBarHeight)
                                .onChange(of: info.numberOfTools) {
                                    withAnimation {
                                        ToolPercent = min(1, CGFloat(Float(info.numberOfTools) / Float(info.MaxTools)))
                                    }
                                }
                        }
                        .overlay {
                            Text("Tools: \(info.numberOfTools)")
                                .bold()
                        }
                    }
                    // exp
                    GeometryReader{ proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .frame(width: proxy.size.width, height: ActionBarHeight)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(lightYellow)
                                .frame(width:proxy.size.width * ExperienctPercent, height: ActionBarHeight)
                                .onChange(of: info.experience) {
                                    withAnimation {
                                        ExperienctPercent = CGFloat(Float(info.experience) / Float(info.MaxExperience))
                                    }
                                }
                        }
                        .overlay {
                            Text("Exp: \(info.experience)")
                                .bold()
                        }
                    }
                }
                .padding(10)
            }
        }
        .frame(height: 90)
        .onAppear {
            HPpercent = CGFloat(Float(info.HP) / Float(info.MaxHP))
            ToolPercent = CGFloat(Float(info.numberOfTools) / Float(info.MaxTools))
            ExperienctPercent = CGFloat(Float(info.experience) / Float(info.MaxExperience))
        }
    }
    
}

struct testActionBarView: View {
    @ObservedObject var info = GameInfo()
    var body: some View {
        ActionBarView(info: info)
        Stepper("HP", value: $info.HP)
        Stepper("Tools", value: $info.numberOfTools)
        Stepper("Exp", value: $info.experience)
    }
}

#Preview {
    testActionBarView()
}
