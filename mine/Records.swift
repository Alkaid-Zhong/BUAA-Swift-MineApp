//
//  File.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/12/20.
//

import Foundation
import SwiftData

@Model
final class Records {
    var score: Int
    var username: String
    init(score: Int, username: String) {
        self.score = score
        self.username = username
    }
}
