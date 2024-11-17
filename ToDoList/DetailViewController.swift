//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Kristofer Sartorial on 11/15/24.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var task: ToDo?
    var isNewTask: Bool = false
    
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad() //вызов метода род класса
        setUpUI()
        configureView()
//        if let task = task {
//            title = task.title
//        }
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        titleTextField.borderStyle = .roundedRect //работа с углами
        titleTextField.placeholder = "какой то текст"
        view.addSubview(titleTextField)
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 5
        view.addSubview(descriptionTextView)
        
    }
    private func configureView() {
        if let task = task {
            titleTextField.text = task.title
            descriptionTextView.text = task.description
        } else {
            titleTextField.text = " "
            descriptionTextView.text = " "
        }
    }
    
    
    АНЯ ЗАПУШЬ СВОИ РЕЗУЛЬАТЫЫЫЫЫЫЫЫЫ!!!!!!
    
}
