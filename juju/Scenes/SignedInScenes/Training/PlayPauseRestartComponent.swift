//
//  PlayPauseRestartComponent.swift
//  juju
//
//  Created by Antonio Portela on 11/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol PlayPauseRestartComponentDelegate: AnyObject {
    
    func playPauseRestartComponentTappedPlay(_ trainingView: PlayPauseRestartComponent)
    func playPauseRestartComponentTappedPause(_ trainingView: PlayPauseRestartComponent)
    func playPauseRestartComponentTappedRestart(_ trainingView: PlayPauseRestartComponent)
}

final class PlayPauseRestartComponent: UIView {
    
    // MARK: Views
    private lazy var playButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.playButton, for: .normal)
        button.addTarget(self, action: #selector(self.playWasTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Resources.Images.pauseButton, for: .normal)
        button.addTarget(self, action: #selector(self.pauseWasTapped), for: .touchUpInside)
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
    public weak var delegate: PlayPauseRestartComponentDelegate?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension PlayPauseRestartComponent: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.playButton)
        self.addSubview(self.pauseButton)
        self.addSubview(self.restartButton)
    }
    
    func setupConstraints() {
        
        self.playButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.playPauseSides)
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.restartButton.snp.left).offset(-Styling.Spacing.thirtytwo)
        }
        
        self.pauseButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.playPauseSides)
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

extension PlayPauseRestartComponent {
    
    @objc
    private func playWasTapped() {
        
        self.delegate?.playPauseRestartComponentTappedPlay(self)
    }
    
    @objc
    private func pauseWasTapped() {
        
        self.delegate?.playPauseRestartComponentTappedPause(self)
    }
    
    @objc
    private func restartWasTapped() {
        
        self.delegate?.playPauseRestartComponentTappedRestart(self)
    }
}

extension PlayPauseRestartComponent: ViewConfiguration {
    
    enum States {
        
        case play
        case pause
        case restart
    }
    
    func configure(with state: PlayPauseRestartComponent.States) {
        switch state {
        case .play:
            
            self.playButton.isHidden = true
            self.pauseButton.isHidden = false
            
        case .pause:
            
            self.playButton.isHidden = false
            self.pauseButton.isHidden = true
            
        case .restart:
            
            self.playButton.isHidden = true
            self.pauseButton.isHidden = false
        }
    }
}

extension PlayPauseRestartComponent {
    
    struct Constants {
        
        static let repeatSides = 24
        static let playPauseSides = 68
    }
}
