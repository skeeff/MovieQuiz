//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Федор Чистовский on 19.01.2025.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    var alertPresenter: AlertPresenterProtocol? { get }
    
    func show(quiz step: QuizStepViewModel)
    
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showLoadingIndicator()
    
    func hideLoadingIndicatior()
    
    func showNetworkError(message: String)
    
    func hideHighlight()
}
