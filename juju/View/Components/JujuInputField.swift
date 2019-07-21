//
//  JujuInputField.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class JujuInputField: UIView {
    
    private lazy var input: UITextField = {
        let field = UITextField()
        field.font = Resources.Fonts.Gilroy.medium(ofSize: 16)
        field.textColor = Resources.Colors.white
        field.adjustsFontSizeToFitWidth = true
        field.minimumFontSize = 12
        field.textAlignment = .left
        field.delegate = self
        return field
    }()
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = Resources.Fonts.Gilroy.medium(ofSize: 16)
        label.textAlignment = .left
        label.textColor = Resources.Colors.white
        return label
    }()
    
    private let selectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.pink
        return view
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 6
        return stack
    }()
    
    var datePicker: UIDatePicker?

    private let inputKind: InputKind
    
    var toolbarButtonAction: (() -> Void)?
    
    init(frame: CGRect = .zero, inputKind: InputKind) {
        self.inputKind = inputKind
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
    
}

extension JujuInputField: ViewCoding {
    
    func addSubViews() {
        containerStack.addArrangedSubview(title)
        containerStack.addArrangedSubview(input)
        containerStack.addArrangedSubview(selectedIndicator)
        addSubview(containerStack)
    }
    
    func setupConstraints() {
        
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectedIndicator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
        }
    }
    
    func configureViews() {
        title.text = inputKind.title
        input.placeholder = inputKind.hint
        input.keyboardType = inputKind.keyboard
        input.returnKeyType = .done
        input.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        input.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        
        if inputKind == .dateOfBirth { configureDatePicker() }
    }
    
}

extension JujuInputField: ViewConfiguration {
    
    enum States {
        case focused
        case unfocused
    }
    
    func configure(with state: JujuInputField.States) {
        switch state {
        case .focused:
            selectedIndicator.backgroundColor = Resources.Colors.white
        case .unfocused:
            selectedIndicator.backgroundColor = Resources.Colors.pink
        }
    }

}

extension JujuInputField {
    
    public func addToolbar(withButton title: String, andAction action: @escaping (() -> Void)) {
        
        toolbarButtonAction = action
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar",
                                           style: .plain,
                                           target: self,
                                           action: #selector(toolbarCancelAction))
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(toolbarAction))
        toolbar.items = [space, button]
        
        if inputKind == .dateOfBirth { toolbar.items?.insert(cancelButton, at: 0) }
        
        toolbar.sizeToFit()
        input.inputAccessoryView = toolbar
    }
    
    @objc
    func toolbarAction() {
        
        if inputKind == .dateOfBirth {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if let datepicker = self.datePicker {
                input.text = formatter.string(from: datepicker.date)
            }
        }
        
        toolbarButtonAction?()
    }
    
    @objc
    func toolbarCancelAction() {
        
        resignFirstResponder()
    }
    
    private func configureDatePicker() {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        self.datePicker = datePicker
        input.inputView = datePicker
    }
}

extension JujuInputField {
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        input.becomeFirstResponder()
        return false
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return input.resignFirstResponder()
    }
    
    @objc
    func didBeginEditing() {
        configure(with: .focused)
    }
    
    @objc
    func didEndEditing() {
        configure(with: .unfocused)
    }
}

extension JujuInputField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension JujuInputField {
    
    enum InputKind {
        
        case name
        case dateOfBirth
        case newEmail
        case newPassword
        case email
        case password
        
        //TODO: Localization
        var title: String {
            switch self {
            case .name:
                return "Nome"
            case .dateOfBirth:
                return "Data de Nascimento"
            case .newEmail:
                return "Email"
            case .newPassword:
                return "Senha"
            case .email:
                return "Email"
            case .password:
                return "Senha"
            }
        }
        
        var hint: String {
            switch self {
            case .name:
                return "Qual seu nome?"
            case .dateOfBirth:
                return "Quando você nasceu?"
            case .newEmail:
                return "Qual seu email?"
            case .newPassword:
                return "Crie um senha"
            case .email:
                return "Digite o email cadastrado"
            case .password:
                return "Digite sua senha"
            }
        }
        
        var keyboard: UIKeyboardType {
            switch self {
            case .name:
                return .namePhonePad
            case .dateOfBirth:
                return .numberPad
            case .newEmail:
                return .emailAddress
            case .newPassword:
                return .default
            case .email:
                return .emailAddress
            case .password:
                return .default
            }
        }
    }
    
}
