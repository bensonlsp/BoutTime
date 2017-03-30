//
//  HelperFunctionClass.swift
//  BoutTime
//
//  Created by Benson Lo on 26/3/2017.
//  Copyright © 2017年 Benson Lo. All rights reserved.
//

import Foundation
import GameKit

// The time for round in second
let timePerRound = 60
// The number of rounds per game
let totalRound = 6

// Function to return a Int from lower Bound to lower Bound inclusively
func randomInt(from lowerBound: Int, to upperBound: Int) -> Int {
    return (GKRandomSource.sharedRandom().nextInt(upperBound: upperBound) + lowerBound)
}

// Class to help to manage the game
class BoutTimeManager {
    var score: Int
    var round: Int
    var emperorsOfCurrentRound: [Emperor]
    
    init(emperorsOfCurrenRound: [Emperor]) {
        self.score = 0
        self.round = totalRound
        self.emperorsOfCurrentRound = emperorsOfCurrenRound
    }
    
    // Function to reset score of the game to zero
    func reset() {
        score = 0
        round = totalRound
    }
}
