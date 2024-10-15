//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Федор Чистовский on 15.10.2024.
//

import Foundation

protocol StatisticServiceProtocol{
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct: Int, total: Int, date: Date)
}
