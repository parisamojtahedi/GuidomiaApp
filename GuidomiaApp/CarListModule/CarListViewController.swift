//
//  ViewController.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import UIKit

protocol CarListView: AnyObject {
    var presenter: CarListPresenter! { get set }
    var router: CarListRouter? { get set }
    func updateUI(using sections: [TableViewSectionTypes])
    func updateCarSection(using sections: [TableViewSectionTypes])
}
enum TableViewSectionTypes {    
    case image
    case filter(model: FilterTableViewCellModel)
    case car(model: [CarTableViewCellModel])
}
class CarListViewController: UIViewController {
    var presenter: CarListPresenter!
    var router: CarListRouter?
    var selectedRowIndex = IndexPath(row: 0, section: 2)
    var sections: [TableViewSectionTypes] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        let identifiers: [String] = ["ImageTableViewCell"]

        identifiers.forEach({ tableView.register(UINib(nibName: $0, bundle: nil),
                                                 forCellReuseIdentifier: $0) })
        tableView.register(CarTableViewCell.self, forCellReuseIdentifier: "CarTableViewCell")
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .image, .filter:
            return 1
        case .car(let model):
            return model.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
            cell.configure(model: ImageTableViewCellModel(image: UIImage(named: "Tacoma") ?? UIImage(),
                                                          topLabelText: "Guidomia"))
            cell.selectionStyle = .none
            return cell
        case .filter(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
            cell.configure(model: model)
            cell.selectionStyle = .none
            return cell
        case .car(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as? CarTableViewCell else { return UITableViewCell() }
            if indexPath == selectedRowIndex {
                cell.shouldExpand = true
            } else {
                cell.shouldExpand = false
            }
            cell.configure(model: model[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension CarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowIndex = indexPath
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else {
            return UITableView.automaticDimension
        }
    }
}
extension CarListViewController: CarListView {
    func updateUI(using sections: [TableViewSectionTypes]) {
        self.sections = sections
        tableView.reloadData()
    }
    
    func updateCarSection(using sections: [TableViewSectionTypes]) {
        self.sections = sections
        self.tableView.reloadSections(IndexSet(integersIn: 2...2), with: .automatic)

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
