//
//  ViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DiaryListViewController: UIViewController {
    // MARK: - UI 구성 요소
    private let diaryListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            DiaryListCell.self,
            forCellReuseIdentifier: DiaryListCell.identifier
        )
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.Colors.accentColor
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = Date().toString("MM월")
        return label
    }()
    
    private let monthButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let tintColor = UIConstants.Colors.accentColor ?? .black
        let image = UIConstants.Images.arrowDown?
            .withConfiguration(symbolConfiguration)
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "noting_write_diary"~
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties of Data
    private var viewModel: DiaryListViewModel?
    
    private var deleteItemEvent = PublishSubject<Diary>()
    private var deleteItemTrigger = PublishSubject<Diary>()
    private var didTapLikeButton = PublishSubject<Diary>()
    private var selectedYear = PublishSubject<Int>()
    private var selectedMonth = PublishSubject<Int>()
    private var refresh = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
        bindings()
    }
    
    func setViewModel(with viewModel: DiaryListViewModel) {
        self.viewModel = viewModel
    }
}

private extension DiaryListViewController {
    func bindings() {
        bindingToViewModel()
        bindingFromViewModel()
    }
    
    /// - ViewModel 데이터 관련 바인딩
    func bindingFromViewModel() {
        let viewDidAppear = self.rx.methodInvoked(#selector(viewDidAppear))
            .map { _ in }
            .asObservable()
        
        let input = DiaryListViewModel.Input(
            viewDidAppear: viewDidAppear,
            removeTargetItem: deleteItemTrigger,
            newDiary: didTapLikeButton.asObservable(),
            selectedYear: selectedYear.asObservable(),
            selectedMonth: selectedMonth.asObservable(),
            refresh: refresh.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.diaries
            .bind(
                to: diaryListTableView.rx.items(
                    cellIdentifier: DiaryListCell.identifier,
                    cellType: DiaryListCell.self
                )
            ) { (_, model, cell) in
                cell.selectionStyle = .none
                
                cell.deleteButton.rx.tap
                    .subscribe { [weak self] _ in
                        guard let self = self else { return }
                        self.deleteItemEvent.onNext(model)
                    }
                    .disposed(by: self.disposeBag)
                
                cell.starButton.rx.tap
                    .subscribe { [weak self] _ in
                        guard let self = self else { return }
                        var newModel = model
                        newModel.isLike.toggle()
                        self.didTapLikeButton.onNext(newModel)
                    }
                    .disposed(by: self.disposeBag)
                
                cell.setUpDatas(to: model)
            }
            .disposed(by: disposeBag)
        
        output?.diaries
            .map { $0.isEmpty == false }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output?.removed
            .bind(to: refresh)
            .disposed(by: disposeBag)
    }
    
    /// - UI관련 바인딩
    func bindingToViewModel() {
        monthButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                let viewModel = MonthCalendarViewModel()
                let childController = MonthCalendarViewController(viewModel: viewModel)
                let sheetController = BottomSheetViewController(
                    controller: childController
                )
                
                childController.delegate = self
                
                sheetController.modalPresentationStyle = .overFullScreen
                sheetController.modalTransitionStyle = .coverVertical
                
                self.present(sheetController, animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                let viewModel = DiaryWriteViewModel(
                    diaryWriteUseCase: DefaultDiaryWriteUseCase(
                        diaryRepository: DefaultDiaryRepository(
                            diaryService: DiaryService()
                        )
                    )
                )
                let controller = DiaryWriteViewController(viewModel: viewModel)
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        deleteItemEvent
            .distinctUntilChanged(at: \.id)
            .subscribe { [weak self] diary in
                guard let self = self else { return }
                self.presentDeleteAlert(with: diary)
            }
            .disposed(by: disposeBag)
        
        diaryListTableView.rx.modelSelected(Diary.self)
            .subscribe { [weak self] element in
                guard let self = self, let value = element.element else { return }
                
                self.presentDetailView(with: value.id)
            }
            .disposed(by: disposeBag)
    }
    
    func presentDeleteAlert(with item: Diary) {
        let alertController = UIAlertController(
            title: "delete_alert_title"~,
            message: nil,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "cancel"~, style: .cancel)
        
        let deleteAction = UIAlertAction(title: "delete"~, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.deleteItemTrigger.on(.next(item))
        }
        
        [cancelAction, deleteAction].forEach(alertController.addAction)
        
        self.present(alertController, animated: true)
    }
    
    func presentDetailView(with id: String) {
        let viewModel = DetailDiaryViewModel(
            useCase: DefaultDetailDiaryUseCase(
                id: id,
                repository: DefaultDiaryRepository(
                    diaryService: DiaryService()
                )
            )
        )
        let controller = DetailDiaryViewController(viewModel: viewModel)
        
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension DiaryListViewController: MonthCalendarViewControllerDelegate {
    func monthCalendarViewController(
        monthCalendarViewController: MonthCalendarViewController,
        didTapConfirm selectedDate: (year: Int, month: Int)
    ) {
        titleLabel.text = "\(selectedDate.month + 1)월"
        selectedMonth.onNext(selectedDate.month + 1)
        selectedYear.onNext(selectedDate.year)
    }
}

// MARK: - Navigation Bar UI 구성 코드
private extension DiaryListViewController {
    func configureNavigationBar() {
        navigationItem.titleView = configureTitleStackView()
        
        let addButton = UIBarButtonItem(systemItem: .add)
        addButton.tintColor = UIConstants.Colors.accentColor
        navigationItem.rightBarButtonItem = addButton
        
        configureNavigationAppearance()
    }
    
    func configureTitleStackView() -> UIStackView {
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, monthButton])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 6
        titleStackView.frame.size.width = titleLabel.frame.width + monthButton.frame.width
        titleStackView.frame.size.height = max(titleLabel.frame.height, monthButton.frame.height)
        
        return titleStackView
    }
    
    func configureNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
}

// MARK: - UI 구성 관련 코드
private extension DiaryListViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [diaryListTableView, emptyLabel].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        diaryListTableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
