//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Федор Чистовский on 18.01.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        self.statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        questionFactory?.setup(delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        self.proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrect: Bool){
        if (isCorrect) {
            correctAnswers += 1 }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func proceedToNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            
            let date = Date()
            
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount, date: date)
            
            let alertText = """
                                        Ваш результат: \(correctAnswers)/10
                                        Количество сыграных квизов: \(statisticService?.gamesCount ?? 0)
                                        Рекорд: \(statisticService?.bestGame.correct ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? "")
                                        Средняя точность: \(String(format:"%.2f", statisticService?.totalAccuracy ?? ""))%
                                        
                                        """
            
            
            let completion = {[weak self] in
                guard let self else { return }
                self.restartGame()
                correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            let viewModel = AlertModel(
                title: "Раунд завершен",
                message: alertText,
                buttonText: "Играть снова",
                completion: completion)
            viewController?.alertPresenter?.showAlert(result: viewModel)
        } else {
            self.switchToNextQuestion()
            
        }
        
    }
    
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicatior()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func loadData() {
        questionFactory?.loadData()
    }
    
    func makeResultsMessage() -> String {
        
        let date = Date()
        
        statisticService.store(correct: correctAnswers, total: questionsAmount, date: date)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    func proceedWithAnswer(isCorrect: Bool){
        didAnswer(isCorrect: isCorrect)
        
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            viewController?.hideHighlight()
            self.proceedToNextQuestionOrResults()
        }
    }
}

