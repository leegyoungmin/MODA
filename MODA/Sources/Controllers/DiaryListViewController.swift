//
//  ViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit

class DiaryListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        return tableView
    }()
    
    private let mockDatas: [Diary] = Diary.mockDatas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        configureUI()
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryListCell.identifier,
            for: indexPath
        ) as? DiaryListCell else {
            return UITableViewCell()
        }
        
        let item = mockDatas[indexPath.row]
        cell.setUpDatas(to: item)
        
        return cell
    }
}

private extension DiaryListViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [tableView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
