import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else{
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        let statisticService = StatisticService()
        statisticService.delegate = self
        self.statisticService = statisticService
        
        questionFactory.requestNextQuestion()
        
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?){
        guard let question = question else{
            return
        }
        
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async{[weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect{
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){[weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1{
            
            let date = Date()
            
            statisticService?.store(correct: correctAnswers, total: questionsAmount, date: date)
            
            let alertText = """
                            Ваш результат: \(correctAnswers)/10
                            Количество сыграных квизов: \(statisticService?.gamesCount ?? 0)
                            Рекорд: \(statisticService?.bestGame.correct ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? "")
                            Средняя точность: \(String(format:"%.2f", statisticService?.totalAccuracy ?? ""))%
                            
                            """
            
            let completion = {[weak self] in
                guard let self else { return }
                currentQuestionIndex = 0
                correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }
            let viewModel = AlertModel(
                title: "Раунд завершен",
                message: alertText,
                buttonText: "Играть снова",
                completion: completion)
            alertPresenter?.showAlert(result: viewModel)
        }else{
            currentQuestionIndex += 1
            
            questionFactory.requestNextQuestion()
            
        }
        
    }
    
    
    

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
