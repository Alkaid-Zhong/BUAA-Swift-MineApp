//
//  NewSpaceView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/12/20.
//

import SwiftUI

struct FlipEffect: GeometryEffect {
    
    // SwiftUI 的动画就是通过时间函数操作 animatableData 变量，这里通过 getter setter 传递给给 angle 属性
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool  // 绑定卡片当前的状态
    
    var angle: Double  // 翻转角度变量
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270  // 根据当前的角度改变 flipped 的值
        }
        
        let a = CGFloat(Angle.degrees(angle).radians)
        
        var transform3d = CATransform3DIdentity  // 对角单位矩阵
        
        transform3d = CATransform3DRotate(transform3d, a, 0, 1, 0)  // 以 (0, 1, 0) 为轴， (0, 0, 0) 为锚点旋转 a 度
        
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)  // 左移 1/2 width
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))  // 定义整体的右移 1/2 width 的效果，这样等效于中轴线旋转
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)  // 组合应用上面的效果
    }
}

enum NewEvent {
    case none
    case HP
}

struct FlipEffectView: View {
    @Binding var times: Int
    @Binding var gotHP: Int
    @State var event: NewEvent = .none
    
    @State var flipped: Bool = false
    @State var trigger: Bool = false
    
    var body: some View {
        VStack {
            if flipped {
                if event == .none {
                    Rectangle()
                        .foregroundColor(lightYellow)
                        .frame(width: 100, height: 100)
                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                        .overlay {
                            Image(systemName: "xmark.seal.fill")
                                .font(.title)
                        }
                }
                else {
                    Rectangle()
                        .foregroundColor(lightRed)
                        .frame(width: 100, height: 100)
                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                        .overlay {
                            Image(systemName: "heart.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                }
            }
            else {
                Rectangle()
                    .foregroundColor(lightBrown)
                    .frame(width: 100, height: 100)
                    .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .overlay {
                        Text("?")
                            .font(.title)
                            .bold()
                    }
            }
        }
        .background()
        .cornerRadius(16)
        .shadow(color: Color(.displayP3, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 16, x: 0, y: 16)
        .modifier(FlipEffect(flipped: $flipped, angle: trigger ? 180: 0))
        .onTapGesture  {
            if trigger || times == 0 {
                return
            }
            withAnimation {
                times -= 1
            }
            if event == .HP {
                gotHP += 1
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                self.trigger.toggle()
            }
        }
        
    }
}
struct NewSpaceView: View {
    @ObservedObject var info: GameInfo
    @State var times = 3
    @State var lucknum = 0
    @State var gotHP = 0
    var body: some View {
        ZStack {
            backGroundWhite
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack{
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 0 ? .HP : .none)
                        .padding(5)
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 1 ? .HP : .none)
                        .padding(5)
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 2 ? .HP : .none)
                        .padding(5)
                }
                HStack{
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 3 ? .HP : .none)
                        .padding(5)
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 4 ? .HP : .none)
                        .padding(5)
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 5 ? .HP : .none)
                        .padding(5)
                }
                HStack{
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 6 ? .HP : .none)
                        .padding(5)
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 7 ? .HP : .none)
                        .padding(5)
                    FlipEffectView(times: $times, gotHP: $gotHP, event: lucknum == 8 ? .HP : .none)
                        .padding(5)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray)
                        .frame(width: 330, height: 30)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(times == 3 ? lightGreen : times == 2 ? lightOrange : lightRed)
                        .frame(width: 330 * CGFloat(Float(times) / 3), height: 30)
                }
                .overlay {
                    Text("剩余抽奖次数: \(times)")
                        .bold()
                }
                .padding(30)
                Spacer()
                if times == 0 {
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
            .padding(10)
        }
        .onChange(of: gotHP) {
            if gotHP > 0 {
                if info.HP != info.MaxHP {
                    info.HP += 1
                }
            }
        }
        .onAppear {
            print(lucknum)
        }
    }
}

#Preview {
    NewSpaceView(info: GameInfo())
}
