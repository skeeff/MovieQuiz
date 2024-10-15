//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Федор Чистовский on 15.10.2024.
//

import Foundation

struct GameResult{
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(_ newGame: GameResult) -> Bool{
        correct >= newGame.correct
    }
}
