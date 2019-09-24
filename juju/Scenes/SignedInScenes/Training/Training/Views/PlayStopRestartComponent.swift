//
//  PlayPauseRestartComponent.swift
//  juju
//
//  Created by Antonio Portela on 11/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol PlayStopRestartComponentDelegate: AnyObject {
    
    func playStopRestartComponentTappedPlay(_ trainingView: PlayStopRestartComponent)
    func playStopRestartComponentTappedStop(_ trainingView: PlayStopRestartComponent)
    func playStopRestartComponentTappedRestart(_ trainingView: PlayStopRestartComponent)
}

final class PlayStopRestartComponent: UIView {
    
    // MARK: Views
    private lazy var playButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.playButton, for: .normal)
        button.addTarget(self, action: #selector(self.playWasTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.stopButton, for: .normal)
        button.addTarget(self, action: #selector(self.stopWasTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var restartButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.replayButton, for: .normal)
        button.addTarget(self, action: #selector(self.restartWasTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Properties
    public weak var delegate: PlayStopRestartComponentDelegate?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension PlayStopRestartComponent: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.playButton)
        self.addSubview(self.stopButton)
        self.addSubview(self.restartButton)
    }
    
    func setupConstraints() {
        
        self.playButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.playStopSides)
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.restartButton.snp.left).offset(-Styling.Spacing.thirtytwo)
        }
        
        self.stopButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.playStopSides)
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.restartButton.snp.left).offset(-Styling.Spacing.thirtytwo)
        }
        
        self.restartButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.repeatSides)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = .clear
    }
}

extension PlayStopRestartComponent {
    
    @objc
    private func playWasTapped() {
        
        self.delegate?.playStopRestartComponentTappedPlay(self)
    }
    
    @objc
    private func stopWasTapped() {
        
        self.delegate?.playStopRestartComponentTappedStop(self)
    }
    
    @objc
    private func restartWasTapped() {
        
        self.delegate?.playStopRestartComponentTappedRestart(self)
    }
}

extension PlayStopRestartComponent: ViewConfiguration {
    
    enum States {
        
        case play
        case stop
        case restart
    }
    
    func configure(with state: PlayStopRestartComponent.States) {
        switch state {
        case .play:
            
            self.playButton.isHidden = true
            self.stopButton.isHidden = false
            
        case .stop:
            
            self.playButton.isHidden = false
            self.stopButton.isHidden = true
            
        case .restart:
            
            self.playButton.isHidden = true
            self.stopButton.isHidden = false
        }
    }
}

extension PlayStopRestartComponent {
    
    struct Constants {
        
        static let repeatSides = 24
        static let playStopSides = 68
    }
}
