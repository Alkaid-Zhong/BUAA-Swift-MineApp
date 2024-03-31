//
//  HelpView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/29.
//

import SwiftUI

struct HelpView: View {
    
    @State var tap1 = false
    @State var tap21 = false
    @State var tap22 = false
    @State var tap23 = false
    @State var tap3 = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BGEcolor
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        VStack(spacing: 10) {
                            HStack {
                                Spacer()
                                VStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(normalGray)
                                        .frame(width: 50, height: 50)
                                    Text("**不可达**格子")
                                    Text("**不能**被点击")
                                    Text("信息**被隐藏**")
                                }
                                Spacer()
                                VStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(tap1 ? lightGreen : lightBrown)
                                        .frame(width: 50, height: 50)
                                        .onTapGesture {
                                            withAnimation {
                                                tap1 = true
                                            }
                                        }
                                    Text("**可达**格子")
                                    Text("**可以**被点击")
                                    Text("信息**被隐藏**")
                                }
                                Spacer()
                            }
                            if !tap1 {
                                Text("点点试试吧")
                                    .font(.title)
                                    .padding(10)
                            }
                        }
                        .padding(3)
                        if (tap1) {
                            Divider()
                                .frame(height: 20)
                            VStack(spacing: 10) {
                                HStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(tap21 ? lightGreen : lightBrown)
                                        .frame(width: 50, height: 50)
                                        .onTapGesture {
                                            withAnimation {
                                                tap21 = true
                                            }
                                        }
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(tap22 ? lightRed : lightBrown)
                                        .frame(width: 50, height: 50)
                                        .overlay {
                                            if(tap22) {
                                                Image(systemName: "exclamationmark.triangle")
                                            }
                                        }
                                        .onTapGesture {
                                            withAnimation {
                                                tap22 = true
                                            }
                                        }
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(tap23 ? lightGreen : lightBrown)
                                        .frame(width: 50, height: 50)
                                        .overlay {
                                            if(tap23) {
                                                Text("1")
                                                    .bold()
                                            }
                                        }
                                        .onTapGesture {
                                            withAnimation {
                                                tap23 = true
                                            }
                                        }
                                    Spacer()
                                }
                                Text("**可达**格子被点击时，会**直接翻开**，触发其中事件")
                                if !(tap21 && tap22 && tap23) {
                                    Text("都点点试试吧")
                                }
                                if (tap21 && tap22 && tap23) {
                                    Text("不过**直接翻开**带有雷的格子是很危险的")
                                    Text("还好被翻开的**安全格子**会显示周围雷数")
                                }
                            }
                            .padding(3)
                        }
                        if tap21 && tap22 && tap23 {
                            Divider()
                                .frame(height: 20)
                            VStack(spacing: 10) {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 10) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(lightRed)
                                            .overlay {
                                                Image(systemName: "exclamationmark.triangle")
                                            }
                                            .frame(width: 50, height: 50)
                                        Text("被**直接触发**的雷格")
                                        Text("**不会**显示任何信息")
                                    }
                                    Spacer()
                                    VStack(spacing: 10) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(tap3 ? lightBlue : lightBrown)
                                            .frame(width: 50, height: 50)
                                            .overlay {
                                                if tap3 {
                                                    Text("3")
                                                        .bold()
                                                }
                                            }
                                            .onLongPressGesture {
                                                withAnimation {
                                                    tap3 = true
                                                }
                                            }
                                        if !tap3 {
                                            Text("已知这个格子**有雷**")
                                            Text("**长按**试试吧")
                                        }
                                        else {
                                            Text("长按可以使用**工具**")
                                            Text("翻开**任意**格子")
                                        }
                                    }
                                    Spacer()
                                }
                                if tap3 {
                                    Text("没有雷的格子效果和点击**一样**")
                                    Text("使用**工具**翻开有雷的格子**也会**显示周围的雷数")
                                    Text("但是工具不足的时候是**没法排雷**的哦")
                                        .font(.title3)
                                }
                            }
                            .padding(3)
                        }
                        if tap3 {
                            Divider()
                                .frame(height: 20)
                            HStack {
                                VStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.yellow)
                                        .frame(width: 50, height: 50)
                                    Text("奖励格子")
                                    Text("里面会随机生成")
                                    Text("三个不同的奖励")
                                }
                                VStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.purple)
                                        .frame(width: 50, height: 50)
                                    Text("抽奖格子")
                                    Text("可以抽奖")
                                    Text("也可能一无所获")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Help")
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                MyBackButton()
            }
        }
        
    }
}

#Preview {
    HelpView()
}
