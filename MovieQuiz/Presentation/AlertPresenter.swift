//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Федор Чистовский on 07.10.2024.
//
import UIKit

final class AlertPresenter: UIAlertController, AlertPresenterProtocol {

    weak var delegate: UIViewController?
    
    func showAlert(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
        
    }

}
