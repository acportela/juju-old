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
    
    // MARK: Properties
    private lazy var input: UITextField = {
        
        let field = UITextField()
        field.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.sixteen)
        field.textColor = Styling.Colors.duskyRose
        field.textAlignment = .left
        field.configurePlaceholderWith(title: self.inputKind.hint,
                                       color: Styling.Colors.duskyPink)
        field.keyboardType = self.inputKind.keyboard
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.returnKeyType = .done
        field.delegate = self
        field.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        field.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        return field
    }()
    
    private lazy var title: UILabel = {
        
        let label = UILabel()
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.twelve)
        label.textAlignment = .left
        label.textColor = Styling.Colors.veryLightPink
        label.text = self.inputKind.title
        return label
    }()
    
    private let selectedIndicator: UIView = {
        
        let view = UIView()
        view.backgroundColor = Styling.Colors.rosyPink
        return view
    }()
    
    private var feedback: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.twelve)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = Constants.feedbackScaleFactor
        label.textAlignment = .left
        label.textColor = Styling.Colors.veryLightPink
        return label
    }()
    
    private let containerStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = Styling.Spacing.four
        return stack
    }()
    
    private let inputKind: InputKind
    var datePicker: UIDatePicker?
    
    var isValid: Bool { return validateCurrentInput() == .valid }
    var currentValue: String? { return self.input.text }
    
    var toolbarButtonAction: (() -> Void)?
    
    // MARK: Lifecycle
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
    
    // MARK: ViewCoding
    func addSubViews() {
        
        containerStack.addArrangedSubview(title)
        containerStack.addArrangedSubview(input)
        containerStack.addArrangedSubview(selectedIndicator)
        containerStack.addArrangedSubview(feedback)
        
        addSubview(containerStack)
    }
    
    func setupConstraints() {
        
        containerStack.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        selectedIndicator.snp.makeConstraints { make in
            
            make.height.equalTo(Constants.selectedLineHeight)
            make.width.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        input.setContentCompressionResistancePriority(.required, for: .vertical)
        
        if self.inputKind == .dateOfBirth {
            self.input.tintColor = .clear
            self.configureDatePicker()
        }
        if self.inputKind == .email || self.inputKind == .newEmail { self.input.autocapitalizationType = .none }
        if self.inputKind.isSecureEntry { self.configure(with: .secure(true))}
    }
    
    public func setFeedback(_ text: String) {
        self.feedback.text = text
    }
}

extension JujuInputField: ViewConfiguration {
    
    // MARK: Configuration
    enum States {
        case focused
        case unfocused
        case secure(Bool)
    }
    
    func configure(with state: JujuInputField.States) {
        
        switch state {
        
        case .focused:
            
            self.feedback.text = ""
            self.selectedIndicator.backgroundColor = Styling.Colors.veryLightPink
            
        case .unfocused:
        
            self.selectedIndicator.backgroundColor = Styling.Colors.rosyPink
            self.feedback.text = validateCurrentInput().message
            
        case .secure(let secure):
            
            self.input.isSecureTextEntry = secure
        }
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
    
    override var isFirstResponder: Bool {
        
        return input.isFirstResponder
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

extension JujuInputField {
    
    // MARK: Validation
    private func validateCurrentInput() -> InputValidationResult {
        
        guard let value = self.input.text else {
            return .required(fieldName: inputKind.title)
        }
        
        if self.inputKind.isRequired && value.trimmed().isEmpty {
            return .required(fieldName: self.inputKind.title)
        }
        
        let validator = Validators()

        switch self.inputKind {
        case .name:
            return validator.validate(name: value)
        case .email, .newEmail:
            return validator.validate(email: value)
        case .newPassword:
            return validator.validate(password: value)
        case .dateOfBirth:
            return validator.validate(date: DateUtils().dateFromString(value, withFormat: .iso8601UTCBar) ?? Date())
        default:
            return .valid
        }
    }
}

extension JujuInputField: UITextFieldDelegate {
    
    // MARK: Delegation
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        var isValid = true
        
        if let maxLength = self.inputKind.maxLength {
            
            isValid = TextFieldValidators.lenghtHandler(textField: textField,
                                                        shouldChangeCharactersInRange: range,
                                                        replacementString: string,
                                                        maxLength: maxLength)
        }
        
        return isValid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
}

extension JujuInputField {
    
    // MARK: Toolbar Setup
    public func addToolbar(withButton title: String, andAction action: @escaping (() -> Void)) {
        
        self.toolbarButtonAction = action
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar",
                                           style: .plain,
                                           target: self,
                                           action: #selector(toolbarCancelAction))
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(toolbarAction))
        toolbar.items = [space, button]
        
        if self.inputKind == .dateOfBirth { toolbar.items?.insert(cancelButton, at: 0) }
        
        toolbar.sizeToFit()
        input.inputAccessoryView = toolbar
    }
    
    @objc
    func toolbarAction() {
        
        if inputKind == .dateOfBirth, let datePicker = self.datePicker {
            
            input.text = DateUtils().stringFromDate(datePicker.date, withFormat: .iso8601UTCBar)
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
    
    struct Constants {
        
        static let selectedLineHeight = 2
        static let feedbackScaleFactor: CGFloat = 0.8
    }
}
