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
        diaryRepository: DefaultDiaryListRepository(
            diaryService: DiaryService()
        )
    )
    
    private var deleteItemEvent = PublishSubject<Diary>()
    private var deleteItemTrigger = PublishSubject<Diary>()
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
            removeTargetItem: deleteItemTrigger
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
                
                let controller = AlertController(title: "보고 싶은 달을 선택해주세요.") {
                    print("Tapped Dismiss Button")
                }
                controller.modalTransitionStyle = .crossDissolve
                controller.modalPresentationStyle = .overFullScreen
                self.present(controller, animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                let controller = DiaryWriteViewController()
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
