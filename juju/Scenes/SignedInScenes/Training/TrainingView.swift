//
//  TrainingView.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainingViewDelegate: AnyObject {
    
    func trainingViewWantsToStartTrain(_ trainingView: TrainingView)
    func trainingViewWantsToResumeTrain(_ trainingView: TrainingView)
    func trainingViewWantsToStopTrain(_ trainingView: TrainingView)
    func trainingViewWantsToRestartTrain(_ trainingView: TrainingView)
}

final class TrainingView: UIView {

    // MARK: Views
    
    private let instructions: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = Constants.instructionsLines
        label.text = "Aqui é onde você pratica o exercício\nde relaxamento e contração do períneo"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let contractRelax: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.rosyPink
        label.text = .empty
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.twenty)
        return label
    }()
    
    private lazy var initialFooter: TrainingFooterButton = {
        
        let view = TrainingFooterButton()
        view.wasTappedCallback = {
            
            self.delegate?.trainingViewWantsToStartTrain(self)
        }
        return view
    }()
    
    private lazy var playPauseComponent: PlayPauseRestartComponent = {
        
        let view = PlayPauseRestartComponent()
        view.delegate = self
        return view
    }()
    
    private let dailyProgressComponent: DailyGoalComponent = {
        
        let view = DailyGoalComponent()
        view.isHidden = true
        return view
    }()
    
    private let innerCircle = NumberedCircle(radius: 51.5)
    private let circlesComponent = CirclesComponent(time: 5)
    
    // MARK: Properties
    private lazy var timer: TrainingTimer = {
        
        let timer = TrainingTimer()
        timer.timerWasUpdated = { currentTime in
            
            self.handleTimeUpdate(currentTime)
        }
        return timer
    }()
    
    public weak var delegate: TrainingViewDelegate?
    
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
        
        self.addSubview(self.instructions)
        self.addSubview(self.contractRelax)
        self.addSubview(self.innerCircle)
        self.addSubview(self.circlesComponent)
        self.addSubview(self.initialFooter)
        self.addSubview(self.playPauseComponent)
        self.addSubview(self.dailyProgressComponent)
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
        
        self.innerCircle.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
            make.width.height.equalTo(Constants.innerCircleSide)
        }
        
        self.circlesComponent.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
            make.width.height.equalToSuperview().multipliedBy(Constants.animationRectWidthRatio)
        }
        
        self.playPauseComponent.snp.makeConstraints { make in
            make.width.equalTo(Constants.playPauseRestartWidth)
            make.height.equalTo(Constants.playPauseRestartHeight)
            make.left.equalTo(self.snp.centerX).offset(Constants.playPauseCenterXOffset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Styling.Spacing.sixteen)
        }
        
        self.dailyProgressComponent.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.eight)
            make.left.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.right.equalToSuperview().offset(-Styling.Spacing.sixteen)
        }
        
        self.contractRelax.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.circlesComponent.snp.top).offset(-Styling.Spacing.eight)
        }
    }
}

extension TrainingView: ViewConfiguration {
    
    enum States {
        
        case initial(TrainingConfiguration)
        case start(DailyGoal)
        case stop
        case resume
        case contract
        case relax
        case restart
        case updateTime(Int)
    }
    
    func configure(with state: TrainingView.States) {
        
        switch state {
            
        case .initial(let configuration):
            
            let footerConfig = TrainingFooterButtonConfiguration(title: "Começar",
                                                                 subtitle: "nível \(configuration.level.lowercased())")
            self.instructions.isHidden = false
            self.playPauseComponent.isHidden = true
            self.dailyProgressComponent.isHidden = true
            self.initialFooter.isHidden = false
            
            self.initialFooter.configure(with: .initial(footerConfig))
            
            self.circlesComponent.configure(with: .stopAnimation)
            
            self.innerCircle.configure(with: .build(number: configuration.convergingDuration,
                                                    color: Styling.Colors.softPinkTwo.withAlphaComponent(0.2)))
            
            self.contractRelax.text = .empty
            
        case .start(let goal):
            
            self.instructions.isHidden = true
            self.initialFooter.isHidden = true
            self.playPauseComponent.isHidden = false
            self.dailyProgressComponent.isHidden = false
            
            self.playPauseComponent.configure(with: .play)
            self.circlesComponent.configure(with: .startAnimation)
            self.dailyProgressComponent.configure(with: .initial(current: goal.currentStep,
                                                                 total: goal.goalSteps))
            
            self.contractRelax.text = .empty
            
        case .resume:
            
            self.circlesComponent.configure(with: .startAnimation)
            self.playPauseComponent.configure(with: .play)
            
        case .contract:
            
            self.contractRelax.text = Constants.contract
            
        case .relax:
            
            self.contractRelax.text = Constants.relax
            
        case .stop:
            
            self.playPauseComponent.configure(with: .pause)
            self.circlesComponent.configure(with: .stopAnimation)
    
            self.contractRelax.text = .empty
            
        case .restart:
            
            self.circlesComponent.configure(with: .stopAnimation)
            self.circlesComponent.configure(with: .startAnimation)
            
        case .updateTime(let time):
            
            self.innerCircle.configure(with: .updateNumber(time))
        }
    }
}

extension TrainingView: PlayPauseRestartComponentDelegate {
    
    func playPauseRestartComponentTappedPlay(_ trainingView: PlayPauseRestartComponent) {
        
        self.delegate?.trainingViewWantsToResumeTrain(self)
    }
    
    func playPauseRestartComponentTappedPause(_ trainingView: PlayPauseRestartComponent) {
        
        self.delegate?.trainingViewWantsToStopTrain(self)
    }
    
    func playPauseRestartComponentTappedRestart(_ trainingView: PlayPauseRestartComponent) {
        
        self.delegate?.trainingViewWantsToRestartTrain(self)
    }
}

extension TrainingView {
    
    private func handleTimeUpdate(_ time: Int) {
        
        //TODO
    }
    
}
extension TrainingView {
    
    struct Constants {
        
        static let instructionsLines = 2
        static let initialFooterHeight = 48
        static let initialFooterWidth = 332
        static let playPauseRestartWidth = 124
        static let playPauseRestartHeight = 68
        static let playPauseCenterXOffset = -34
        static let animationRectWidthRatio: CGFloat = 0.75
        static let innerCircleSide = 102
        static let dailyProgressComponentHeight = 36
        static let contract = "CONTRAIR"
        static let relax = "RELAXAR"
    }
}
