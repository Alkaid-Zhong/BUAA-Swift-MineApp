//
//  RegtangleSliderView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/28.
//

import SwiftUI

let width = UIScreen.main.bounds.width

struct RegtangleSliderView: View {
    
    
    @State var maxWidth: CGFloat = width - 32
    
    @Binding var actualProgress: Float
    @State var sliderProgress: Float = 0
    
    @State var sliderWidth: CGFloat = 0
    @State var lastDragValue: CGFloat = 0
    
    @State var sliderColor = lightBlue
    
    @Binding var enable: Bool
    @State var enableVis: Bool = false
    
    var textIn = "state"
    var minProgress: Float = 0
    var maxProgress: Float = 1
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                
                if enableVis {
                    Rectangle()
                        .fill(sliderColor)
                        .frame(width: sliderWidth)
                }
                else {
                    Rectangle()
                        .fill(sliderColor)
                }
            }
            .frame(width: maxWidth, height: 32)
            .cornerRadius(15)
//            .overlay() {
//                Text("\(textIn): \(sliderProgress * (maxProgress - minProgress) + minProgress)")
//                    .fontWeight(.semibold)
//                    .foregroundColor(.black)
//            }
            .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in
                if (enable) {
                    let translation = value.translation
                    withAnimation {
                        sliderWidth = translation.width + lastDragValue
                        sliderWidth = sliderWidth > maxWidth ? maxWidth : sliderWidth
                        sliderWidth = sliderWidth >= 0 ? sliderWidth : 0
                        sliderColor = getColor()
                    }
                    let progress = sliderWidth / maxWidth
                    sliderProgress = progress <= 1.0 ? Float(progress) : 1
                }
            }).onEnded({ (value) in
                sliderWidth = sliderWidth > maxWidth ? maxWidth : sliderWidth
                sliderWidth = sliderWidth >= 0 ? sliderWidth : 0
                lastDragValue = sliderWidth
                
            }
            ))
        }
        .onChange(of: actualProgress) {
            if !enable {
                sliderProgress = (actualProgress - minProgress) / (maxProgress - minProgress)
                sliderWidth = maxWidth * CGFloat(sliderProgress)
                lastDragValue = sliderWidth
            }
        }
        .onChange(of: sliderProgress) {
            actualProgress = sliderProgress * (maxProgress - minProgress) + minProgress
            withAnimation {
                sliderColor = getColor()
            }
        }
        .onChange(of: enable) {
            sliderProgress = (actualProgress - minProgress) / (maxProgress - minProgress)
            sliderWidth = maxWidth * CGFloat(sliderProgress)
            lastDragValue = sliderWidth
            withAnimation {
                enableVis = enable
            }
        }
        .onAppear {
            sliderProgress = actualProgress
            enableVis = enable
            lastDragValue = CGFloat(sliderProgress) * maxWidth
            sliderWidth = lastDragValue
            sliderColor = getColor()
        }
    }
    
    func getColor() -> Color {
        if sliderProgress < 0.3 {
            return lightBlue
        }
        else if sliderProgress < 0.6 {
            return .orange.opacity(0.5)
        }
        else {
            return lightRed
        }
    }
}

struct testRegtangleSliderView: View {
    @State var p: Float = 0.5
    @State var en = true
    var body: some View {
        Text("\(p)")
        RegtangleSliderView(actualProgress: $p, enable: $en, minProgress: 0.2)
        Slider(value: $p)
        Button("\(en ? "yes" : "no")") {
            en = !en
        }
    }
}

#Preview {
    testRegtangleSliderView()
}
