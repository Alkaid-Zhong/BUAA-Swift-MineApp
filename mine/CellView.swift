//
//  CellView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 8) & 0xff) / 255,
            B: Double((hex >> 0) & 0xff) / 255
        )
        self.init(red: components.R, 
                  green: components.G,
                  blue: components.B,
                  opacity: alpha)
    }
}

var CellSize: Float = 50.0
//var autoCellSize: Bool = true

let normalGray = Color.gray//Color(hex: 0xab9796)
let lightBrown = Color(red: 181/255, green: 162/255, blue: 131/255)
let lightRed = Color(hex: 0xff7675)
let lightGreen = Color(hex: 0x55efc4)
let lightBlue = Color(hex: 0x74b9ff)
let lightOrange = Color(hex: 0xDDAB77)
let lightYellow = Color(hex: 0xF4E8C0)

struct CellView: View {
    var id: UUID = UUID()
    
    @State var cellText: String
    @Binding var cellEvent: CellEvent
    @Binding var cellState: CellState
    
    @State var color: Color = normalGray
    
    @State var autoCellSize: Bool
    
    var body: some View {
        if autoCellSize {
            GeometryReader { geometry in
                ZStack {
                    if(cellState == .Hidden || cellState == .Visible) {
                        RoundedRectangle(cornerRadius: 5) // 底部矩形
                            .fill(cellColor())
                            .aspectRatio(1, contentMode: .fit)
                    }
                    else {
                        RoundedRectangle(cornerRadius: 5) // 底部矩形
                            .fill(cellColor())
                            .aspectRatio(1, contentMode: .fit)
                            .hidden()
                    }
                    
                    RoundedRectangle(cornerRadius: 5)
                        .onAppear() {
                            color = cellColor()
                        }
                        .onChange(of: cellState) {
                            withAnimation {
                                color = cellColor()
                            }
                        }
                        .onChange(of: cellEvent) {
                            withAnimation {
                                color = cellColor()
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(color)
                    if cellState == .Show && cellEvent != .Bomb {
                        Text(cellText)
                            .bold()
                    }
                    else if (cellState == .Show && cellEvent == .Bomb) {
                        Image(systemName: "exclamationmark.triangle")
                    }
                }
            }
        }
        else {
            ZStack {
                if(cellState == .Hidden || cellState == .Visible) {
                    RoundedRectangle(cornerRadius: 5) // 底部矩形
                        .fill(cellColor())
                        .frame(width: CGFloat(CellSize) + 2, height: CGFloat(CellSize) + 2)
                        .aspectRatio(1, contentMode: .fit)
                }
                else {
                    RoundedRectangle(cornerRadius: 5) // 底部矩形
                        .fill(cellColor())
                        .frame(width: CGFloat(CellSize) + 2, height: CGFloat(CellSize) + 2)
                        .aspectRatio(1, contentMode: .fit)
                        .hidden()
                }
                
                RoundedRectangle(cornerRadius: 5)
                    .onAppear() {
                        color = cellColor()
                    }
                    .onChange(of: cellState) {
                        withAnimation {
                            color = cellColor()
                        }
                    }
                    .frame(width: CGFloat(CellSize), height: CGFloat(CellSize))
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(color)
                if cellState == .Show && cellEvent != .Bomb {
                    Text(cellText)
                        .frame(width: CGFloat(CellSize), height: CGFloat(CellSize))
                        .bold()
                }
                else if (cellState == .Show && cellEvent == .Bomb) {
                    Image(systemName: "exclamationmark.triangle")
                        .frame(width: CGFloat(CellSize), height: CGFloat(CellSize))
                }
            }
        }
    }
    
    func cellColor() -> Color {
        
        switch cellState {
        case .Hidden:
            return normalGray
        case .Visible:
            return lightBrown
        case .Show:
            switch cellEvent {
            case .None:
                return lightGreen
            case .Bomb:
                return lightRed
            case .Gift:
                return .yellow
            case .NewSpace:
                return .purple
            case .CheckedBomb:
                return lightBlue
            }
        }
    }
}

struct TestCellView: View {
    @State var cevent: CellEvent = .Bomb
    @State var cstate: CellState = .Visible
    var body: some View {
        CellView(cellText: "", cellEvent: $cevent, cellState: $cstate, autoCellSize: false)
        CellView(cellText: "", cellEvent: .constant(.None), cellState: $cstate, autoCellSize: false)
        CellView(cellText: "", cellEvent: .constant(.CheckedBomb), cellState: .constant(.Show), autoCellSize: false)
        CellView(cellText: "", cellEvent: .constant(.Gift), cellState: $cstate, autoCellSize: false)
        Button("Test") {
            if cstate == .Show {
                cstate = .Hidden
            }
            else {
                cstate = .Show
            }
        }
    }
}

#Preview {
    TestCellView()
}
