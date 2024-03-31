//
//  ViewSettingView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

struct cellItem {
    var id: UUID = UUID()
    var cellSEvent: CellEvent
}

struct cellH {
    var id: UUID = UUID()
    var cellH: [cellItem]
}

let MaxCellSize: Float = 60

struct ViewSettingView: View {
    
    @State var cellSize: Float = 50
    @State var CellSizePercent: Float = 0.6
    
    @State var maxCell: Int = 7
    @ObservedObject var mainInfo: GameInfo
    
    @State var grid: [[CellEvent]] = [[]]
    
    var info = GameInfo()
    
    @State var notAutoCellSize: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 1, green: 250/255, blue: 240/255)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                if notAutoCellSize {
                    VStack(spacing: 0) {
                        ForEach(0..<grid.count, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<grid[row].count, id: \.self) { column in
                                    if(grid[row][column] == .Bomb) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(lightRed)
                                            .frame(width: CGFloat(cellSize), height: CGFloat(cellSize))
                                            .padding(2)
                                    }
                                    else {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(lightGreen)
                                            .frame(width: CGFloat(cellSize), height: CGFloat(cellSize))
                                            .padding(2)
                                    }
                                }
                            }
                        }
                    }
                    .padding(5)
                }
                else {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            VStack (spacing: 1) {
                                ForEach(0..<mainInfo.rows, id: \.self) { row in
                                    HStack (spacing: 1){
                                        ForEach(0..<mainInfo.columns, id: \.self) { column in
                                            if(mainInfo.eventArray[Int.random(in: 0..<mainInfo.rows)][Int.random(in: 0..<mainInfo.columns)] == .Bomb) {
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
                }
                
                Spacer()
                
                if !mainInfo.autoCellSize {
                    Text("使用手动单元格宽度需要自行滑动地图")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                
                RegtangleSliderView(actualProgress: $CellSizePercent, enable: $notAutoCellSize, enableVis: !mainInfo.autoCellSize, minProgress: 0.6)
                    .overlay() {
                        if !mainInfo.autoCellSize {
                            Text("单元格宽度：\(Int(CellSize))")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        else {
                            Text("使用自动单元格宽度")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                    }
                    .onChange(of: CellSizePercent) {
                        CellSize = MaxCellSize * CellSizePercent
                        cellSize = CellSize
                        info.initializeMines()
                        maxCell = Int(width / (CGFloat(CellSize) + 4)) - 1
                        grid.removeAll()
                        for i in 0..<maxCell {
                            var newLine: [CellEvent] = [CellEvent]()
                            for j in 0..<maxCell {
                                newLine.append(info.eventArray[i][j])
                            }
                            grid.append(newLine)
                        }
                    }
                    .padding(10)
                HStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(!mainInfo.autoCellSize ? lightBlue : .gray)
                        .frame(width: (width - 36) / 2, height: 32)
                        .overlay() {
                            Text("手动宽度")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .onTapGesture {
                            withAnimation {
                                mainInfo.autoCellSize = false
                                notAutoCellSize = !mainInfo.autoCellSize
                            }
                        }
                    RoundedRectangle(cornerRadius: 15)
                        .fill(mainInfo.autoCellSize ? lightGreen : .gray)
                        .frame(width: (width - 36) / 2, height: 32)
                        .overlay() {
                            Text("自动宽度")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .onTapGesture {
                            withAnimation {
                                mainInfo.autoCellSize = true
                                notAutoCellSize = !mainInfo.autoCellSize
                            }
                        }
                }
                .padding(10)
            }
        }
        .navigationTitle("Cell Settings")
        .onAppear {
            notAutoCellSize = !mainInfo.autoCellSize
            CellSize = 50 * CellSizePercent
            cellSize = CellSize
            maxCell = Int(width / (CGFloat(CellSize) + 4)) - 1
            info.initializeMines()
            grid.removeAll()
            for i in 0..<maxCell {
                var newLine: [CellEvent] = [CellEvent]()
                for j in 0..<maxCell {
                    newLine.append(info.eventArray[i][j])
                }
                grid.append(newLine)
            }
        }
    }
}

struct testViewSetting: View {
    @ObservedObject var info = GameInfo(columns: 15)
    var body: some View {
        ViewSettingView(mainInfo: info)
    }
}

#Preview {
    testViewSetting()
}
