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
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = Date().toString("MM월")
        return label
    }()
    
    private let monthButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let tintColor = UIColor(named: "AccentColor") ?? .black
        let image = UIImage(systemName: "chevron.down.circle.fill")?
            .withConfiguration(symbolConfiguration)
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - Properties of Data
    private let viewModel = DiaryListViewModel(
        diaryListUseCase: DefaultDiaryListUseCase(
            diaryRepository: DefaultDiaryRepository(
                diaryService: DiaryService()
            )
        )
    )
    
    private var deleteItemEvent = PublishSubject<Diary>()
    private var deleteItemTrigger = PublishSubject<Diary>()
    private var selectedYear = PublishSubject<Int>()
    private var selectedMonth = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
        bindings()
    }
}

private extension DiaryListViewController {
    func bindings() {
        bindingToViewModel()
        bindingFromViewModel()
    }
    
    /// - ViewModel 데이터 관련 바인딩
    func bindingFromViewModel() {
        let viewWillAppear = self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asObservable()
        
        let input = DiaryListViewModel.Input(
            viewWillAppear: viewWillAppear,
            removeTargetItem: deleteItemTrigger,
            selectedYear: selectedYear.asObservable(),
            selectedMonth: selectedMonth.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.diaries
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
                
                cell.setUpDatas(to: model)
            }
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
            .bind { [weak self] diary in
                let alertController = UIAlertController(
                    title: "정말 삭제하시겠습니까?",
                    message: nil,
                    preferredStyle: .alert
                )
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                
                let deleteAction = UIAlertAction(
                    title: "삭제",
                    style: .destructive
                ) { _ in
                    self?.deleteItemTrigger.onNext(diary)
                }
                
                [cancelAction, deleteAction].forEach(alertController.addAction)
                self?.present(alertController, animated: true)
            }
            .disposed(by: disposeBag)
        
        diaryListTableView.rx.modelSelected(Diary.self)
            .subscribe { [weak self] element in
                guard let self = self, let value = element.element else { return }
                
                let viewModel = DetailDiaryViewModel(
                    useCase: DefaultDetailDiaryUseCase(
                        id: value.id,
                        repository: DefaultDiaryRepository(
                            diaryService: DiaryService()
                        )
                    )
                )
                let controller = DetailDiaryViewController(viewModel: viewModel)
                
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension DiaryListViewController: MonthCalendarViewControllerDelegate {
    func monthCalendarViewController(
        monthCalendarViewController: MonthCalendarViewController,
        didTapConfirm selectedDate: (year: Int, month: Int)
    ) {
        titleLabel.text = "\(selectedDate.month + 1)월"
        selectedMonth.onNext(selectedDate.month + 1)
        print(selectedDate)
        selectedYear.onNext(selectedDate.year)
    }
}

// MARK: - Navigation Bar UI 구성 코드
private extension DiaryListViewController {
    func configureNavigationBar() {
        navigationItem.titleView = configureTitleStackView()
        
        let addButton = UIBarButtonItem(systemItem: .add)
        addButton.tintColor = UIColor(named: "AccentColor")
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
        [diaryListTableView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        diaryListTableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
