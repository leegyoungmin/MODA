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
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            DiaryListCell.self,
            forCellWithReuseIdentifier: DiaryListCell.identifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = Date().month()
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
    
    private let mockDatas: Observable<[Diary]> = Observable.of(Diary.mockDatas)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        binding()
    }
}

private extension DiaryListViewController {
    func binding() {
        monthButton.rx.tap
            .bind { [weak self] _ in
                guard let _ = self else { return }
                print("Tapped Month Alert Button")
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
        
        self.mockDatas.bind(
            to: collectionView.rx.items(
                cellIdentifier: DiaryListCell.identifier,
                cellType: DiaryListCell.self
            )
        ) { (_, model, cell) in
            cell.setUpDatas(to: model)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension DiaryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.width / 2)
    }
}

private extension DiaryListViewController {
    func configureUI() {
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [collectionView].forEach(view.addSubview)
    }
    
    func configureNavigationBar() {
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, monthButton])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 6
        titleStackView.frame.size.width = titleLabel.frame.width + monthButton.frame.width
        titleStackView.frame.size.height = max(titleLabel.frame.height, monthButton.frame.height)
        navigationItem.titleView = titleStackView
        
        let addButton = UIBarButtonItem(systemItem: .add)
        addButton.tintColor = UIColor(named: "AccentColor")
        navigationItem.rightBarButtonItem = addButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
