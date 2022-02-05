//
//  MainView.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 02.02.2022.
//

import Foundation
import UIKit
protocol MainViewDelegate {
    func handleTouchedUpTestButton()
}

class MainView: UIView {
    var delegate: MainViewDelegate?
    
    let titleLabel: UILabel = {
        let result = UILabel()
        result.text = "Weather app"
        result.font = .preferredFont(forTextStyle: .largeTitle)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    let cityNameTextField: UITextField = {
        let result = UITextField()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.borderStyle = .roundedRect
        return result
    }()
    
    let responceLabel: UILabel = {
        let result = UILabel()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.text = "Responce temputure"
        return result
    }()
    
    let testButton: UIButton = {
        let result = UIButton()
//        result.titleLabel?.text = "Test"
        result.setTitle("Test", for: .normal)
        result.backgroundColor = .red
        result.translatesAutoresizingMaskIntoConstraints = false
        result.addTarget(self, action: #selector(testTouched), for: .touchUpInside)
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        self.addSubview(titleLabel)
        self.addSubview(cityNameTextField)
        self.addSubview(responceLabel)
        self.addSubview(testButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cityNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            cityNameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cityNameTextField.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            responceLabel.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 40),
            responceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            testButton.topAnchor.constraint(equalTo: responceLabel.bottomAnchor, constant: 40),
            testButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            testButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
        ]) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func testTouched() {
        delegate?.handleTouchedUpTestButton()
    }
}
