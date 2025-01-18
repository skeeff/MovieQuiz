//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Федор Чистовский on 18.01.2025.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
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
                
                viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
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
        
        DispatchQueue.main.async{[weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func showNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            
//            let date = Date()
//            
//            statisticService?.store(correct: correctAnswers, total: self.questionsAmount, date: date)
//            
//            let alertText = """
//                            Ваш результат: \(correctAnswers)/10
//                            Количество сыграных квизов: \(statisticService?.gamesCount ?? 0)
//                            Рекорд: \(statisticService?.bestGame.correct ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? "")
//                            Средняя точность: \(String(format:"%.2f", statisticService?.totalAccuracy ?? ""))%
//                            
//                            """
// 
            let alertText =  "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let completion = {[weak self] in
                guard let self else { return }
                self.resetQuestionIndex()
                correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            let viewModel = AlertModel(
                title: "Раунд завершен",
                message: alertText,
                buttonText: "Играть снова",
                completion: completion)
            viewController?.alertPresenter?.showAlert(result: viewModel)
        }else{
            self.switchToNextQuestion()
            
            questionFactory?.requestNextQuestion()
            
        }
        
    }
    
}
