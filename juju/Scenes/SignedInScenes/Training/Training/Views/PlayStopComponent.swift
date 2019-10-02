//
//  PlayPauseComponent.swift
//  juju
//
//  Created by Antonio Portela on 11/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol PlayStopComponentDelegate: AnyObject {
    
    func playStopComponentTappedPlay(_ trainingView: PlayStopComponent)
    func playStopComponentTappedStop(_ trainingView: PlayStopComponent)
}

final class PlayStopComponent: UIView {
    
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
    
    // MARK: Properties
    public weak var delegate: PlayStopComponentDelegate?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension PlayStopComponent: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.playButton)
        self.addSubview(self.stopButton)
    }
    
    func setupConstraints() {
        
        self.playButton.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        self.stopButton.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = .clear
    }
}

extension PlayStopComponent {
    
    @objc
    private func playWasTapped() {
        
        self.delegate?.playStopComponentTappedPlay(self)
    }
    
    @objc
    private func stopWasTapped() {
        
        self.delegate?.playStopComponentTappedStop(self)
    }
}

extension PlayStopComponent: ViewConfiguration {
    
    enum States {
        
        case play
        case stop
    }
    
    func configure(with state: PlayStopComponent.States) {
        
        switch state {
            
        case .play:
            
            self.playButton.isHidden = true
            self.stopButton.isHidden = false
            
        case .stop:
            
            self.playButton.isHidden = false
            self.stopButton.isHidden = true
        }
    }
}
