//
//  MyBackButton.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/29.
//

import SwiftUI

struct MyBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Image(systemName: "chevron.left")
            .foregroundColor(.black)
            .bold()
            .onTapGesture {
                self.presentationMode.wrappedValue.dismiss()
            }
    }
}

struct DIYBackButton<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    
    let content: Content
    var action: () -> () = {}

    init(action: @escaping ()->() = {}, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.action = action
    }

    
    var body: some View {
        content
            .onTapGesture {
                self.action()
                self.presentationMode.wrappedValue.dismiss()
            }
    }
}

#Preview {
    MyBackButton()
}
