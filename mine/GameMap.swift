//
//  GameMap.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/12/13.
//

import Foundation
class GameMap {
    @Published var rows = 10
    @Published var columns = 10
    @Published var numberOfMines = 20
    @Published var eventArray: [[CellEvent]] = []
    @Published var stateArray: [[CellState]] = []
    @Published var eventNumber = 5
}
