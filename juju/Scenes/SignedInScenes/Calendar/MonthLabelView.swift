//
//  MonthLabelView.swift
//  juju
//
//  Created by Antonio Rodrigues on 16/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

final class MonthLabelView: JTACMonthReusableView {
    
    // MARK: Views
    private let month: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension MonthLabelView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.month)
    }
    
    func setupConstraints() {
        
        self.month.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = .clear
    }
}

extension MonthLabelView: ViewConfiguration {
    
    enum States {
        
        case build(title: String)
    }
    
    func configure(with state: MonthLabelView.States) {
    
        switch state {
            
        case .build(let title):
            
            self.month.text = title
        }
    }
}

extension MonthLabelView {
    
    struct Constants {
        
        static let reuseIdentifier = "MonthLabelView"
    }
}
