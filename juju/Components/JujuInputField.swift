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
        field.font = Resources.Fonts.Gilroy.regular(ofSize: 16)
        field.textColor = Resources.Colors.white
        field.adjustsFontSizeToFitWidth = true
        field.minimumFontSize = 12
        field.textAlignment = .left
        field.delegate = self
        return field
    }()
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = Resources.Fonts.Gilroy.regular(ofSize: 14)
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
        stack.spacing = 4
        return stack
    }()
    
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
        self.title.text = self.inputKind.title
        self.input.placeholder = self.inputKind.hint
        self.input.keyboardType = self.inputKind.keyboard
        self.input.returnKeyType = .done
        self.input.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        self.input.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
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
            self.selectedIndicator.backgroundColor = Resources.Colors.white
        case .unfocused:
            self.selectedIndicator.backgroundColor = Resources.Colors.pink
        }
    }

}

extension JujuInputField {
    
    public func addToolbar(withButton title: String, andAction action: @escaping (() -> Void)) {
        
        self.toolbarButtonAction = action
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(toolbarAction))
        toolbar.items = [space, button]
        
        toolbar.sizeToFit()
        self.input.inputAccessoryView = toolbar
    }
    
    @objc
    func toolbarAction() {
        
        self.toolbarButtonAction?()
    }
    
}

extension JujuInputField {
    
    override func becomeFirstResponder() -> Bool {
        input.becomeFirstResponder()
        return false
    }
    
    override func resignFirstResponder() -> Bool {
        return input.resignFirstResponder()
    }
    
    @objc
    func didBeginEditing() {
        self.configure(with: .focused)
    }
    
    @objc
    func didEndEditing() {
        self.configure(with: .unfocused)
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
        case age
        case email
        case password
        
        //TODO: Localization
        var title: String {
            switch self {
            case .name:
                return "Nome"
            case .age:
                return "Idade"
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
            case .age:
                return "Quantos anos você tem?"
            case .email:
                return "Qual seu email?"
            case .password:
                return "Crie um senha"
            }
        }
        
        var keyboard: UIKeyboardType {
            switch self {
            case .name:
                return .namePhonePad
            case .age:
                return .numberPad
            case .email:
                return .emailAddress
            case .password:
                return .default
            }
        }
    }
    
}
