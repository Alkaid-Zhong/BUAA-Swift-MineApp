//
//  EventView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import SwiftUI

enum Gift {
    case HP
    case sight
    case tool
}

struct EventView: View {
    
    @ObservedObject var info: GameInfo
    
    @State var choose: Int? = nil
    @State var chooseGift: Gift? = nil
    
    var gifts: [Gift] = [.HP, .sight, .tool]
    
    func getState(gift: Gift) -> (name: String, color: Color, sysName: String, text: String) {
        switch gift {
        case .HP:
            return ("HP", lightRed, "heart.fill", "+1")
        case .sight:
            return ("EyeSight", lightBlue, "eye.fill", "+1")
        case .tool:
            return ("Tools", lightBrown, "waveform.badge.magnifyingglass", "+1")
        }
    }
    
    func getData(gift: Gift) -> (nowData: Int, newData: Int, maxData: Int) {
        switch gift {
        case .HP:
            return (info.HP, min(info.HP + 1, info.MaxHP), info.MaxHP)
        case .sight:
            return (info.sightRange, info.sightRange + 1, info.sightRange + 1)
        case .tool:
            return (info.numberOfTools, min(info.numberOfTools + 1, info.MaxTools), info.MaxTools)
        }
    }
    
    var body: some View {
        ZStack {
            backGroundWhite
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Gift")
                    .font(.custom("Luminari", size: 100))
                HStack(spacing: 30) {
                    ForEach(0..<gifts.count, id: \.self) { index in
                        VStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(getState(gift: gifts[index]).color)
                                .frame(width: choose == index ? 100 : 80, height: choose == index ? 100 : 80)
                                .overlay {
                                    VStack(spacing: 0) {
                                        Image(systemName: getState(gift: gifts[index]).sysName)
                                            .font(.title)
                                            .foregroundColor(.white)
                                        Text(getState(gift:gifts[index]).text)
                                            .font(.custom("Luminari", size: 20))
                                            .bold()
                                            .foregroundStyle(.white)
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        choose = index
                                        chooseGift = gifts[index]
                                    }
                                }
                        }
                    }
                }
                Spacer()
                if chooseGift != nil {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray.opacity(0.4))
                            .frame(width: 300, height: 25)
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.green)
                            .frame(width: 300 * CGFloat((Float(getData(gift: chooseGift!).newData) / Float(getData(gift: chooseGift!).maxData))), height: 25)
                        RoundedRectangle(cornerRadius: 15)
                            .fill(lightGreen)
                            .frame(width: 300 * CGFloat((Float(getData(gift: chooseGift!).nowData) / Float(getData(gift: chooseGift!).maxData))), height: 25)
                    }
                    .overlay {
                        HStack {
                            Text("\(getState(gift: chooseGift!).name): \(getData(gift: chooseGift!).nowData)")
                                .bold()
                            Image(systemName: "arrowshape.right.fill")
                                .font(.system(size: 12))
                            Text("\(getData(gift: chooseGift!).newData)")
                                .bold()
                        }
                    }
                }
                HStack {
                    DIYBackButton (action: {
                        switch chooseGift {
                        case .HP:
                            info.HP = min(info.MaxHP, info.HP + 1)
                        case .sight:
                            info.sightRange += 1
                            info.refreshState()
                        case .tool:
                            info.numberOfTools = min(info.MaxTools, info.numberOfTools + 1)
                        case nil:
                            break;
                        }
                    }){
                        Text("Choose")
                            .font(.custom("Luminari", size: 30))
                            .bold()
                    }
                }
            }
        }
    }
}

struct testEventView: View {
    var body: some View {
        EventView(info: GameInfo(HP: 3, numberOfTools: 10))
    }
}

#Preview {
    testEventView()
}
