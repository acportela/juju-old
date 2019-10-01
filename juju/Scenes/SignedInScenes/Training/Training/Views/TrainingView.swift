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
    func trainingViewFinishedDailyGoal(_ trainingView: TrainingView)
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
        label.font = Resources.Fonts.Gilroy.bold(ofSize: Styling.FontSize.twenty)
        return label
    }()
    
    private lazy var initialFooter: TrainingFooterButton = {
        
        let view = TrainingFooterButton()
        view.wasTappedCallback = {
            
            self.delegate?.trainingViewWantsToStartTrain(self)
        }
        return view
    }()
    
    private lazy var playPauseComponent: PlayStopRestartComponent = {
        
        let view = PlayStopRestartComponent()
        view.delegate = self
        return view
    }()
    
    private let progressComponent: ProgressComponent = {
        
        let view = ProgressComponent()
        view.isHidden = true
        return view
    }()
    
    private let innerCircle = NumberedCircle(radius: Constants.innerCircleRadius)
    private let circlesComponent = CirclesComponent(time: 5)
    
    // MARK: Properties
    private lazy var timer: TrainingTimer = {
        
        let timer = TrainingTimer()
        timer.timerWasUpdated = { currentTime in
            
            self.handleTimeUpdate(currentTime)
        }
        return timer
    }()
    
    private var currentBladderState: BladderState = .contraction {
        didSet {
            self.contractRelax.text = self.currentBladderState.rawValue.uppercased()
        }
    }
    
    private (set) var trainingModel: TrainingModel = .fallbackTrainingModel {
        didSet {
            self.setInitial()
        }
    }
    
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
        self.addSubview(self.progressComponent)
    }
    
    func setupConstraints() {
       
        self.instructions.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.twentyfour)
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
            make.width.equalToSuperview().multipliedBy(Constants.animationRectWidthRatio)
            make.height.equalTo(self.circlesComponent.snp.width)
        }
        
        self.playPauseComponent.snp.makeConstraints { make in
            make.width.equalTo(Constants.playPauseRestartWidth)
            make.height.equalTo(Constants.playPauseRestartHeight)
            make.left.equalTo(self.snp.centerX).offset(Constants.playPauseCenterXOffset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Styling.Spacing.sixteen)
        }
        
        self.progressComponent.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.eight)
            make.left.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.right.equalToSuperview().offset(-Styling.Spacing.sixteen)
        }
        
        self.contractRelax.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.circlesComponent.snp.top).offset(-Styling.Spacing.twentyfour)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.white
    }
}

// MARK: States
extension TrainingView: ViewConfiguration {
    
    enum BladderState: String {
        
        case contraction = "Contrair"
        case relaxation = "Relaxar"
    }
    
    enum States {
        
        case initialAndLevelChange(TrainingModel)
        case start
        case stop
        case resume
        case contract
        case relax
        case restart
        case updateTime(Int)
    }
    
    func configure(with state: TrainingView.States) {
        
        switch state {
            
        case .initialAndLevelChange(let model):
            
            self.trainingModel = model
            
        case .start:
            
            self.progressComponent.configure(with: .build(current: 0,
                                                          total: self.trainingModel.repetitions))
            self.startTrain()
            
        case .resume:
            
            self.playPauseComponent.configure(with: .play)
            self.circlesComponent.configure(with: .startAnimation)
            self.contractRelax.isHidden = false
            self.timer.start()
            
        case .contract:
            
            self.currentBladderState = .contraction
            
        case .relax:
            
            self.currentBladderState = .relaxation
            
        case .stop:
            
            self.contractRelax.isHidden = true
            self.playPauseComponent.configure(with: .stop)
            self.circlesComponent.configure(with: .stopAnimation)
            self.currentBladderState = .contraction
            self.resetInnerLabel(forState: .contraction)
            self.timer.stop()
            
        case .restart:
            
            self.contractRelax.isHidden = false
            self.currentBladderState = .contraction
            self.resetInnerLabel(forState: .contraction)
            
            self.circlesComponent.configure(with: .restart)
            self.timer.restart()
            
        case .updateTime(let time):
            
            self.innerCircle.configure(with: .updateNumber(time))
        }
    }
}

extension TrainingView {
    
    // MARK: Time handler
    
    private func handleTimeUpdate(_ time: Int) {
        
        switch self.currentBladderState {
            
        case .contraction:
            
            let remainingTime = self.trainingModel.contractionDuration - time
            if remainingTime <= 0 {
                self.currentBladderState = .relaxation
                self.timer.restart()
            }
            
            self.updateInnerLabelFor(remainingTime: remainingTime, state: self.currentBladderState)
            
        case .relaxation:
            
            let remainingTime = self.trainingModel.relaxationDuration - time
            if remainingTime <= 0 {
                
                self.currentBladderState = .contraction
                self.timer.restart()
                self.progressComponent.configure(with: .increment)
            }
            
            self.updateInnerLabelFor(remainingTime: remainingTime, state: self.currentBladderState)
        }
    }
}

extension TrainingView {
    
    // MARK: Helpers for views updates
    private func setInitial() {
        
        let model = self.trainingModel
        
        self.contractRelax.text = .empty
        self.instructions.isHidden = false
        self.playPauseComponent.isHidden = true
        self.progressComponent.isHidden = true
        self.initialFooter.isHidden = false
        
        let footerConfig = TrainingFooterButtonConfiguration(title: "Começar",
                                                             subtitle: "nível \(model.difficulty.title.lowercased())")
        self.initialFooter.configure(with: .initial(footerConfig))
        self.circlesComponent.configure(with: .stopAnimation)
        self.circlesComponent.configure(with: .updateTime(time: model.contractionDuration))
        self.innerCircle.configure(with: .build(number: model.contractionDuration,
                                                color: Styling.Colors.softPinkTwo.withAlphaComponent(0.2)))
        
    }
    
    private func startTrain() {
        
        self.instructions.isHidden = true
        self.initialFooter.isHidden = true
        self.playPauseComponent.isHidden = false
        self.progressComponent.isHidden = false
        
        self.currentBladderState = .contraction
        self.contractRelax.isHidden = false
        
        self.playPauseComponent.configure(with: .play)
        self.circlesComponent.configure(with: .startAnimation)
        self.timer.start()
    }
    
    private func updateInnerLabelFor(remainingTime: Int, state: BladderState) {
        
        if remainingTime > 0 {
            
            self.innerCircle.configure(with: .updateNumber(remainingTime))
            
        } else {
            
            self.resetInnerLabel(forState: state)
        }
    }
    
    private func resetInnerLabel(forState state: BladderState) {
        
        let time = state == .contraction ? self.trainingModel.contractionDuration
                            : self.trainingModel.relaxationDuration
        self.innerCircle.configure(with: .updateNumber(time))
    }
    
}

extension TrainingView: PlayStopRestartComponentDelegate {
    
    func playStopRestartComponentTappedPlay(_ trainingView: PlayStopRestartComponent) {
        
        self.delegate?.trainingViewWantsToResumeTrain(self)
    }
    
    func playStopRestartComponentTappedStop(_ trainingView: PlayStopRestartComponent) {
        
        self.delegate?.trainingViewWantsToStopTrain(self)
    }
    
    func playStopRestartComponentTappedRestart(_ trainingView: PlayStopRestartComponent) {
        
        self.delegate?.trainingViewWantsToRestartTrain(self)
    }
}

extension TrainingView {
    
    struct Constants {
        
        static let instructionsLines = 2
        static let initialFooterHeight = 48
        static let playPauseRestartWidth = 124
        static let playPauseRestartHeight = 68
        static let playPauseCenterXOffset = -34
        static let animationRectWidthRatio: CGFloat = 0.75
        static let innerCircleSide = 103
        static let innerCircleRadius: Float = 51.5
    }
}
