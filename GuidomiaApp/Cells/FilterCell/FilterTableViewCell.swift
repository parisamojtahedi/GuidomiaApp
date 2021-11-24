//
//  FilterTableViewCell.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-23.
//

import UIKit

struct FilterQuery {
    let searchText: String
    let filter: SearchfilterType
}
struct FilterTableViewCellModel {
    var reloadClosure: ((FilterQuery) -> Void)?
}
class FilterTableViewCell: UITableViewCell, ConfigurableCell {
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Filters"
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()
    
    private lazy var makeSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Any make"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        searchBar.tag = 0
        searchBar.returnKeyType = .done
        return searchBar
    }()
    
    private lazy var modelSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.placeholder = "Any model"
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .done
        searchBar.tag = 1
        return searchBar
    }()
    
    var reloadClosure: ((FilterQuery) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hexString: "#858585")
        contentView.addSubview(titleLabel)
        contentView.addSubview(makeSearchBar)
        contentView.addSubview(modelSearchBar)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        makeSearchBar.translatesAutoresizingMaskIntoConstraints = false
        makeSearchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        makeSearchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        makeSearchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        modelSearchBar.translatesAutoresizingMaskIntoConstraints = false
        modelSearchBar.topAnchor.constraint(equalTo: makeSearchBar.bottomAnchor).isActive = true
        modelSearchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        modelSearchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        modelSearchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
//        containerView.addArrangedSubview(topStackView)
//        contentView.addSubview(containerView)
//        contentView.addSubview(separatorLine)
//        containerView.addArrangedSubview(proConsView)
//        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: FilterTableViewCellModel) {
        self.reloadClosure = model.reloadClosure
    }

}
extension FilterTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let closure = reloadClosure {
            let query = FilterQuery(searchText: searchText,
                        filter: searchBar.tag == 0 ? .make : .model)
            closure(query)
        }
    }
}
