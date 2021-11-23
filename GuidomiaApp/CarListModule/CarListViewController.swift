//
//  ViewController.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import UIKit

typealias ImageCellConfigurator = TableCellConfigurator<ImageTableViewCell, ImageTableViewCellModel>
typealias CarCellConfigurator = TableCellConfigurator<CarTableViewCell, CarTableViewCellModel>

protocol CarListView: AnyObject {
    var presenter: CarListPresenter! { get set }
    var router: CarListRouter? { get set }
    func updateUI()
}
class CarListViewController: UIViewController {
    var presenter: CarListPresenter!
    var router: CarListRouter?
    var selectedRowIndex = IndexPath(row: 1, section: 0)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        let identifiers: [String] = ["ImageTableViewCell"]

        identifiers.forEach({ tableView.register(UINib(nibName: $0, bundle: nil),
                                                 forCellReuseIdentifier: $0) })
        tableView.register(CarTableViewCell.self, forCellReuseIdentifier: "CarTableViewCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .zero
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CarListWireframe.buildModule(serviceProvider: ServiceProviderImp(), view: self)
        presenter.onViewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}

extension CarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = presenter?.getItem(for: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId)!
        if let cell = cell as? CarTableViewCell {
            if indexPath == selectedRowIndex {
                cell.shouldExpand = true
            } else {
                cell.shouldExpand = false
            }
        }
        
        item.configure(cell: cell)
        cell.layoutIfNeeded()
        return cell
    }
}
extension CarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndex = indexPath
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            return UITableView.automaticDimension
        }
    }
}
extension CarListViewController: CarListView {
    func updateUI() {
        tableView.reloadData()
    }
}
protocol ConfigurableCell {
    associatedtype CellModel
    func configure(model: CellModel)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, CellModel>: CellConfigurator where CellType.CellModel == CellModel, CellType: UITableViewCell {
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: CellModel

    init(item: CellModel) {
        self.item = item
    }

    func configure(cell: UIView) {
        (cell as! CellType).configure(model: item)
    }
}
