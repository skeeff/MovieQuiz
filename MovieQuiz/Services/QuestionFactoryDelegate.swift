//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Федор Чистовский on 06.10.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject{
    func didRecieveNextQuestion(question: QuizQuestion?)
}
