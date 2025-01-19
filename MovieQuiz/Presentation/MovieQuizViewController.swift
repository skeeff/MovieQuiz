import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    private var presenter : MovieQuizPresenter!
    
    var alertPresenter: AlertPresenterProtocol?
    //private var statisticService: StatisticServiceProtocol?
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        //presenter.currentQuestion = presenter.currentQuestion
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        //presenter.currentQuestion = presenter.currentQuestion
        presenter.noButtonClicked()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        //        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        //        questionFactory.setup(delegate: self)
        //        self.questionFactory = questionFactory
        //        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        //        let statisticService = StatisticService()
        //        statisticService.delegate = self
        //        self.statisticService = statisticService
        
        presenter.loadData()
        presenter.restartGame()
        
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    //    func didRecieveNextQuestion(question: QuizQuestion?) {
    //        presenter.didRecieveNextQuestion(question: question)
    //    }
    
    //    func didLoadDataFromServer() {
    //        activityIndicator.isHidden = true
    //        questionFactory?.requestNextQuestion()
    //    }
    
    //    func didFailToLoadData(with error: Error) {
    //        showNetworkError(message: error.localizedDescription)
    //    }
    
    func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.cornerRadius = 20
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        //        let date = Date()
        //        let message = presenter.
        //        if let statisticService = statisticService {
        //            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount, date: date)
        //
        //            let bestGame = statisticService.bestGame
        //
        //            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        //            let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)"
        //            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        //            + " (\(bestGame.date.dateTimeString))"
        //            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        //
        //            let resultMessage = [
        //                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        //            ].joined(separator: "\n")
        //
        //            message = resultMessage
        //        }
        //
        //        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
        //            guard let self = self else { return }
        //
        //            presenter.restartGame()
        //            presenter.correctAnswers = 0
        //
        ////            self.questionFactory?.requestNextQuestion()
        //        }
        //
        //        alertPresenter?.showAlert(result: model)
    }
    
    func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String){
        activityIndicator.isHidden = true
        
        let model = AlertModel(title: "Ошибка", message: "Ошибка сети", buttonText: "Попробовать снова") { [weak self] in
            guard let self = self else{ return }
            
            self.presenter.restartGame()
            self.presenter.correctAnswers = 0
            
            //            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.showAlert(result: model)
        
    }
    
    func showAnswerResult(isCorrect: Bool){
        presenter.didAnswer(isCorrect: isCorrect)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){[weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            presenter.showNextQuestionOrResults()
        }
    }
    
    func hideLoadingIndicatior(){
        activityIndicator.isHidden = true
        
    }
    
    //private func showNextQuestionOrResults() {
        //presenter.showNextQuestionOrResults()
        //
        //        if presenter.isLastQuestion() {
        //            
        //            let date = Date()
        //            
        //            statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount, date: date)
        //            
        //            let alertText = """
        //                            Ваш результат: \(presenter.correctAnswers)/10
        //                            Количество сыграных квизов: \(statisticService?.gamesCount ?? 0)
        //                            Рекорд: \(statisticService?.bestGame.correct ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? "")
        //                            Средняя точность: \(String(format:"%.2f", statisticService?.totalAccuracy ?? ""))%
        //                            
        //                            """
        //            
        //            let completion = {[weak self] in
        //                guard let self else { return }
        //                self.presenter.restartGame()
        //                presenter.correctAnswers = 0
        //            }
        //            
        //            let viewModel = AlertModel(
        //                title: "Раунд завершен",
        //                message: alertText,
        //                buttonText: "Играть снова",
        //                completion: completion)
        //            alertPresenter?.showAlert(result: viewModel)
        //        }else{
        //            presenter.switchToNextQuestion() 
        //            
        //            
        //        }
        //        
        //    }
        //    
        //    
        //    
        //    
   // }
}

/*
 Mock-данные
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
