//
//  TrainingLevelView.swift
//  juju
//
//  Created by Antonio Portela on 16/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainingLevelViewDelegate: AnyObject {
    
    func trainingLevelView(_ view: TrainingLevelView, didSelectLevel level: TrainingLevel)
}

final class TrainingLevelView: UIView {
    
    // MARK: Views
    private let closeButton = UIButton()

    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.text = TrainLevelViewController.title
        label.textColor = Styling.Colors.white
        label.font = Resources.Fonts.Gilroy.extraBold(ofSize: Styling.FontSize.twenty)
        return label
    }()
    
    private let arrowDown: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.arrowDown
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let superiorComponentsStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.eight
        return stack
    }()
    
    private let easyLevelComponent = TrainLevelComponent(level: .easy)
    private let mediumLevelComponent = TrainLevelComponent(level: .medium)
    private let hardLevelComponent = TrainLevelComponent(level: .hard)
    
    // MARK: Properties
    weak var delegate: TrainingLevelViewDelegate?

    public var closeWasTapped: (() -> Void)?

    // MARK: Lifecycle
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension TrainingLevelView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.arrowDown)
        self.addSubview(self.titleLabel)
        self.addSubview(self.closeButton)
        self.superiorComponentsStack.addArrangedSubview(self.easyLevelComponent)
        self.superiorComponentsStack.addArrangedSubview(self.mediumLevelComponent)
        self.addSubview(self.superiorComponentsStack)
        self.addSubview(self.hardLevelComponent)
    }
    
    func setupConstraints() {
        
        self.arrowDown.snp.makeConstraints { make in
            
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.thirtytwo)
            make.centerX.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(self.arrowDown.snp.bottom).offset(Styling.Spacing.twentyfour)
            make.left.equalTo(self.superiorComponentsStack.snp.left)
        }

        self.closeButton.snp.makeConstraints { make in

            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.sixteen)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-Styling.Spacing.sixteen)
            make.width.equalTo(Constants.closeButtonSides)
            make.height.equalTo(Constants.closeButtonSides)
        }
        
        self.superiorComponentsStack.snp.makeConstraints { make in
            
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Styling.Spacing.twentyfour)
            make.centerX.equalToSuperview()
        }
        
        self.easyLevelComponent.snp.makeConstraints { make in
            
            make.width.equalTo(Constants.componentWidth)
            make.height.equalTo(Constants.componentHeight)
        }
        
        self.mediumLevelComponent.snp.makeConstraints { make in
            
            make.width.equalTo(Constants.componentWidth)
            make.height.equalTo(Constants.componentHeight)
        }
        
        self.hardLevelComponent.snp.makeConstraints { make in
            
            make.width.equalTo(Constants.componentWidth)
            make.height.equalTo(Constants.componentHeight)
            make.top.equalTo(self.superiorComponentsStack.snp.bottom).offset(Styling.Spacing.eight)
            make.centerX.equalTo(self.easyLevelComponent.snp.centerX)
        }
        
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.softPink
        
        self.easyLevelComponent.delegate = self
        self.mediumLevelComponent.delegate = self
        self.hardLevelComponent.delegate = self

        self.configureCloseButtonVisibility()
    }
}

extension TrainingLevelView {

    private func configureCloseButtonVisibility() {

        let closeButtonFont = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.twenty)
        self.closeButton.setTitle("X",
                                  withColor: Styling.Colors.white,
                                  andFont: closeButtonFont,
                                  underlined: false)
        self.closeButton.addTarget(self,
                                   action: #selector(self.didTapClose),
                                   for: .touchUpInside)

        if #available(iOS 13, *) {

            self.arrowDown.isHidden = false
            self.closeButton.isHidden = true

        } else {

            self.arrowDown.isHidden = true
            self.closeButton.isHidden = false
        }
    }

    @objc
    private func didTapClose() {

        self.closeWasTapped?()
    }
}

extension TrainingLevelView: ViewConfiguration {
    
    enum States {
        
        case selectLevel(TrainingLevel)
    }
    
    func configure(with state: TrainingLevelView.States) {
        
        switch state {
            
        case .selectLevel(let level):
            
            switch level {
                
            case .easy:
                
                self.easyLevelComponent.configure(with: .selected)
                self.mediumLevelComponent.configure(with: .unselected)
                self.hardLevelComponent.configure(with: .unselected)
                
            case .medium:
                
                self.easyLevelComponent.configure(with: .unselected)
                self.mediumLevelComponent.configure(with: .selected)
                self.hardLevelComponent.configure(with: .unselected)
                
            case .hard:
                
                self.easyLevelComponent.configure(with: .unselected)
                self.mediumLevelComponent.configure(with: .unselected)
                self.hardLevelComponent.configure(with: .selected)
            }
        }
    }
}

extension TrainingLevelView {
    
    struct Constants {
        
        static let componentWidth = 137
        static let componentHeight = 117
        static let closeButtonSides = 44
    }
}

extension TrainingLevelView: TrainLevelComponentSelectionDelegate {
    
    func shouldSelectComponent(_ component: TrainLevelComponent) -> Bool {

        return component.isSelected ? false : true
    }
    
    func shouldDeselectComponent(_ component: TrainLevelComponent) -> Bool {
        
        return false
    }
    
    func trainLevelComponentWasSelected(_ component: TrainLevelComponent) {
        
        self.configure(with: .selectLevel(component.level))
        self.delegate?.trainingLevelView(self, didSelectLevel: component.level)
    }
    
    func trainLevelComponentWasUnselected(_ component: TrainLevelComponent) { }
}
