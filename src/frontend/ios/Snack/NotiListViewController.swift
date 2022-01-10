//
//  NotiListViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

class NotiListViewController: UITableViewController {

    private let organization = "GeonHyeongKim"
    private let notilist = BehaviorSubject<[Noti]>(value: [])
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = organization + " Repositories"
        
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.register(NotiListTableViewCell.self, forCellReuseIdentifier: "NotiListTableViewCell")
        tableView.rowHeight = 140
        refresh()
    }
    
    @objc func refresh() {
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self = self else { return }
            self.fetchRepositories(of: self.organization)
        }
    }
    
    func fetchRepositories(of organization: String) {
        Observable.from([organization])
            .map { organization -> URL in
                return URL(string: "https://api.github.com/users/\(organization)/repos")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else {
                    return []
                }
                return result
            }
            .filter { objects in
                return objects.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> Noti? in
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                        return nil
                    }
                    
                    return Noti(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
                }
            }
            .subscribe(onNext: {[weak self] newRepositories in
                self?.notilist.onNext(newRepositories)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: bag)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try notilist.value().count
        } catch {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotiListTableViewCell", for: indexPath) as? NotiListTableViewCell else { return UITableViewCell() }
        
        var currentNoti: Noti? {
            do {
                return try notilist.value()[indexPath.row]
            } catch {
                return nil
            }
        }
        
        cell.noti = currentNoti
        
        return cell
    }
}
