//
//  GameMap.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/26.
//

import Foundation

let MAX_ROWS = 40
let MAX_COLUMNS = 40

enum CellState{
    case Hidden
    case Visible
    case Show
}
enum CellEvent {
    case None
    case Bomb
    case CheckedBomb
    case Gift
    case NewSpace
}

class GameInfo: ObservableObject {
    
    @Published var gameStarted = false
    @Published var win = false
    
    @Published var sightRange = 1
    @Published var HP = 5
    @Published var MaxHP = 5
    @Published var numberOfTools = 20
    @Published var MaxTools = 20
    @Published var experience = 0
    @Published var MaxExperience = 10
    
    @Published var rows = 10
    @Published var columns = 10
    @Published var numberOfMines = 20
    @Published var eventArray: [[CellEvent]] = []
    @Published var stateArray: [[CellState]] = []
    @Published var eventNumber = 5
    
    @Published var autoCellSize = true
    
    init(gameStarted: Bool = false, win: Bool = false, sightRange: Int = 1, HP: Int = 5, MaxHP: Int = 5, numberOfTools: Int = 20, MaxTools: Int = 20, experience: Int = 0, MaxExperience: Int = 10, rows: Int = 10, columns: Int = 10, numberOfMines: Int = 20, eventArray: [[CellEvent]] = [], stateArray: [[CellState]] = [], eventNumber: Int = 5, autoCellSize: Bool = true) {
        
        self.gameStarted = gameStarted
        self.win = win
        
        self.sightRange = sightRange
        self.HP = HP
        self.MaxHP = MaxHP
        self.numberOfTools = numberOfTools
        self.MaxTools = MaxTools
        self.experience = experience
        self.MaxExperience = MaxExperience
        
        self.rows = rows
        self.columns = columns
        self.numberOfMines = numberOfMines
        self.eventArray = eventArray
        self.stateArray = stateArray
        self.eventNumber = eventNumber
        
        self.autoCellSize = autoCellSize
        
        initializeMines()
    }
    
    func checkWin() {
        for i in 0..<rows {
            for j in 0..<columns {
                if eventArray[i][j] == .Bomb && stateArray[i][j] != .Show {
                    print("\((i, j))")
                    return
                }
            }
        }
        win = true
    }
    
    func initializeMines() {
        
        self.eventArray = Array(repeating: Array(repeating: .None, count: columns), count: rows)
        self.stateArray = Array(repeating: Array(repeating: .Hidden, count: columns), count: rows)
        
        for _ in 0..<numberOfMines {
            var randomRow = Int.random(in: 0..<rows)
            var randomColumn = Int.random(in: 0..<columns)
            
            while self.eventArray[randomRow][randomColumn] == .Bomb {
                randomRow = Int.random(in: 0..<rows)
                randomColumn = Int.random(in: 0..<columns)
            }
            
            self.eventArray[randomRow][randomColumn] = .Bomb
        }
        
        for _ in 0..<eventNumber {
            var randomRow = Int.random(in: 0..<rows)
            var randomColumn = Int.random(in: 0..<columns)
            while self.eventArray[randomRow][randomColumn] != .None {
                randomRow = Int.random(in: 0..<rows)
                randomColumn = Int.random(in: 0..<columns)
            }
            
            self.eventArray[randomRow][randomColumn] = .Gift
        }
        
        for _ in 0..<1 {
            var randomRow = Int.random(in: 0..<rows)
            var randomColumn = Int.random(in: 0..<columns)
            while self.eventArray[randomRow][randomColumn] != .None {
                randomRow = Int.random(in: 0..<rows)
                randomColumn = Int.random(in: 0..<columns)
            }
            
            self.eventArray[randomRow][randomColumn] = .NewSpace
        }
        
        var randomX = Int.random(in: 0..<rows)
        var randomY = Int.random(in: 0..<columns)
            
        while self.eventArray[randomX][randomY] != .None {
            randomX = Int.random(in: 0..<rows)
            randomY = Int.random(in: 0..<columns)
        }
        
        self.stateArray[randomX][randomY] = .Visible
        print("start: \(randomX) \(randomY)")
    }
    
    func getText(x: Int, y: Int) -> String {
        var count = 0
        for i in max(0, x - 1)...min(rows-1, x + 1) {
            for j in max(0, y - 1)...min(columns-1, y + 1) {
                if(i == x && j == y) {
                    continue
                }
                count += (eventArray[i][j] == .Bomb) ? 1 : 0
            }
        }
        if count == 0 {
            return ""
        }
        return String(count)
    }
    
    func refreshState(x: Int, y: Int) {
        for i in max(0, x - 1)...min(rows-1, x + 1) {
            for j in max(0, y - 1)...min(columns-1, y + 1) {
                if(stateArray[i][j] == .Show) {
                    continue
                }
                if stateArray[x][y] == .Show {
                    if getText(x: x, y: y) == "" && eventArray[x][y] != .Bomb {
                        stateArray[i][j] = .Show
                        refreshState(x: i, y: j)
                    }
                    else {
                        if stateArray[i][j] == .Hidden {
                            stateArray[i][j] = .Visible
                        }
                    }
                }
            }
        }
        for i in max(0, x - sightRange)...min(rows-1, x + sightRange) {
            for j in max(0, y - sightRange)...min(columns-1, y + sightRange) {
                if(stateArray[i][j] == .Hidden) {
                    stateArray[i][j] = .Visible
                }
            }
        }
    }
    
    func refreshState() {
        for i in 0..<rows {
            for j in 0..<columns {
                if(stateArray[i][j] == .Show) {
                    refreshState(x: i, y: j)
                }
            }
        }
    }
    
    func countMine() -> (Int, Int, Int) {
        var count = 0
        var bomb = 0
        var last = 0
        for i in 0..<rows {
            for j in 0..<columns {
                if eventArray[i][j] == .CheckedBomb {
                    count += 1
                }
                if eventArray[i][j] == .Bomb {
                    if stateArray[i][j] == .Show {
                        bomb += 1
                    }
                    else {
                        last += 1
                    }
                }
            }
        }
        return (count, bomb, last)
    }
}
