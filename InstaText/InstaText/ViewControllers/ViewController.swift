//
//  ViewController.swift
//  InstaText
//
//  Created by Никита Гуляев on 27.12.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let toolBar = UIToolbar()
    private let saveButton = UIButton()
    
    private let flexibleSpace = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: self,
        action: nil)
        
    
    private let keyboardButton = UIBarButtonItem(
        image: UIImage(named: "keyboard.chevron.compact.left"),
        style: .done,
        target: self,
        action: #selector(risingFirstResponder))
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScrollView()
        setupTextView()
        setupToolBar()
        setupSaveButton()
        registerForKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        view.backgroundColor = .systemGray
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.frame = CGRect(x: 280, y: 40, width: 100, height: 50)
        saveButton.addTarget(self, action: #selector(risingFirstResponder), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupScrollView() {
        scrollView.frame.size.height = view.frame.size.height
        scrollView.frame.size.width = view.frame.size.width
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 85
        scrollView.backgroundColor = .systemGray
        scrollView.addSubview(textView)
    }
    
    private func setupToolBar() {
        toolBar.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 110))
        toolBar.sizeToFit()
        toolBar.items = [flexibleSpace, keyboardButton]
    }
    
    private func setupTextView() {
        textView.frame.size.height = view.frame.size.height / 2.5
        textView.frame.size.width = view.frame.size.width - 64
        textView.center.x = view.center.x
        textView.center.y = view.center.y - 85
        textView.inputAccessoryView = toolBar
        textView.layer.cornerRadius = 5
    }
    
    @objc private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self , name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFramedSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFramedSize.height - view.frame.size.height / 4)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    @objc private func risingFirstResponder() {
        textView.resignFirstResponder()
    }
}

