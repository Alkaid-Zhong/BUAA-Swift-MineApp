//
//  MapView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI


struct MapView: View {
    @ObservedObject var info: GameInfo
    
    @Binding var eventTiggered: CellEvent
    
    @State private var nowPosition = CGSize.zero
    @State private var dragOffset = CGSize.zero
    @State private var tapPosition = CGSize.zero
    
    @Binding var rows: Int
    @Binding var columns: Int
    
    @State var grid: [[CellEvent]] = [[]]
    
    func tapGesture(i: Int, j: Int) {
        if info.HP <= 0 {
            return
        }
        if info.stateArray[i][j] == .Show {
            if info.eventArray[i][j] == .Gift {
                eventTiggered = info.eventArray[i][j]
                info.eventArray[i][j] = .None
                print("\((i, j))")
            }
            if info.eventArray[i][j] == .NewSpace {
                eventTiggered = info.eventArray[i][j]
                info.eventArray[i][j] = .None
                print("\((i, j))")
            }
        }
        if(info.stateArray[i][j] != .Visible) {
            return
        }
        if(info.eventArray[i][j] == .Bomb) {
            info.HP -= 1
        }
        info.stateArray[i][j] = .Show
        info.refreshState(x: i, y: j)
        info.checkWin()
    }
    func longPressGesture(i: Int, j: Int) {
        if info.HP <= 0 {
            return
        }
        if(info.stateArray[i][j] != .Visible || info.numberOfTools == 0) {
            return
        }
        info.numberOfTools -= 1
        info.stateArray[i][j] = .Show
        info.refreshState(x: i, y: j)
        if(info.eventArray[i][j] == .Bomb) {
            info.eventArray[i][j] = .CheckedBomb
            info.experience += 1
        }
        info.checkWin()
    }
    func gridRefresh() {
        grid.removeAll()
        for i in 0..<info.eventArray.count {
            var newLine: [CellEvent] = [CellEvent]()
            for j in 0..<info.eventArray[i].count {
                newLine.append(info.eventArray[i][j])
            }
            grid.append(newLine)
        }
    }
    
    var body: some View {
        if info.autoCellSize {
            GeometryReader { geometry in
                let gW = min(geometry.size.width, geometry.size.height * CGFloat((Float(info.columns)/Float(info.rows))))
                let gH = min(geometry.size.height, (geometry.size.width) * CGFloat((Float(info.rows)/Float(info.columns))))
                VStack(spacing: 0) {
                    ForEach(0..<grid.count, id: \.self) { i in
                        HStack(spacing: 0) {
                            ForEach(0..<grid[i].count, id: \.self) { j in
                                ZStack {
                                    CellView(cellText: info.getText(x: i, y: j),
                                             cellEvent: $info.eventArray[i][j],
                                             cellState: $info.stateArray[i][j],
                                             autoCellSize: true
                                    )
                                    .onTapGesture {
                                        tapGesture(i: i, j: j)
                                    }
                                    .gesture(
                                        LongPressGesture(minimumDuration: 0.2)
                                            .onEnded {_ in
                                                longPressGesture(i: i, j: j)
                                            }
                                    )
                                }
                                .padding(1)
                            }
                        }
                    }
                }
                .frame(width: gW, height: gH)
                .offset(x: gW < geometry.size.width ? (geometry.size.width - gW) / 2 : 0,
                        y: gH < geometry.size.height ? (geometry.size.height - gH) / 2 : 0)
            }
            .onAppear {
                gridRefresh()
            }
        }
        else {
            ScrollView() {
                ScrollView(.horizontal) {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<grid.count, id: \.self) { i in
                            LazyHStack(spacing: 0) {
                                ForEach(0..<grid[i].count, id: \.self) { j in
                                    ZStack {
                                        CellView(cellText: info.getText(x: i, y: j),
                                                 cellEvent: $info.eventArray[i][j],
                                                 cellState: $info.stateArray[i][j],
                                                 autoCellSize: false
                                        )
                                        .onTapGesture {
                                            tapGesture(i: i, j: j)
                                        }
                                        .gesture(
                                            LongPressGesture(minimumDuration: 0.2)
                                                .onEnded {_ in
                                                    longPressGesture(i: i, j: j)
                                                }
                                        )
                                    }
                                    .padding(2)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                gridRefresh()
            }
        }
    }
}

struct TestMapView: View {
    @ObservedObject var info = GameInfo(rows: 10, columns: 10)
    @State var event: CellEvent = .None
    var body: some View {
        MapView(info: info, eventTiggered: $event, rows: $info.rows, columns: $info.columns)
            .onAppear {
                info.autoCellSize = true
            }
    }
}

#Preview {
    TestMapView()
}
