//
//  CalendarViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 15/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class CalendarViewController: UIViewController, Loadable {
    
    public static let title = "Diário"
    private let calendarView: CalendarView
    private let dataSource: CalendarDataSource
    private let dateUtils = DateUtils()
    private let initialCalendarRange: DateRange

    let loadingController = LoadingViewController(animatable: JujuLoader())

    init(diaryService: TrainingDiaryServiceProtocol,
         user: ClientUser) {

        // TODO: Change this for better data saving
        let startDate = self.dateUtils.getStartOf(.year)
        let endDate = self.dateUtils.getStartOfNext(.year)
        self.initialCalendarRange = DateRange(from: startDate, to: endDate)

        self.calendarView = CalendarView(initialRange: self.initialCalendarRange)
        self.dataSource = CalendarDataSource(user: user,
                                             diaryService: diaryService)
        super.init(nibName: nil, bundle: nil)
        self.dataSource.delegate = self
        self.calendarView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = self.calendarView
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureNavigation()
        self.calendarView.configure(with: .build)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.initialSetup()
    }

    private func configureNavigation() {
        
        self.title = CalendarViewController.title
        
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }

    private func initialSetup() {

        self.startLoading()
        self.calendarView.addUrineAction = { self.showUrineInsertionScreen() }
        self.dataSource.fetchDiary(withRange: self.initialCalendarRange)
    }

    private func setErrorState() {

        Snackbar.showError(message: "Ocorreu um erro. Por favor, tente novamente", in: self.view)
    }
}

extension CalendarViewController {

    private func showUrineInsertionScreen() {

        let urineInsertionViewController = UrineInsertionViewController()
        urineInsertionViewController.delegate = self
        urineInsertionViewController.modalPresentationStyle = .overCurrentContext

        self.present(urineInsertionViewController, animated: false, completion: nil)
    }

    private func showDiarySummaryForProgress(_ diary: DiaryProgress) {

        let summaryViewController = DaySummaryViewController(diary: diary)
        summaryViewController.modalPresentationStyle = .overCurrentContext

        self.present(summaryViewController, animated: false, completion: nil)
    }
}

extension CalendarViewController: CalendarDataSourceDelegate {

    func calendarDataSourceDidFetchDiaries(_ dataSource: CalendarDataSource, diaries: [DiaryProgress]) {

        self.stopLoading()
        self.calendarView.diary = diaries
    }

    func calendarDataSourceFailedFetchingDiaries(_ dataSource: CalendarDataSource) {

        self.stopLoading()
        self.setErrorState()
    }
}

extension CalendarViewController: CalendarViewDelegate {

    func calendarViewWantsToShowSummary(_ calendarView: CalendarView,
                                        forDiary diary: DiaryProgress) {

        self.showDiarySummaryForProgress(diary)
    }
}

extension CalendarViewController: UrineInsertionViewControllerDelegate {

    func urineInsertionViewControllerDidSelectLoss(_ controller: UrineInsertionViewController,
                                                   urineLoss: UrineLoss) {
        
    }
}
