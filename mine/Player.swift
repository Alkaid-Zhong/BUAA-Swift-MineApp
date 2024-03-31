//
//  Player.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/12/13.
//

import Foundation

class Player {
    @Published var sightRange = 1
    @Published var HP = 5
    @Published var MaxHP = 5
    @Published var numberOfTools = 20
    @Published var MaxTools = 20
    @Published var experience = 0
    @Published var MaxExperience = 10
}
