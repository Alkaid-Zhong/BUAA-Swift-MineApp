//
//  RecordView.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/12/20.
//

import SwiftUI
import SwiftData

struct RecordView: View {
    var records: [Records]
    var body: some View {
        ZStack {
            backGroundWhite
                .ignoresSafeArea()
            List {
                ForEach(records) { record in
                    HStack {
                        VStack (alignment: .leading){
                            Text("\(record.username)")
                                .font(.title)
                                .bold()
                            Text("Score:\(record.score)")
                                .font(.title3)
                        }
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                    }
                }
            }
        }
        .navigationTitle("Records")
    }
}

#Preview {
    RecordView(records: [Records(score: 10, username: "sam")])
}
