//
//  TrainingView.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class TrainingView: UIView {

    // MARK: Views
    
    private let instructions: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = Constants.numberOfLines
        label.text = "Aqui é onde você pratica o exercício\nde relaxamento e contração do períneo"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let initialFooter = TrainingFooterButton()
    
    private let playPauseContainer = UIView()
    
    private let playButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.playButton, for: .normal)
        return button
    }()
    
    private let pauseButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.pauseButton, for: .normal)
        return button
    }()
    
    private let restartButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.replayButton, for: .normal)
        return button
    }()
    
    private let animationRect: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let circularLayer: CAShapeLayer  = {
        let layer = CAShapeLayer()
        layer.fillColor = self.backgroundColor?.cgColor
        layer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        layer.frame = self.bounds
        layer.cornerRadius = self.bounds.height/2
        layer.masksToBounds = true
        layer.addSublayer(self.animatableLayer!)
        return layer
    }
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension TrainingView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(instructions)
        self.addSubview(animationRect)
        self.addSubview(initialFooter)
        self.playPauseContainer.addSubview(playButton)
        self.playPauseContainer.addSubview(pauseButton)
        self.addSubview(playPauseContainer)
        self.addSubview(restartButton)
    }
    
    func setupConstraints() {
       
        self.instructions.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Styling.Spacing.twentyfour)
            make.left.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.right.equalToSuperview().offset(-Styling.Spacing.sixteen)
            make.centerX.equalToSuperview()
        }
        
        self.initialFooter.snp.makeConstraints { make in
            make.height.equalTo(Constants.initialFooterHeight)
            make.left.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.right.equalToSuperview().offset(-Styling.Spacing.sixteen)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Styling.Spacing.twentyfour)
        }
        
        self.restartButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.repeatSides)
            make.centerY.equalTo(playPauseContainer.snp.centerY)
            make.left.equalTo(playPauseContainer.snp.right).offset(Styling.Spacing.thirtytwo)
        }
        
        self.playButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.playPauseSides)
            make.edges.equalToSuperview()
        }
        
        self.pauseButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.playPauseSides)
            make.edges.equalToSuperview()
        }
        
        self.playPauseContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Styling.Spacing.sixteen)
        }
        
        self.animationRect.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
            make.width.equalToSuperview().multipliedBy(Constants.animationRectWidthRatio)
            make.height.equalTo(self.animationRect.snp.width)
        }
    }
    
    func configureViews() {
        
    }
}

extension TrainingView {
    
    private func addCircularLayers(amount: Int) -> [CAShapeLayer] {
        
        var shapes: [CAShapeLayer] = []
        
        let biggestRadius = self.animationRect.frame.width / 2
        let centerColor = Styling.Colors.softPinkTwo
        
        for index in 1...amount {
            
            let shape = CAShapeLayer()
            
            let alpha = CGFloat(index) / CGFloat(amount)
            
            shape.fillColor = centerColor.withAlphaComponent(alpha).cgColor
            
            let sideRatio = (CGFloat(amount) / CGFloat(index) / CGFloat(amount))
            let side = self.animationRect.frame.width
            let rect = CGRect(x: 0, y: 0, width: self.animationRect.frame.width, height: <#T##Int#>)
            shape.path = UIBezierPath(roundedRect: <#T##CGRect#>, cornerRadius: <#T##CGFloat#>)
            shapes.append(shape)
        }
        
        return []
    }
}
extension TrainingView: ViewConfiguration {
    
    enum States {
    case initial(TrainingConfiguration)
    case inProgress(TrainingConfiguration, DailyGoal)
    }
    
    func configure(with state: TrainingView.States) {
        
        switch state {
        case .initial(let configuration):
            
            let footerConfig = TrainingFooterButtonConfiguration(title: "Começar",
                                                                 subtitle: "nível \(configuration.level.lowercased())")
            self.initialFooter.configure(with: .initial(footerConfig))
            self.initialFooter.isHidden = false
            self.instructions.isHidden = false
            
            self.playPauseContainer.isHidden = true
            
        case .inProgress:
            
            self.instructions.isHidden = true
        }
    }
}

extension TrainingView {
    
    struct Constants {
        
        static let numberOfLines = 2
        static let initialFooterHeight = 48
        static let initialFooterWidth = 332
        static let repeatSides = 24
        static let playPauseSides = 68
        static let animationRectWidthRatio: CGFloat = 0.75
    }
}
