//
//  CalendarView.swift
//  juju
//
//  Created by Antonio Rodrigues on 15/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

// TODO: Remove force unwraps

final class CalendarView: UIView {
    
    // MARK: Views
    private lazy var jtCalendar: JTACMonthView = {
        
        let calendar = JTACMonthView()
        calendar.register(DateCircleView.self,
                          forCellWithReuseIdentifier: DateCircleView.Constants.dateCellItendifier)
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        calendar.scrollDirection = .horizontal
        calendar.scrollingMode = .stopAtEachCalendarFrame
        calendar.allowsMultipleSelection = false
        calendar.showsHorizontalScrollIndicator = false
        calendar.layer.cornerRadius = 4
        calendar.layer.masksToBounds = true
        calendar.backgroundColor = Styling.Colors.white
        calendar.register(MonthLabelView.self,
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: MonthLabelView.Constants.reuseIdentifier)
        return calendar
    }()
    
    private let buttonAddUrine = JujuButtonWithAccessory()
    
    var addUrineAction: (() -> Void)? {
        didSet {
            buttonAddUrine.wasTappedCallback = addUrineAction
        }
    }
    
    private let monthFormatter = DateFormatter()

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension CalendarView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.jtCalendar)
        self.addSubview(self.buttonAddUrine)
    }
    
    func setupConstraints() {
        
        self.jtCalendar.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
            make.left.equalToSuperview().offset(Styling.Spacing.twentyfour)
            make.right.equalToSuperview().offset(-Styling.Spacing.twentyfour)
            make.height.equalTo(self.jtCalendar.snp.width)
        }
        
        self.buttonAddUrine.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(self.jtCalendar.snp.bottom).offset(Styling.Spacing.thirtytwo)
            make.left.equalToSuperview().offset(Styling.Spacing.thirtytwo)
            make.right.equalToSuperview().offset(-Styling.Spacing.thirtytwo)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.veryLightPink
        monthFormatter.dateFormat = "MMMM"
    }
}

extension CalendarView: ViewConfiguration {
    
    enum States {
        
        case build
    }
    
    func configure(with state: CalendarView.States) {
    
        switch state {
            
        case .build:
            
            let buttonConfig = JujuButtonWithAccessoryConfiguration(title: "Adicionar perda de urina",
                                                                    subtitle: .empty,
                                                                    accessoryImage: Resources.Images.urineDropCircle)
            self.buttonAddUrine.configure(with: .initial(buttonConfig))
        }
    }
}

extension CalendarView {
    
    func reload() {
        
        self.jtCalendar.reloadData()
    }
}

extension CalendarView {
    
    struct Constants {
        
        static let buttonHeight: CGFloat = 48
    }
}

extension CalendarView: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView,
                  willDisplay cell: JTACDayCell,
                  forItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) {
        
        guard let cell = cell as? DateCircleView  else { return }
        cell.configure(with: .circleAndDrop)
        cell.configure(with: .setText(cellState.text))
    }
    
    
    func calendar(_ calendar: JTACMonthView,
                  cellForItemAt date: Date,
                  cellState: CellState,
                  indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCircleView.Constants.dateCellItendifier,
                                                       for: indexPath) as! DateCircleView
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
}

extension CalendarView: JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy MM dd"
        let startDate = dayFormatter.date(from: "2018 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 5,
                                       generateInDates: .off,
                                       generateOutDates: .off,
                                       firstDayOfWeek: .sunday)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
   
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: MonthLabelView.Constants.reuseIdentifier,
                                                                      for: indexPath) as! MonthLabelView
   
        let title = monthFormatter.string(from: range.start)
        header.configure(with: .build(title: title))
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}
