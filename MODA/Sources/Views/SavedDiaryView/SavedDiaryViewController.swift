//
//  SavedDiaryViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit
import RxSwift

final class SavedDiaryViewController: UIViewController {
    private let savedDiaryListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SavedDiaryCell.self,
            forCellWithReuseIdentifier: SavedDiaryCell.identifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return collectionView
    }()
    
    
    private let mockDatas: Observable<[Diary]> = Observable.of(Diary.mockDatas)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindings()
    }
}

private extension SavedDiaryViewController {
    func bindings() {
        self.mockDatas.bind(
            to: savedDiaryListView.rx.items(
                cellIdentifier: SavedDiaryCell.identifier,
                cellType: SavedDiaryCell.self
            )
        ) { (_, model, cell) in
            cell.setUpData(to: model)
        }
        .disposed(by: disposeBag)
        
        savedDiaryListView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension SavedDiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height * 0.4)
    }
}

private extension SavedDiaryViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [savedDiaryListView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        savedDiaryListView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}