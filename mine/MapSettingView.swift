//
//  MapSettingView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

struct MapSettingView: View {
    @ObservedObject var info: GameInfo
    
    @State var rowsPercent: Float = 0
    @State var columnsPercent: Float = 0
    @State var numberOfMinesPercent: Float = 0.13
    
    @State var selectedIndex = 0
    @State var selectedCustom = false
    let options = ["Simple", "Normal", "Hard", "Custom"]
    
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
                        Spacer()
                    }
                    .padding(5)
                }
                RegtangleSliderView(actualProgress: $rowsPercent, enable: $selectedCustom , minProgress: 0.25)
                    .overlay() {
                        Text("地图行数：\(info.rows)")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .onChange(of: rowsPercent) {
                        info.rows = Int(Float(MAX_ROWS) * rowsPercent)
                        info.numberOfMines = Int(numberOfMinesPercent * Float(info.columns * info.rows))
                        info.initializeMines()
                    }
                    .padding(10)
                RegtangleSliderView(actualProgress: $columnsPercent, enable: $selectedCustom , minProgress: 0.25)
                    .overlay() {
                        Text("地图列数：\(info.columns)")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .onChange(of: columnsPercent) {
                        info.columns = Int(Float(MAX_COLUMNS) * columnsPercent)
                        info.numberOfMines = Int(numberOfMinesPercent * Float(info.columns * info.rows))
                        info.initializeMines()
                    }
                    .padding(10)
                RegtangleSliderView(actualProgress: $numberOfMinesPercent, enable: $selectedCustom , minProgress: 0.1, maxProgress: 0.9)
                    .overlay() {
                        Text("地雷数量：\(info.numberOfMines)")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .onChange(of: numberOfMinesPercent) {
                        info.numberOfMines = Int(numberOfMinesPercent * Float(info.columns * info.rows))
                        info.initializeMines()
                    }
                    .padding(10)
                Picker("Options", selection: $selectedIndex) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Text(options[index]).tag(index)
                    }
                }
                .onChange(of: selectedIndex) {
                    switch selectedIndex {
                    case 0:
                        selectedCustom = false
                        info.columns = 10
                        info.rows = 10
                        info.numberOfMines = 20
                        columnsPercent = 0.25
                        rowsPercent = 0.25
                        numberOfMinesPercent = 0.2
                        info.initializeMines()
                    case 1:
                        selectedCustom = false
                        info.columns = 13
                        info.rows = 13
                        info.numberOfMines = 60
                        columnsPercent = 13/40.0
                        rowsPercent = 13/40.0
                        numberOfMinesPercent = 60.0/169
                        info.initializeMines()
                    case 2:
                        selectedCustom = false
                        info.columns = 15
                        info.rows = 15
                        info.numberOfMines = 130
                        columnsPercent = 15/40.0
                        rowsPercent = 15/40.0
                        numberOfMinesPercent = 130.5/225
                        info.initializeMines()
                    default:
                        selectedCustom = true
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
            }
        }
    }
}

struct testMapSettingView: View {
    @ObservedObject var info = GameInfo()
    var body: some View {
        MapSettingView(info: info)
    }
}

#Preview {
    testMapSettingView()
}
