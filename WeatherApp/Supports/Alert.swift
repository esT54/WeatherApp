//
//  Alert.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 08.02.2022.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(title: String,
                         message: String,
                         action: UIAlertAction,
                         viewController: UIViewController)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
